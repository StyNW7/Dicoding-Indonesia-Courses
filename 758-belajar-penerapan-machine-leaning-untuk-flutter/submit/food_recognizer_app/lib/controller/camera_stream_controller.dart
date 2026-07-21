import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:submission/core/camera_image_converter.dart';
import 'package:submission/models/food_prediction.dart';
import 'package:submission/services/food_classifier_service.dart';

enum CameraStreamStatus { initializing, streaming, error }

/// Mengelola sesi kamera real-time (camera feed) untuk identifikasi
/// makanan secara langsung tanpa perlu menekan tombol jepret berulang kali
/// (Kriteria 1 - Advanced).
///
/// Setiap frame yang masuk dikonversi lalu diklasifikasi, tetapi frame baru
/// akan DIABAIKAN selama masih ada proses inferensi berjalan (throttling)
/// supaya tidak menumpuk pekerjaan pada isolate inferensi.
class CameraStreamController extends ChangeNotifier {
  final FoodClassifierService classifierService;

  CameraStreamController({required this.classifierService}) {
    _initialize();
  }

  CameraController? _cameraController;
  CameraController? get cameraController => _cameraController;

  CameraStreamStatus _status = CameraStreamStatus.initializing;
  CameraStreamStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  FoodPrediction? _livePrediction;
  FoodPrediction? get livePrediction => _livePrediction;

  bool _isProcessingFrame = false;
  bool _isCapturing = false;
  bool get isCapturing => _isCapturing;

  Future<void> _initialize() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _status = CameraStreamStatus.error;
        _errorMessage = 'Tidak ditemukan kamera pada perangkat ini.';
        notifyListeners();
        return;
      }

      final backCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await controller.initialize();
      _cameraController = controller;
      _status = CameraStreamStatus.streaming;
      notifyListeners();

      await controller.startImageStream(_onFrame);
    } catch (error) {
      _status = CameraStreamStatus.error;
      _errorMessage = 'Gagal memulai kamera: $error';
      notifyListeners();
    }
  }

  Future<void> _onFrame(CameraImage cameraImage) async {
    if (_isProcessingFrame || _isCapturing || !classifierService.isReady) return;
    _isProcessingFrame = true;

    try {
      final rotation = _cameraController?.description.sensorOrientation ?? 0;
      var decoded = CameraImageConverter.convert(cameraImage);
      decoded = CameraImageConverter.rotate(decoded, rotation);

      final prediction = await classifierService.classifyDecodedImage(decoded);
      _livePrediction = prediction;
      notifyListeners();
    } catch (_) {
      // Abaikan error per-frame supaya stream tetap berjalan; kegagalan
      // sesaat tidak perlu menghentikan seluruh sesi kamera.
    } finally {
      _isProcessingFrame = false;
    }
  }

  /// Mengambil satu foto still dari sesi kamera yang sedang berjalan, untuk
  /// dianalisis ulang & ditampilkan di Result/Detail Page (konsisten dengan
  /// alur gambar dari kamera/galeri biasa).
  Future<File?> captureStill() async {
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) return null;

    _isCapturing = true;
    notifyListeners();

    try {
      if (controller.value.isStreamingImages) {
        await controller.stopImageStream();
      }
      final xFile = await controller.takePicture();
      return File(xFile.path);
    } finally {
      _isCapturing = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    final controller = _cameraController;
    if (controller != null) {
      if (controller.value.isStreamingImages) {
        controller.stopImageStream();
      }
      controller.dispose();
    }
    super.dispose();
  }
}
