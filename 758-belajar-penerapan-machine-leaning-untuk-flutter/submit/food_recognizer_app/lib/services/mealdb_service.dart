import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:submission/core/app_constants.dart';
import 'package:submission/models/meal.dart';

/// Service untuk berinteraksi dengan TheMealDB (API resep gratis, tanpa
/// API key) -- dipakai untuk menampilkan referensi resep berdasarkan nama
/// makanan hasil inferensi model (Kriteria 3 - Skilled).
class MealDbService {
  final http.Client _client;

  MealDbService({http.Client? client}) : _client = client ?? http.Client();

  /// Endpoint "Search meal by name".
  Future<List<Meal>> searchByName(String name) async {
    final uri = Uri.parse('${AppConstants.mealDbBaseUrl}/search.php').replace(
      queryParameters: {'s': name},
    );

    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil data resep (${response.statusCode})');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return MealSearchResponse.fromJson(json).meals;
  }

  /// Endpoint "Lookup full meal details by id", dipakai bila butuh detail
  /// terbaru untuk satu resep tertentu.
  Future<Meal?> lookupById(String id) async {
    final uri = Uri.parse('${AppConstants.mealDbBaseUrl}/lookup.php').replace(
      queryParameters: {'i': id},
    );

    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil detail resep (${response.statusCode})');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final meals = MealSearchResponse.fromJson(json).meals;
    return meals.isEmpty ? null : meals.first;
  }

  void dispose() => _client.close();
}
