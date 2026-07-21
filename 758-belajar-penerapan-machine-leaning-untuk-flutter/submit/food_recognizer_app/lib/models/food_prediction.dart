/// Hasil satu kelas prediksi dari model klasifikasi makanan.
class FoodPrediction {
  final String label;
  final double confidence; // rentang 0.0 - 1.0

  const FoodPrediction({required this.label, required this.confidence});

  /// Label yang dirapikan untuk ditampilkan ke pengguna, mis. mengganti
  /// underscore dengan spasi dan mengubah huruf awal tiap kata jadi kapital.
  String get displayName {
    final normalized = label.replaceAll('_', ' ').trim();
    if (normalized.isEmpty) return normalized;
    return normalized
        .split(' ')
        .map((word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }

  @override
  String toString() => 'FoodPrediction(label: $label, confidence: $confidence)';
}
