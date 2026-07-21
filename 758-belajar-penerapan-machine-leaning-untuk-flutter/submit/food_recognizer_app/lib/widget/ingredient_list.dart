import 'package:flutter/material.dart';
import 'package:submission/core/app_theme.dart';
import 'package:submission/models/meal.dart';

/// Daftar bahan makanan (nama + takaran) hasil resep dari MealDB.
class IngredientList extends StatelessWidget {
  final List<MealIngredient> ingredients;

  const IngredientList({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: ingredients
          .map(
            (ingredient) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.circle, size: 6, color: theme.colorScheme.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(ingredient.name, style: theme.textTheme.bodyMedium),
                  ),
                  Text(
                    ingredient.measure,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
