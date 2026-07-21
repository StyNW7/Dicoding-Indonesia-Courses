import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:submission/controller/result_controller.dart';
import 'package:submission/core/app_theme.dart';
import 'package:submission/services/food_classifier_service.dart';
import 'package:submission/ui/detail_page.dart';
import 'package:submission/widget/classification_item.dart';
import 'package:submission/widget/error_banner.dart';
import 'package:submission/widget/primary_button.dart';

class ResultPage extends StatelessWidget {
  final File imageFile;

  const ResultPage({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ResultController(
        classifierService: context.read<FoodClassifierService>(),
        imageFile: imageFile,
      ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Hasil Deteksi')),
        body: const SafeArea(child: _ResultBody()),
      ),
    );
  }
}

class _ResultBody extends StatelessWidget {
  const _ResultBody();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ResultController>();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.md,
        children: [
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Image.file(controller.imageFile, fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          _ResultSection(controller: controller),
        ],
      ),
    );
  }
}

class _ResultSection extends StatelessWidget {
  final ResultController controller;

  const _ResultSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    switch (controller.status) {
      case ClassificationStatus.loading:
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.sm,
          children: [
            ClassificationItemShimmer(),
            _AnalyzingLabel(),
          ],
        );

      case ClassificationStatus.error:
        return ErrorBanner(
          message: controller.errorMessage ?? 'Terjadi kesalahan saat menganalisis gambar.',
          onRetry: controller.classify,
        );

      case ClassificationStatus.success:
        final prediction = controller.prediction!;

        if (!controller.isRecognized) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.sm,
            children: [
              ClassificationItem(item: prediction.displayName, confidence: prediction.confidence),
              const ErrorBanner(
                message:
                    'Model kurang yakin dengan gambar ini. Coba gunakan foto makanan yang lebih jelas.',
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.sm,
          children: [
            ClassificationItem(item: prediction.displayName, confidence: prediction.confidence),
            PrimaryButton(
              label: 'Lihat Informasi Lengkap',
              icon: Icons.info_outline,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => DetailPage(
                      foodName: prediction.displayName,
                      confidence: prediction.confidence,
                      imageFile: controller.imageFile,
                    ),
                  ),
                );
              },
            ),
          ],
        );
    }
  }
}

class _AnalyzingLabel extends StatelessWidget {
  const _AnalyzingLabel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        'Menganalisis makanan...',
        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
      ),
    );
  }
}
