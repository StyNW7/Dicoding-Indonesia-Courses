import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:submission/core/app_theme.dart';

/// Membungkus `image_picker` (ambil gambar dari kamera/galeri) dan
/// `image_cropper` (crop bagian penting gambar) dalam satu service, supaya
/// controller/UI tidak berurusan langsung dengan API platform.
class ImageSourceService {
  final ImagePicker _picker = ImagePicker();
  final ImageCropper _cropper = ImageCropper();

  /// Membuka kamera bawaan perangkat lewat `image_picker` (Kriteria 1 - Basic).
  Future<File?> pickFromCamera() async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
      maxWidth: 1600,
    );
    return picked == null ? null : File(picked.path);
  }

  /// Membuka galeri lewat `image_picker`.
  Future<File?> pickFromGallery() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
      maxWidth: 1600,
    );
    return picked == null ? null : File(picked.path);
  }

  /// Memotong bagian penting gambar (Kriteria 1 - Skilled).
  Future<File?> cropImage(String sourcePath) async {
    final cropped = await _cropper.cropImage(
      sourcePath: sourcePath,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Potong Gambar',
          toolbarColor: AppColors.seed,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
          hideBottomControls: false,
        ),
        IOSUiSettings(
          title: 'Potong Gambar',
          aspectRatioLockEnabled: false,
        ),
      ],
    );
    return cropped == null ? null : File(cropped.path);
  }
}
