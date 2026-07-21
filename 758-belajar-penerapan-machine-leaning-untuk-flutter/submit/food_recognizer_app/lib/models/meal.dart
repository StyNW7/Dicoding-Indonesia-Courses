/// Model hasil pencarian resep dari TheMealDB (endpoint `search.php`/`lookup.php`).
///
/// Dibuat manual (bukan lewat Quicktype) supaya mudah menangani 20 pasang
/// field `strIngredientX` / `strMeasureX` yang disediakan API secara flat.
class Meal {
  final String id;
  final String name;
  final String? category;
  final String? area;
  final String instructions;
  final String thumbnailUrl;
  final String? youtubeUrl;
  final List<MealIngredient> ingredients;

  const Meal({
    required this.id,
    required this.name,
    required this.instructions,
    required this.thumbnailUrl,
    required this.ingredients,
    this.category,
    this.area,
    this.youtubeUrl,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    final ingredients = <MealIngredient>[];
    for (var i = 1; i <= 20; i++) {
      final ingredient = (json['strIngredient$i'] as String?)?.trim();
      final measure = (json['strMeasure$i'] as String?)?.trim();
      if (ingredient == null || ingredient.isEmpty) continue;
      ingredients.add(MealIngredient(name: ingredient, measure: (measure?.isEmpty ?? true) ? '-' : measure!));
    }

    return Meal(
      id: json['idMeal'] as String? ?? '',
      name: json['strMeal'] as String? ?? 'Unknown Meal',
      category: json['strCategory'] as String?,
      area: json['strArea'] as String?,
      instructions: (json['strInstructions'] as String?)?.trim() ?? '',
      thumbnailUrl: json['strMealThumb'] as String? ?? '',
      youtubeUrl: json['strYoutube'] as String?,
      ingredients: ingredients,
    );
  }
}

class MealIngredient {
  final String name;
  final String measure;

  const MealIngredient({required this.name, required this.measure});
}

/// Wrapper respons `{"meals": [...]}` atau `{"meals": null}` dari TheMealDB.
class MealSearchResponse {
  final List<Meal> meals;

  const MealSearchResponse({required this.meals});

  factory MealSearchResponse.fromJson(Map<String, dynamic> json) {
    final rawMeals = json['meals'];
    if (rawMeals is! List) return const MealSearchResponse(meals: []);

    return MealSearchResponse(
      meals: rawMeals
          .whereType<Map<String, dynamic>>()
          .map(Meal.fromJson)
          .toList(growable: false),
    );
  }
}
