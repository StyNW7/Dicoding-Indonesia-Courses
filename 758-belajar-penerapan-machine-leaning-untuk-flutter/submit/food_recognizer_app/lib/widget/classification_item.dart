import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:submission/core/app_theme.dart';
import 'package:submission/widget/confidence_badge.dart';

/// Baris hasil klasifikasi: nama makanan di kiri, confidence score di kanan.
class ClassificationItem extends StatelessWidget {
  final String item;
  final double confidence;

  const ClassificationItem({
    super.key,
    required this.item,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          ConfidenceBadge(confidence: confidence),
        ],
      ),
    );
  }
}

/// Placeholder shimmer selagi proses inferensi model berjalan.
class ClassificationItemShimmer extends StatelessWidget {
  const ClassificationItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Shimmer.fromColors(
      baseColor: theme.colorScheme.surfaceContainerHighest,
      highlightColor: theme.colorScheme.surface,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(height: 20, color: Colors.white),
            ),
            const SizedBox(width: AppSpacing.md),
            Container(height: 24, width: 56, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
