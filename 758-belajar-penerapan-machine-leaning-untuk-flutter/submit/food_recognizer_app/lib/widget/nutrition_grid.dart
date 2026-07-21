import 'package:flutter/material.dart';
import 'package:submission/core/app_theme.dart';
import 'package:submission/models/nutrition_info.dart';

/// Menampilkan estimasi nutrisi (kalori, karbohidrat, lemak, serat, protein)
/// dalam bentuk grid kartu kecil yang mudah dipindai mata.
class NutritionGrid extends StatelessWidget {
  final NutritionInfo nutrition;

  const NutritionGrid({super.key, required this.nutrition});

  @override
  Widget build(BuildContext context) {
    final items = [
      _NutritionEntry('Kalori', nutrition.calories, 'kkal', Icons.local_fire_department),
      _NutritionEntry('Karbohidrat', nutrition.carbs, 'g', Icons.grain),
      _NutritionEntry('Lemak', nutrition.fat, 'g', Icons.opacity),
      _NutritionEntry('Serat', nutrition.fiber, 'g', Icons.eco),
      _NutritionEntry('Protein', nutrition.protein, 'g', Icons.fitness_center),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      childAspectRatio: 2.4,
      children: items.map((item) => _NutritionTile(entry: item)).toList(),
    );
  }
}

class _NutritionEntry {
  final String label;
  final num value;
  final String unit;
  final IconData icon;

  const _NutritionEntry(this.label, this.value, this.unit, this.icon);
}

class _NutritionTile extends StatelessWidget {
  final _NutritionEntry entry;

  const _NutritionTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(entry.icon, color: theme.colorScheme.primary, size: 22),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${entry.value} ${entry.unit}',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  entry.label,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
