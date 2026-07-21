import 'package:flutter/material.dart';
import 'package:submission/core/app_theme.dart';

/// Tampilan kosong/placeholder yang seragam untuk berbagai kondisi
/// (belum ada gambar, hasil kosong, dll).
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
