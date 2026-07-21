import * as tf from '@tensorflow/tfjs';
import '@tensorflow/tfjs-backend-webgpu';

const MODEL_URL = `${import.meta.env.BASE_URL}model/model.json`;
const METADATA_URL = `${import.meta.env.BASE_URL}model/metadata.json`;

export class DetectionService {
  constructor() {
    this.model = null;
    this.labels = [];
    this.config = { imageSize: 224 };
  }

  // TODO [Basic] Muat model dan metadata secara bersamaan, lalu simpan ke instance
  // TODO [Advance] Implementasikan strategi Backend Adaptive
  async loadModel(onProgress) {
    try {
      await this._setupBackend();

      const [model, metadata] = await Promise.all([
        tf.loadLayersModel(MODEL_URL, {
          onProgress: (fraction) => {
            if (onProgress) onProgress(fraction);
          },
        }),
        fetch(METADATA_URL).then((response) => response.json()),
      ]);

      this.model = model;
      this.labels = metadata.labels || [];
      this.config = { imageSize: metadata.imageSize || 224 };

      // Warm-up agar prediksi pertama tidak lambat, langsung dibuang dari memori
      tf.tidy(() => {
        const warmupInput = tf.zeros([1, this.config.imageSize, this.config.imageSize, 3]);
        this.model.predict(warmupInput);
      });

      return true;
    } catch (error) {
      console.error('Gagal memuat model deteksi:', error);
      throw error;
    }
  }

  async _setupBackend() {
    const wantsWebGPU = typeof navigator !== 'undefined' && 'gpu' in navigator;

    if (wantsWebGPU) {
      try {
        await tf.setBackend('webgpu');
        await tf.ready();
        return;
      } catch (error) {
        console.warn('WebGPU tidak tersedia, fallback ke WebGL:', error);
      }
    }

    await tf.setBackend('webgl');
    await tf.ready();
  }

  // TODO [Basic] Lakukan prediksi pada elemen gambar yang diberikan dan kembalikan hasilnya
  async predict(imageElement) {
    if (!this.isLoaded()) {
      throw new Error('Model belum dimuat');
    }

    const { imageSize } = this.config;

    const predictionTensor = tf.tidy(() => {
      const image = tf.browser.fromPixels(imageElement);
      const resized = tf.image.resizeBilinear(image, [imageSize, imageSize]);
      const normalized = resized.toFloat().sub(127.5).div(127.5);
      const batched = normalized.expandDims(0);
      return this.model.predict(batched);
    });

    const scores = await predictionTensor.data();
    predictionTensor.dispose();

    let maxScore = 0;
    let maxIndex = 0;
    scores.forEach((score, index) => {
      if (score > maxScore) {
        maxScore = score;
        maxIndex = index;
      }
    });

    return {
      className: this.labels[maxIndex] || 'Tidak diketahui',
      score: maxScore,
      confidence: Math.round(maxScore * 100),
      isValid: true,
    };
  }

  // TODO [Basic] Periksa apakah model sudah dimuat dan siap digunakan
  isLoaded() {
    return this.model !== null && this.labels.length > 0;
  }
}
