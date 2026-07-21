import 'dart:io';

import 'package:flutter/material.dart';

import 'package:submission/core/app_constants.dart';
import 'package:submission/models/food_prediction.dart';
import 'package:submission/services/food_classifier_service.dart';

enum ClassificationStatus { loading, success, error }

/// Mengelola state Result Page: menjalankan inferensi model terhadap
/// gambar yang dipilih pengguna, lalu menyimpan hasil prediksinya.
class ResultController extends ChangeNotifier {
  final FoodClassifierService classifierService;
  final File imageFile;

  ResultController({required this.classifierService, required this.imageFile}) {
    classify();
  }

  ClassificationStatus _status = ClassificationStatus.loading;
  ClassificationStatus get status => _status;

  FoodPrediction? _prediction;
  FoodPrediction? get prediction => _prediction;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Makanan dianggap tidak valid/tidak dikenali jika confidence terlalu
  /// rendah atau modelnya justru mengembalikan kelas `__background__`.
  bool get isRecognized =>
      _prediction != null &&
      _prediction!.label != AppConstants.backgroundLabel &&
      _prediction!.confidence >= AppConstants.minConfidenceThreshold;

  Future<void> classify() async {
    _status = ClassificationStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await classifierService.classifyImageFile(imageFile.path);
      _prediction = result;
      _status = ClassificationStatus.success;
    } catch (error) {
      _status = ClassificationStatus.error;
      _errorMessage = 'Gagal menganalisis gambar: $error';
    }

    notifyListeners();
  }
}
