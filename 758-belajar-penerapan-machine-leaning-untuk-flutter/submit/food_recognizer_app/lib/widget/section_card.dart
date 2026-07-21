import 'package:flutter/material.dart';
import 'package:submission/core/app_theme.dart';

/// Kartu section dengan judul + ikon opsional, dipakai untuk membungkus
/// blok informasi (resep, nutrisi, dsb.) agar tata letak halaman detail
/// tetap rapi dan konsisten.
class SectionCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget child;
  final Widget? trailing;

  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20, color: theme.colorScheme.primary),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            child,
          ],
        ),
      ),
    );
  }
}
