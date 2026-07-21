import 'package:flutter/material.dart';

import 'package:submission/models/meal.dart';
import 'package:submission/models/nutrition_info.dart';
import 'package:submission/services/gemini_service.dart';
import 'package:submission/services/mealdb_service.dart';

enum LoadStatus { idle, loading, success, error, empty }

/// Mengelola state Detail Page: mengambil referensi resep dari MealDB
/// (Kriteria 3 - Skilled) dan estimasi nutrisi dari Gemini API
/// (Kriteria 3 - Advanced) berdasarkan nama makanan hasil inferensi.
///
/// Kedua sumber data bersifat independen -- kegagalan salah satu (mis.
/// Gemini API key belum diatur) tidak menghalangi tampilnya data lain.
class DetailController extends ChangeNotifier {
  final MealDbService mealDbService;
  final GeminiService geminiService;
  final String foodName;

  DetailController({
    required this.mealDbService,
    required this.geminiService,
    required this.foodName,
  }) {
    _loadMeal();
    _loadNutrition();
  }

  LoadStatus _mealStatus = LoadStatus.idle;
  LoadStatus get mealStatus => _mealStatus;
  Meal? _meal;
  Meal? get meal => _meal;
  String? _mealError;
  String? get mealError => _mealError;

  LoadStatus _nutritionStatus = LoadStatus.idle;
  LoadStatus get nutritionStatus => _nutritionStatus;
  NutritionInfo? _nutrition;
  NutritionInfo? get nutrition => _nutrition;
  String? _nutritionError;
  String? get nutritionError => _nutritionError;

  Future<void> _loadMeal() async {
    _mealStatus = LoadStatus.loading;
    notifyListeners();

    try {
      final results = await mealDbService.searchByName(foodName);
      if (results.isEmpty) {
        _mealStatus = LoadStatus.empty;
      } else {
        _meal = results.first;
        _mealStatus = LoadStatus.success;
      }
    } catch (error) {
      _mealStatus = LoadStatus.error;
      _mealError = 'Gagal memuat resep: $error';
    }
    notifyListeners();
  }

  Future<void> retryMeal() => _loadMeal();

  Future<void> _loadNutrition() async {
    if (!geminiService.isConfigured) {
      _nutritionStatus = LoadStatus.empty;
      notifyListeners();
      return;
    }

    _nutritionStatus = LoadStatus.loading;
    notifyListeners();

    try {
      _nutrition = await geminiService.estimateNutrition(foodName);
      _nutritionStatus = LoadStatus.success;
    } catch (error) {
      _nutritionStatus = LoadStatus.error;
      _nutritionError = 'Gagal memuat estimasi nutrisi: $error';
    }
    notifyListeners();
  }

  Future<void> retryNutrition() => _loadNutrition();
}
