import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:submission/controller/home_controller.dart';
import 'package:submission/core/app_theme.dart';
import 'package:submission/ui/camera_page.dart';
import 'package:submission/ui/result_page.dart';
import 'package:submission/widget/empty_state.dart';
import 'package:submission/widget/error_banner.dart';
import 'package:submission/widget/primary_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Recognizer'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: const _HomeBody(),
        ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ModelStatusBanner(controller: controller),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: _ImagePreviewCard(image: controller.selectedImage),
        ),
        const SizedBox(height: AppSpacing.md),
        if (controller.pickError != null) ...[
          ErrorBanner(message: controller.pickError!),
          const SizedBox(height: AppSpacing.md),
        ],
        if (controller.selectedImage != null) ...[
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: 'Potong Gambar',
                  icon: Icons.crop,
                  outlined: true,
                  isLoading: controller.isPicking,
                  onPressed: controller.cropSelectedImage,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: PrimaryButton(
                  label: 'Ganti',
                  icon: Icons.refresh,
                  outlined: true,
                  onPressed: controller.clearSelectedImage,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
        ] else
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: 'Kamera',
                  icon: Icons.photo_camera_outlined,
                  outlined: true,
                  isLoading: controller.isPicking,
                  onPressed: controller.isModelReady ? controller.pickFromCamera : null,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: PrimaryButton(
                  label: 'Galeri',
                  icon: Icons.photo_library_outlined,
                  outlined: true,
                  isLoading: controller.isPicking,
                  onPressed: controller.isModelReady ? controller.pickFromGallery : null,
                ),
              ),
            ],
          ),
        const SizedBox(height: AppSpacing.sm),
        PrimaryButton(
          label: controller.selectedImage != null ? 'Analisis Makanan' : 'Buka Kamera Real-Time',
          icon: controller.selectedImage != null ? Icons.auto_awesome : Icons.videocam_outlined,
          onPressed: !controller.isModelReady
              ? null
              : () {
                  if (controller.selectedImage != null) {
                    _goToResult(context, controller.selectedImage!);
                  } else {
                    _goToLiveCamera(context);
                  }
                },
        ),
      ],
    );
  }

  void _goToResult(BuildContext context, File image) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ResultPage(imageFile: image)),
    );
  }

  void _goToLiveCamera(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CameraPage()),
    );
  }
}

class _ModelStatusBanner extends StatelessWidget {
  final HomeController controller;

  const _ModelStatusBanner({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    switch (controller.modelStatus) {
      case ModelLoadStatus.loading:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Text('Memuat model AI...'),
            ],
          ),
        );
      case ModelLoadStatus.error:
        return ErrorBanner(
          message: controller.modelError ?? 'Gagal memuat model AI.',
          onRetry: controller.retryLoadModel,
        );
      case ModelLoadStatus.ready:
        return const SizedBox.shrink();
    }
  }
}

class _ImagePreviewCard extends StatelessWidget {
  final File? image;

  const _ImagePreviewCard({required this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: image == null
          ? const Center(
              child: EmptyState(
                icon: Icons.restaurant_menu,
                title: 'Belum ada gambar',
                message: 'Ambil foto makanan dari kamera atau pilih dari galeri untuk memulai.',
              ),
            )
          : Image.file(image!, fit: BoxFit.cover, width: double.infinity),
    );
  }
}
