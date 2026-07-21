import { pipeline } from '@huggingface/transformers';
import { TONE_CONFIG } from '../utils/config.js';

const MODEL_ID = 'Xenova/LaMini-Flan-T5-77M';

// Nama sayuran disebutkan dua kali (di awal sebagai konteks & di kalimat
// instruksi) dan diberi larangan eksplisit menyebut topik lain, karena model
// sekecil ini (77M, q4) mudah menyimpang dari objek yang terdeteksi bila
// prompt kurang tegas.
const TONE_PROMPTS = {
  normal: 'Vegetable: {vegetable}. Write one short, factual fun fact only about {vegetable}. Do not mention any other vegetable or topic. Answer in 1-2 sentences.',
  funny: 'Vegetable: {vegetable}. Write one short, funny, playful fun fact only about {vegetable}, like telling a joke. Do not mention any other vegetable or topic. Answer in 1-2 sentences.',
  professional: 'Vegetable: {vegetable}. Write one short, scientific fun fact only about {vegetable}, using formal language. Do not mention any other vegetable or topic. Answer in 1-2 sentences.',
  casual: 'Vegetable: {vegetable}. Write one short, casual fun fact only about {vegetable}, like chatting with a friend. Do not mention any other vegetable or topic. Answer in 1-2 sentences.',
};

const normalizeVegetableName = (name) =>
  name.charAt(0).toUpperCase() + name.slice(1).toLowerCase();

export class RootFactsService {
  constructor() {
    this.generator = null;
    this.isModelLoaded = false;
    this.isGenerating = false;
    // temperature & top_p diturunkan dari 0.8/0.9 -> 0.4/0.85: nilai lama
    // terbukti (lihat pengujian manual) sering membuat fakta menyimpang jauh
    // dari sayuran yang diminta (mis. "cucumber is the largest tree in the
    // world"), karena sampling terlalu acak untuk model sekecil ini.
    this.config = {
      max_new_tokens: 150,
      temperature: 0.4,
      top_p: 0.85,
      do_sample: true,
    };
    this.currentBackend = null;
    this.currentTone = TONE_CONFIG.defaultTone;
  }

  // TODO [Basic] Muat model dan inisialisasi pipeline text2text-generation
  // TODO [Advance] Implementasikan strategi Backend Adaptive
  async loadModel() {
    const wantsWebGPU = typeof navigator !== 'undefined' && 'gpu' in navigator;

    try {
      if (wantsWebGPU) {
        try {
          this.generator = await pipeline('text2text-generation', MODEL_ID, {
            device: 'webgpu',
            dtype: 'q4',
          });
          this.currentBackend = 'webgpu';
        } catch (webgpuError) {
          console.warn('WebGPU tidak tersedia untuk Generative AI, fallback ke wasm:', webgpuError);
          this.generator = await pipeline('text2text-generation', MODEL_ID, {
            device: 'wasm',
            dtype: 'q4',
          });
          this.currentBackend = 'wasm';
        }
      } else {
        this.generator = await pipeline('text2text-generation', MODEL_ID, {
          device: 'wasm',
          dtype: 'q4',
        });
        this.currentBackend = 'wasm';
      }

      this.isModelLoaded = true;
      return true;
    } catch (error) {
      console.error('Gagal memuat model Generative AI:', error);
      throw error;
    }
  }

  // TODO [Advance] Konfigurasi tone fakta yang dihasilkan
  setTone(tone) {
    const isValidTone = TONE_CONFIG.availableTones.some((option) => option.value === tone);
    this.currentTone = isValidTone ? tone : TONE_CONFIG.defaultTone;
  }

  // TODO [Basic] Lakukan prediksi pada elemen gambar yang diberikan dan kembalikan hasilnya
  // TODO [Skilled] Konfigurasikan parameter generasi berdasarkan kebutuhan
  // TODO [Advance] Implemenasikan parameter tone untuk mengatur nada fakta yang dihasilkan
  async generateFacts(vegetableName) {
    if (!this.isReady()) {
      throw new Error('Model Generative AI belum siap');
    }

    this.isGenerating = true;

    try {
      const promptTemplate = TONE_PROMPTS[this.currentTone] || TONE_PROMPTS[TONE_CONFIG.defaultTone];
      const prompt = promptTemplate.replaceAll('{vegetable}', normalizeVegetableName(vegetableName));

      const output = await this.generator(prompt, {
        max_new_tokens: this.config.max_new_tokens,
        temperature: this.config.temperature,
        top_p: this.config.top_p,
        do_sample: this.config.do_sample,
      });

      const generatedText = output?.[0]?.generated_text?.trim();

      return generatedText || `${vegetableName} is a fascinating vegetable with many unique qualities!`;
    } finally {
      this.isGenerating = false;
    }
  }

  // TODO [Basic] Periksa apakah model sudah dimuat dan siap digunakan
  isReady() {
    return this.isModelLoaded && this.generator !== null;
  }
}
