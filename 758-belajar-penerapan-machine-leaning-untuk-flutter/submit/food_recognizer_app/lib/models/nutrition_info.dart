/// Model estimasi nutrisi dari Gemini API (structured output), mengikuti
/// skema `nutrition { calories, carbs, fat, fiber, protein }` sesuai
/// konfigurasi pada `others.pdf`. Satuan semua nilai adalah gram, kecuali
/// calories yang menggunakan kkal.
class NutritionInfo {
  final num calories;
  final num carbs;
  final num fat;
  final num fiber;
  final num protein;

  const NutritionInfo({
    required this.calories,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.protein,
  });

  factory NutritionInfo.fromJson(Map<String, dynamic> json) {
    final nutrition = json['nutrition'] as Map<String, dynamic>? ?? json;

    num readNum(String key) {
      final value = nutrition[key];
      if (value is num) return value;
      if (value is String) return num.tryParse(value) ?? 0;
      return 0;
    }

    return NutritionInfo(
      calories: readNum('calories'),
      carbs: readNum('carbs'),
      fat: readNum('fat'),
      fiber: readNum('fiber'),
      protein: readNum('protein'),
    );
  }
}
