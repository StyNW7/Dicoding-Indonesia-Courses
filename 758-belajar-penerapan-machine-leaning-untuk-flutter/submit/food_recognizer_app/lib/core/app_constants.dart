/// Konstanta global aplikasi: path aset model ML, base URL API eksternal,
/// dan parameter yang dipakai berulang di berbagai layer (service/UI).
class AppConstants {
  AppConstants._();

  // --- Model ML (LiteRT / TensorFlow Lite) ---
  static const String modelAssetPath = 'assets/ml/food_classifier.tflite';
  static const String labelsAssetPath = 'assets/ml/labels.txt';
  static const int modelInputSize = 192; // 192 x 192 RGB sesuai spesifikasi model (MobilenetV1 food classifier)
  static const int modelChannels = 3;

  /// Prediksi dengan skor di bawah ambang ini dianggap terlalu tidak yakin
  /// untuk ditampilkan sebagai hasil utama (mis. background/bukan makanan).
  static const double minConfidenceThreshold = 0.15;

  /// Nama kelas index-0 pada label map resmi model, bukan makanan sungguhan.
  static const String backgroundLabel = '__background__';

  // --- TheMealDB API (gratis, tanpa API key) ---
  static const String mealDbBaseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // --- Gemini API ---
  static const String geminiModel = 'gemini-2.5-flash';

  /// API key TIDAK di-hardcode di project (sesuai ketentuan submission).
  /// Berikan lewat: flutter run --dart-define=GEMINI_API_KEY=xxxxx
  static const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');
}
