import 'package:camera/camera.dart';
import 'package:image/image.dart' as image_lib;

/// Utilitas untuk mengonversi [CameraImage] (format YUV420, hasil
/// `CameraController.startImageStream`) menjadi [image_lib.Image] yang bisa
/// diproses oleh model klasifikasi. Konversi memakai matriks BT.601 standar.
class CameraImageConverter {
  CameraImageConverter._();

  static image_lib.Image convert(CameraImage cameraImage) {
    final image = _yuv420ToImage(cameraImage);
    return image;
  }

  static image_lib.Image _yuv420ToImage(CameraImage cameraImage) {
    final width = cameraImage.width;
    final height = cameraImage.height;

    final yPlane = cameraImage.planes[0];
    final uPlane = cameraImage.planes[1];
    final vPlane = cameraImage.planes[2];

    final yBuffer = yPlane.bytes;
    final uBuffer = uPlane.bytes;
    final vBuffer = vPlane.bytes;

    final yRowStride = yPlane.bytesPerRow;
    final uvRowStride = uPlane.bytesPerRow;
    final uvPixelStride = uPlane.bytesPerPixel ?? 1;

    final image = image_lib.Image(width: width, height: height);

    for (var y = 0; y < height; y++) {
      final yRow = y * yRowStride;
      final uvRow = (y >> 1) * uvRowStride;

      for (var x = 0; x < width; x++) {
        final yIndex = yRow + x;
        final uvIndex = uvRow + (x >> 1) * uvPixelStride;

        if (yIndex >= yBuffer.length ||
            uvIndex >= uBuffer.length ||
            uvIndex >= vBuffer.length) {
          continue;
        }

        final yValue = yBuffer[yIndex];
        final uValue = uBuffer[uvIndex] - 128;
        final vValue = vBuffer[uvIndex] - 128;

        // YUV -> RGB (BT.601 full-range)
        final r = (yValue + 1.370705 * vValue).round().clamp(0, 255);
        final g = (yValue - 0.337633 * uValue - 0.698001 * vValue).round().clamp(0, 255);
        final b = (yValue + 1.732446 * uValue).round().clamp(0, 255);

        image.setPixelRgb(x, y, r, g, b);
      }
    }

    return image;
  }

  /// Merotasi gambar hasil konversi sesuai orientasi sensor kamera, supaya
  /// hasil klasifikasi tidak bias karena gambar "miring".
  static image_lib.Image rotate(image_lib.Image image, int sensorOrientation) {
    if (sensorOrientation % 360 == 0) return image;
    return image_lib.copyRotate(image, angle: sensorOrientation);
  }
}
