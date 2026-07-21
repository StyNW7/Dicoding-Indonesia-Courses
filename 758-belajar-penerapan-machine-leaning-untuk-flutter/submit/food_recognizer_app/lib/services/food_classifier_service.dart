import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as image_lib;
import 'package:tflite_flutter/tflite_flutter.dart';

import 'package:submission/core/app_constants.dart';
import 'package:submission/models/food_prediction.dart';

/// Data yang dikirim ke [compute] untuk didekode & di-resize pada isolate
/// terpisah, supaya proses yang cukup berat ini tidak membekukan UI.
class _PreprocessRequest {
  final Uint8List bytes;
  final int inputSize;

  const _PreprocessRequest({required this.bytes, required this.inputSize});
}

/// Menjalankan decode + resize gambar pada isolate terpisah (lewat
/// [compute]), lalu mengembalikan data pixel RGB planar yang siap
/// dikonversi ke tensor.
Future<image_lib.Image> _decodeAndResize(_PreprocessRequest request) async {
  final decoded = image_lib.decodeImage(request.bytes);
  if (decoded == null) {
    throw const FormatException('Gagal mendekode gambar. Berkas mungkin rusak.');
  }
  return image_lib.copyResize(
    decoded,
    width: request.inputSize,
    height: request.inputSize,
    interpolation: image_lib.Interpolation.linear,
  );
}

/// Service yang membungkus LiteRT (TensorFlow Lite) untuk mengklasifikasi
/// gambar makanan. Inferensi dijalankan pada background isolate lewat
/// [IsolateInterpreter] bawaan `tflite_flutter` agar UI tidak freeze
/// (Kriteria 2 - Skilled).
class FoodClassifierService {
  Interpreter? _interpreter;
  IsolateInterpreter? _isolateInterpreter;
  List<String> _labels = const [];

  bool get isReady => _interpreter != null && _isolateInterpreter != null;

  int get inputSize => AppConstants.modelInputSize;

  /// Memuat model + label dari assets bundel aplikasi.
  Future<void> loadModel() async {
    final interpreter = await Interpreter.fromAsset(AppConstants.modelAssetPath);

    _isolateInterpreter = await IsolateInterpreter.create(
      address: interpreter.address,
      debugName: 'FoodClassifierIsolate',
    );
    _interpreter = interpreter;
    _labels = await _loadLabels();
  }

  Future<List<String>> _loadLabels() async {
    final raw = await rootBundle.loadString(AppConstants.labelsAssetPath);
    return raw
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList(growable: false);
  }

  /// Klasifikasi gambar statis (hasil kamera/galeri) dari path berkas.
  Future<FoodPrediction> classifyImageFile(String imagePath) async {
    final bytes = await File(imagePath).readAsBytes();
    return classifyImageBytes(bytes);
  }

  /// Klasifikasi gambar dari raw bytes (dipakai juga oleh camera stream
  /// setelah frame dikonversi menjadi JPEG/PNG bytes).
  Future<FoodPrediction> classifyImageBytes(Uint8List bytes) async {
    _ensureReady();

    // Tahap 1: decode + resize di isolate terpisah (compute) -- pekerjaan
    // paling berat sebelum inferensi, supaya UI tetap responsif.
    final resized = await compute(
      _decodeAndResize,
      _PreprocessRequest(bytes: bytes, inputSize: inputSize),
    );

    return _runInference(resized);
  }

  /// Klasifikasi langsung dari objek [image_lib.Image] yang sudah didekode
  /// (dipakai oleh camera feed real-time supaya tidak perlu decode ulang).
  Future<FoodPrediction> classifyDecodedImage(image_lib.Image image) async {
    _ensureReady();
    final resized = image.width == inputSize && image.height == inputSize
        ? image
        : image_lib.copyResize(
            image,
            width: inputSize,
            height: inputSize,
            interpolation: image_lib.Interpolation.linear,
          );
    return _runInference(resized);
  }

  Future<FoodPrediction> _runInference(image_lib.Image resized) async {
    final interpreter = _interpreter!;
    final isolateInterpreter = _isolateInterpreter!;

    final inputTensor = interpreter.getInputTensor(0);
    final outputTensor = interpreter.getOutputTensor(0);

    final input = _imageToInputTensor(resized, inputTensor);
    final outputBuffer = _emptyOutputBuffer(outputTensor);

    await isolateInterpreter.run(input, outputBuffer);

    final probabilities = _outputToProbabilities(outputBuffer, outputTensor);
    return _topPrediction(probabilities);
  }

  /// Mengonversi gambar RGB menjadi tensor input 4D `[1, h, w, 3]`,
  /// menyesuaikan tipe data (float32 dinormalisasi 0..1, atau uint8/int8
  /// mentah) berdasarkan tipe tensor input model yang sesungguhnya.
  Object _imageToInputTensor(image_lib.Image image, Tensor inputTensor) {
    final h = image.height;
    final w = image.width;

    if (inputTensor.type == TensorType.float32) {
      return List.generate(
        1,
        (_) => List.generate(
          h,
          (y) => List.generate(w, (x) {
            final pixel = image.getPixel(x, y);
            return [
              pixel.rNormalized.toDouble(),
              pixel.gNormalized.toDouble(),
              pixel.bNormalized.toDouble(),
            ];
          }),
        ),
      );
    }

    // Model terkuantisasi (uint8/int8): gunakan nilai pixel mentah 0-255,
    // lalu geser sesuai zero point bila modelnya int8.
    final zeroPoint = inputTensor.type == TensorType.int8 ? -128 : 0;
    return List.generate(
      1,
      (_) => List.generate(
        h,
        (y) => List.generate(w, (x) {
          final pixel = image.getPixel(x, y);
          return [
            pixel.r.toInt() + zeroPoint,
            pixel.g.toInt() + zeroPoint,
            pixel.b.toInt() + zeroPoint,
          ];
        }),
      ),
    );
  }

  Object _emptyOutputBuffer(Tensor outputTensor) {
    final numClasses = outputTensor.shape.last;
    return [List.filled(numClasses, 0.0)];
  }

  List<double> _outputToProbabilities(Object outputBuffer, Tensor outputTensor) {
    final raw = (outputBuffer as List).first as List;

    if (outputTensor.type == TensorType.float32) {
      return raw.map((e) => (e as num).toDouble()).toList(growable: false);
    }

    // Dequantize jika output model masih dalam bentuk quantized integer.
    final params = outputTensor.params;
    final scale = params.scale == 0 ? 1.0 : params.scale;
    final zeroPoint = params.zeroPoint;
    return raw
        .map((e) => ((e as num).toInt() - zeroPoint) * scale)
        .toList(growable: false);
  }

  FoodPrediction _topPrediction(List<double> probabilities) {
    var bestIndex = 0;
    var bestScore = probabilities.isEmpty ? 0.0 : probabilities[0];

    for (var i = 1; i < probabilities.length; i++) {
      if (probabilities[i] > bestScore) {
        bestScore = probabilities[i];
        bestIndex = i;
      }
    }

    final label = bestIndex < _labels.length ? _labels[bestIndex] : 'Unknown';
    return FoodPrediction(label: label, confidence: bestScore.clamp(0.0, 1.0));
  }

  void _ensureReady() {
    if (!isReady) {
      throw StateError('Model belum dimuat. Panggil loadModel() terlebih dahulu.');
    }
  }

  Future<void> close() async {
    await _isolateInterpreter?.close();
    _interpreter?.close();
    _interpreter = null;
    _isolateInterpreter = null;
  }
}
