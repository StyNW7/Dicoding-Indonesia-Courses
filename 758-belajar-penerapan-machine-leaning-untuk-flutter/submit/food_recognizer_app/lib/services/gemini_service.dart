import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';

import 'package:submission/core/app_constants.dart';
import 'package:submission/models/nutrition_info.dart';

/// Service untuk mengestimasi kandungan gizi makanan lewat Gemini API
/// (Kriteria 3 - Advanced), memakai *structured output* supaya responsnya
/// selalu berbentuk JSON yang sudah pasti sesuai skema yang dibutuhkan.
class GeminiService {
  GenerativeModel? _model;

  bool get isConfigured => AppConstants.geminiApiKey.isNotEmpty;

  void _ensureModel() {
    if (_model != null) return;
    if (!isConfigured) {
      throw StateError(
        'GEMINI_API_KEY belum diatur. Jalankan aplikasi dengan '
        '--dart-define=GEMINI_API_KEY=<api-key-anda>.',
      );
    }

    _model = GenerativeModel(
      model: AppConstants.geminiModel,
      apiKey: AppConstants.geminiApiKey,
      systemInstruction: Content.system(
        'Saya adalah suatu mesin yang mampu mengidentifikasi nutrisi atau '
        'kandungan gizi pada makanan layaknya uji laboratorium makanan. Hal '
        'yang bisa diidentifikasi adalah kalori, karbohidrat, lemak, serat, '
        'dan protein pada makanan. Satuan dari indikator tersebut berupa '
        'gram (kecuali kalori dalam kkal). Berikan estimasi angka yang '
        'masuk akal untuk satu porsi wajar dari makanan tersebut.',
      ),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: Schema.object(
          properties: {
            'nutrition': Schema.object(
              properties: {
                'calories': Schema.integer(description: 'Kalori dalam kkal'),
                'carbs': Schema.integer(description: 'Karbohidrat dalam gram'),
                'protein': Schema.integer(description: 'Protein dalam gram'),
                'fat': Schema.integer(description: 'Lemak dalam gram'),
                'fiber': Schema.integer(description: 'Serat dalam gram'),
              },
              requiredProperties: ['calories', 'carbs', 'protein', 'fat', 'fiber'],
            ),
          },
          requiredProperties: ['nutrition'],
        ),
      ),
    );
  }

  /// Meminta estimasi nutrisi untuk satu nama makanan.
  Future<NutritionInfo> estimateNutrition(String foodName) async {
    _ensureModel();

    final response = await _model!.generateContent([
      Content.text('Nama makanannya adalah $foodName.'),
    ]);

    final text = response.text;
    if (text == null || text.isEmpty) {
      throw Exception('Gemini API tidak mengembalikan respons.');
    }

    final json = jsonDecode(text) as Map<String, dynamic>;
    return NutritionInfo.fromJson(json);
  }
}
