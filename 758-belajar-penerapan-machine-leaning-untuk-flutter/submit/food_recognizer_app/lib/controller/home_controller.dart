import 'dart:io';

import 'package:flutter/material.dart';

import 'package:submission/services/food_classifier_service.dart';
import 'package:submission/services/image_source_service.dart';

enum ModelLoadStatus { loading, ready, error }

/// Mengelola state Home Page: status pemuatan model ML, gambar yang sedang
/// dipilih/di-crop pengguna, serta navigasi ke halaman berikutnya.
class HomeController extends ChangeNotifier {
  final FoodClassifierService classifierService;
  final ImageSourceService imageSourceService;

  HomeController({
    required this.classifierService,
    required this.imageSourceService,
  }) {
    _loadModel();
  }

  ModelLoadStatus _modelStatus = ModelLoadStatus.loading;
  ModelLoadStatus get modelStatus => _modelStatus;

  String? _modelError;
  String? get modelError => _modelError;

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  bool _isPicking = false;
  bool get isPicking => _isPicking;

  String? _pickError;
  String? get pickError => _pickError;

  bool get isModelReady => _modelStatus == ModelLoadStatus.ready;

  Future<void> _loadModel() async {
    _modelStatus = ModelLoadStatus.loading;
    notifyListeners();

    try {
      await classifierService.loadModel();
      _modelStatus = ModelLoadStatus.ready;
    } catch (error) {
      _modelStatus = ModelLoadStatus.error;
      _modelError = error.toString();
    }
    notifyListeners();
  }

  Future<void> retryLoadModel() => _loadModel();

  Future<void> pickFromCamera() => _pick(imageSourceService.pickFromCamera);

  Future<void> pickFromGallery() => _pick(imageSourceService.pickFromGallery);

  Future<void> _pick(Future<File?> Function() picker) async {
    _isPicking = true;
    _pickError = null;
    notifyListeners();

    try {
      final file = await picker();
      if (file != null) {
        _selectedImage = file;
      }
    } catch (error) {
      _pickError = 'Gagal mengambil gambar: $error';
    }

    _isPicking = false;
    notifyListeners();
  }

  Future<void> cropSelectedImage() async {
    final current = _selectedImage;
    if (current == null) return;

    _isPicking = true;
    notifyListeners();

    try {
      final cropped = await imageSourceService.cropImage(current.path);
      if (cropped != null) {
        _selectedImage = cropped;
      }
    } catch (error) {
      _pickError = 'Gagal memotong gambar: $error';
    }

    _isPicking = false;
    notifyListeners();
  }

  void clearSelectedImage() {
    _selectedImage = null;
    _pickError = null;
    notifyListeners();
  }

  void setSelectedImage(File file) {
    _selectedImage = file;
    notifyListeners();
  }

  // Catatan: siklus hidup `classifierService` dikelola oleh `Provider` di
  // main.dart (dispose saat root widget dibuang), bukan oleh controller ini,
  // karena instance yang sama juga dipakai oleh ResultController.
}
