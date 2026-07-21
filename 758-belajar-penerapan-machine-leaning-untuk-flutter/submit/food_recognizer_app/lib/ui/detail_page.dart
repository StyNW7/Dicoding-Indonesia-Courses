import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:submission/controller/detail_controller.dart';
import 'package:submission/core/app_theme.dart';
import 'package:submission/services/gemini_service.dart';
import 'package:submission/services/mealdb_service.dart';
import 'package:submission/widget/confidence_badge.dart';
import 'package:submission/widget/error_banner.dart';
import 'package:submission/widget/ingredient_list.dart';
import 'package:submission/widget/nutrition_grid.dart';
import 'package:submission/widget/section_card.dart';

/// Halaman informasi detail hasil deteksi makanan (Kriteria 3):
/// - Basic: foto, nama makanan, confidence score.
/// - Skilled: referensi resep dari MealDB (bahan, langkah pembuatan).
/// - Advanced: estimasi nutrisi dari Gemini API.
class DetailPage extends StatelessWidget {
  final String foodName;
  final double confidence;
  final File imageFile;

  const DetailPage({
    super.key,
    required this.foodName,
    required this.confidence,
    required this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DetailController(
        mealDbService: context.read<MealDbService>(),
        geminiService: context.read<GeminiService>(),
        foodName: foodName,
      ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Informasi Makanan')),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              _DetectedFoodHeader(imageFile: imageFile, foodName: foodName, confidence: confidence),
              const SizedBox(height: AppSpacing.md),
              const _RecipeSection(),
              const SizedBox(height: AppSpacing.md),
              const _NutritionSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetectedFoodHeader extends StatelessWidget {
  final File imageFile;
  final String foodName;
  final double confidence;

  const _DetectedFoodHeader({
    required this.imageFile,
    required this.foodName,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: Image.file(imageFile, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    foodName,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                ConfidenceBadge(confidence: confidence),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipeSection extends StatelessWidget {
  const _RecipeSection();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DetailController>();

    switch (controller.mealStatus) {
      case LoadStatus.idle:
      case LoadStatus.loading:
        return const _SectionShimmer();

      case LoadStatus.error:
        return SectionCard(
          title: 'Referensi Resep',
          icon: Icons.menu_book_outlined,
          child: ErrorBanner(
            message: controller.mealError ?? 'Gagal memuat resep.',
            onRetry: controller.retryMeal,
          ),
        );

      case LoadStatus.empty:
        return const SectionCard(
          title: 'Referensi Resep',
          icon: Icons.menu_book_outlined,
          child: Text('Belum ada resep referensi yang cocok untuk makanan ini di TheMealDB.'),
        );

      case LoadStatus.success:
        final meal = controller.meal!;
        return SectionCard(
          title: 'Referensi Resep',
          icon: Icons.menu_book_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  meal.thumbnailUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 160,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.image_not_supported_outlined),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                meal.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              if (meal.category != null || meal.area != null) ...[
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: [
                    if (meal.category != null) Chip(label: Text(meal.category!)),
                    if (meal.area != null) Chip(label: Text(meal.area!)),
                  ],
                ),
              ],
              if (meal.ingredients.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Text('Bahan-Bahan', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                IngredientList(ingredients: meal.ingredients),
              ],
              if (meal.instructions.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Text('Cara Membuat', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(meal.instructions, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ],
          ),
        );
    }
  }
}

class _NutritionSection extends StatelessWidget {
  const _NutritionSection();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DetailController>();

    switch (controller.nutritionStatus) {
      case LoadStatus.idle:
      case LoadStatus.loading:
        return const _SectionShimmer();

      case LoadStatus.error:
        return SectionCard(
          title: 'Estimasi Nutrisi',
          icon: Icons.local_fire_department_outlined,
          child: ErrorBanner(
            message: controller.nutritionError ?? 'Gagal memuat estimasi nutrisi.',
            onRetry: controller.retryNutrition,
          ),
        );

      case LoadStatus.empty:
        return const SectionCard(
          title: 'Estimasi Nutrisi',
          icon: Icons.local_fire_department_outlined,
          child: Text(
            'Fitur estimasi nutrisi memerlukan Gemini API key. Jalankan aplikasi dengan '
            '--dart-define=GEMINI_API_KEY=<api-key-anda> untuk mengaktifkan fitur ini.',
          ),
        );

      case LoadStatus.success:
        return SectionCard(
          title: 'Estimasi Nutrisi',
          icon: Icons.local_fire_department_outlined,
          trailing: Text(
            'via Gemini AI',
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          child: NutritionGrid(nutrition: controller.nutrition!),
        );
    }
  }
}

class _SectionShimmer extends StatelessWidget {
  const _SectionShimmer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Shimmer.fromColors(
      baseColor: theme.colorScheme.surfaceContainerHighest,
      highlightColor: theme.colorScheme.surface,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
