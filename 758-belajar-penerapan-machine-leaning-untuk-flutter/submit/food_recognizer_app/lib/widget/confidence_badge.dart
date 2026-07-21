import 'package:flutter/material.dart';
import 'package:submission/core/app_theme.dart';

/// Badge kecil untuk menampilkan confidence score dengan warna yang
/// menyesuaikan tingkat keyakinan (hijau/kuning/merah).
class ConfidenceBadge extends StatelessWidget {
  final double confidence; // 0.0 - 1.0

  const ConfidenceBadge({super.key, required this.confidence});

  Color get _color {
    if (confidence >= 0.7) return AppColors.success;
    if (confidence >= 0.4) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final percent = (confidence * 100).clamp(0, 100).toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$percent%',
        style: TextStyle(
          color: _color,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}
