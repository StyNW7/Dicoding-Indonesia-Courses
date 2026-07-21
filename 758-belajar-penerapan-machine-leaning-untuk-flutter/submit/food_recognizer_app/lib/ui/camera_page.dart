import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:submission/controller/camera_stream_controller.dart';
import 'package:submission/core/app_theme.dart';
import 'package:submission/services/food_classifier_service.dart';
import 'package:submission/ui/result_page.dart';
import 'package:submission/widget/confidence_badge.dart';
import 'package:submission/widget/error_banner.dart';

/// Halaman identifikasi makanan secara real-time lewat camera feed
/// (Kriteria 1 - Advanced), menampilkan prediksi model yang terus
/// diperbarui selagi kamera aktif. Pengguna bisa menekan tombol jepret
/// untuk mengambil satu foto still & melanjutkan ke Result Page.
class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CameraStreamController(
        classifierService: context.read<FoodClassifierService>(),
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: const Text('Kamera Real-Time'),
        ),
        body: const _CameraBody(),
      ),
    );
  }
}

class _CameraBody extends StatelessWidget {
  const _CameraBody();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CameraStreamController>();

    switch (controller.status) {
      case CameraStreamStatus.initializing:
        return const Center(child: CircularProgressIndicator(color: Colors.white));

      case CameraStreamStatus.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: ErrorBanner(message: controller.errorMessage ?? 'Gagal memulai kamera.'),
          ),
        );

      case CameraStreamStatus.streaming:
        final cameraController = controller.cameraController!;
        return Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: cameraController.value.aspectRatio,
                child: CameraPreview(cameraController),
              ),
            ),
            Positioned(
              top: AppSpacing.md,
              left: AppSpacing.md,
              right: AppSpacing.md,
              child: _LivePredictionBadge(controller: controller),
            ),
            Positioned(
              bottom: AppSpacing.xl,
              left: 0,
              right: 0,
              child: Center(child: _CaptureButton(controller: controller)),
            ),
          ],
        );
    }
  }
}

class _LivePredictionBadge extends StatelessWidget {
  final CameraStreamController controller;

  const _LivePredictionBadge({required this.controller});

  @override
  Widget build(BuildContext context) {
    final prediction = controller.livePrediction;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: prediction == null
          ? const Text(
              'Arahkan kamera ke makanan...',
              style: TextStyle(color: Colors.white),
            )
          : Row(
              children: [
                Expanded(
                  child: Text(
                    prediction.displayName,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                ConfidenceBadge(confidence: prediction.confidence),
              ],
            ),
    );
  }
}

class _CaptureButton extends StatelessWidget {
  final CameraStreamController controller;

  const _CaptureButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.isCapturing
          ? null
          : () async {
              final file = await controller.captureStill();
              if (file == null || !context.mounted) return;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => ResultPage(imageFile: file)),
              );
            },
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: Colors.white54, width: 4),
        ),
        child: controller.isCapturing
            ? const Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(strokeWidth: 3),
              )
            : const Icon(Icons.camera_alt, color: Colors.black87, size: 30),
      ),
    );
  }
}
