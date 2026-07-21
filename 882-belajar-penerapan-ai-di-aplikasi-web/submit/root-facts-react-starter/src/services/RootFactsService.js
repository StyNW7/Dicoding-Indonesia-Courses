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

// Validasi nama sayuran untuk memastikan hanya huruf yang valid
const isValidVegetableName = (name) => {
  if (!name || typeof name !== 'string') return false;
  const cleaned = name.trim();
  return cleaned.length > 0 && cleaned.length < 50 && /^[a-zA-Z\s\-]+$/.test(cleaned);
};

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
    this.modelLoadAttempts = 0;
    this.maxLoadAttempts = 3;
  }

  // TODO [Basic] Muat model dan inisialisasi pipeline text2text-generation
  // TODO [Advance] Implementasikan strategi Backend Adaptive
  async loadModel() {
    if (this.isModelLoaded && this.generator) {
      return true;
    }

    const wantsWebGPU = typeof navigator !== 'undefined' && 'gpu' in navigator;
    this.modelLoadAttempts++;

    try {
      let generator = null;
      let backend = null;

      if (wantsWebGPU) {
        try {
          generator = await pipeline('text2text-generation', MODEL_ID, {
            device: 'webgpu',
            dtype: 'q4',
          });
          backend = 'webgpu';
          console.log('Model loaded with WebGPU backend');
        } catch (webgpuError) {
          console.warn('WebGPU tidak tersedia untuk Generative AI, fallback ke wasm:', webgpuError);
          generator = await pipeline('text2text-generation', MODEL_ID, {
            device: 'wasm',
            dtype: 'q4',
          });
          backend = 'wasm';
          console.log('Model loaded with WASM backend (fallback)');
        }
      } else {
        generator = await pipeline('text2text-generation', MODEL_ID, {
          device: 'wasm',
          dtype: 'q4',
        });
        backend = 'wasm';
        console.log('Model loaded with WASM backend');
      }

      this.generator = generator;
      this.currentBackend = backend;
      this.isModelLoaded = true;
      this.modelLoadAttempts = 0;
      return true;
    } catch (error) {
      console.error('Gagal memuat model Generative AI:', error);
      
      // Retry logic with exponential backoff
      if (this.modelLoadAttempts < this.maxLoadAttempts) {
        const delay = Math.pow(2, this.modelLoadAttempts) * 1000;
        console.log(`Retrying model load in ${delay}ms (attempt ${this.modelLoadAttempts}/${this.maxLoadAttempts})`);
        await new Promise(resolve => setTimeout(resolve, delay));
        return this.loadModel();
      }
      
      throw error;
    }
  }

  // TODO [Advance] Konfigurasi tone fakta yang dihasilkan
  setTone(tone) {
    const isValidTone = TONE_CONFIG.availableTones.some((option) => option.value === tone);
    this.currentTone = isValidTone ? tone : TONE_CONFIG.defaultTone;
    
    // Sesuaikan parameter generasi berdasarkan tone
    this.adjustConfigForTone(this.currentTone);
    
    console.log(`Tone set to: ${this.currentTone}`);
  }

  // Sesuaikan konfigurasi generasi berdasarkan tone
  adjustConfigForTone(tone) {
    const configAdjustments = {
      normal: { temperature: 0.4, top_p: 0.85, max_new_tokens: 150 },
      funny: { temperature: 0.6, top_p: 0.9, max_new_tokens: 180 },
      professional: { temperature: 0.2, top_p: 0.8, max_new_tokens: 200 },
      casual: { temperature: 0.5, top_p: 0.85, max_new_tokens: 160 },
    };

    const adjustment = configAdjustments[tone] || configAdjustments.normal;
    this.config = {
      ...this.config,
      ...adjustment
    };
  }

  // TODO [Basic] Lakukan prediksi pada elemen gambar yang diberikan dan kembalikan hasilnya
  // TODO [Skilled] Konfigurasikan parameter generasi berdasarkan kebutuhan
  // TODO [Advance] Implemenasikan parameter tone untuk mengatur nada fakta yang dihasilkan
  async generateFacts(vegetableName) {
    // Validasi input
    if (!this.isReady()) {
      throw new Error('Model Generative AI belum siap');
    }

    if (!isValidVegetableName(vegetableName)) {
      throw new Error(`Nama sayuran tidak valid: "${vegetableName}"`);
    }

    if (this.isGenerating) {
      throw new Error('Generasi sedang berlangsung, silakan tunggu');
    }

    this.isGenerating = true;

    try {
      // Normalisasi nama sayuran
      const normalizedName = normalizeVegetableName(vegetableName);
      
      // Buat prompt yang lebih spesifik dan tegas
      const promptTemplate = TONE_PROMPTS[this.currentTone] || TONE_PROMPTS[TONE_CONFIG.defaultTone];
      
      // Tambahkan penguatan instruksi untuk model kecil
      const enhancedPrompt = this.enhancePrompt(promptTemplate, normalizedName);
      
      console.log(`Generating fact for: ${normalizedName} (tone: ${this.currentTone})`);
      console.log('Config:', this.config);

      // Generate dengan retry logic
      let output = null;
      let attempts = 0;
      const maxAttempts = 2;

      while (attempts < maxAttempts) {
        try {
          output = await this.generator(enhancedPrompt, {
            max_new_tokens: this.config.max_new_tokens,
            temperature: this.config.temperature,
            top_p: this.config.top_p,
            do_sample: this.config.do_sample,
            repetition_penalty: 1.1, // Tambahkan penalty untuk mengurangi repetisi
          });
          break;
        } catch (error) {
          attempts++;
          if (attempts >= maxAttempts) throw error;
          console.warn(`Generation attempt ${attempts} failed, retrying...`);
          await new Promise(resolve => setTimeout(resolve, 500));
        }
      }

      let generatedText = output?.[0]?.generated_text?.trim();

      // Post-processing: validasi dan perbaikan hasil
      generatedText = this.postProcessResult(generatedText, normalizedName);

      // Fallback jika hasil tidak valid
      if (!generatedText || generatedText.length < 10) {
        return this.getFallbackFact(normalizedName);
      }

      return generatedText;

    } catch (error) {
      console.error('Error generating facts:', error);
      // Return fallback yang lebih relevan
      return this.getFallbackFact(normalizeVegetableName(vegetableName));
    } finally {
      this.isGenerating = false;
    }
  }

  // Perbaiki prompt dengan penguatan tambahan untuk model kecil
  enhancePrompt(basePrompt, vegetableName) {
    // Tambahkan instruksi ekstra untuk memastikan fokus pada sayuran yang tepat
    const enhanced = `Focus only on ${vegetableName}. ${basePrompt}`;
    return enhanced;
  }

  // Post-processing hasil generasi
  postProcessResult(result, vegetableName) {
    if (!result) return null;

    // Bersihkan hasil dari teks yang tidak diinginkan
    let cleaned = result
      .replace(/^[^a-zA-Z]*/, '') // Hapus karakter aneh di awal
      .replace(/\s+/g, ' ') // Normalisasi spasi
      .trim();

    // Validasi: pastikan nama sayuran ada di hasil (kecuali untuk fallback)
    if (!cleaned.toLowerCase().includes(vegetableName.toLowerCase())) {
      // Jika tidak mengandung nama sayuran, mungkin hasilnya menyimpang
      console.warn(`Generated text doesn't mention "${vegetableName}", using fallback`);
      return null;
    }

    // Batasi panjang hasil
    if (cleaned.length > 300) {
      cleaned = cleaned.substring(0, 297) + '...';
    }

    return cleaned;
  }

  // Fallback facts yang lebih relevan dan bervariasi
  getFallbackFact(vegetableName) {
    const fallbackFacts = {
      'carrot': 'Carrots are rich in beta-carotene, which the body converts to vitamin A for healthy vision!',
      'broccoli': 'Broccoli is packed with vitamin C and K, and contains more protein than most other vegetables!',
      'spinach': 'Spinach is loaded with iron and calcium, and was used by Popeye to gain super strength!',
      'tomato': 'Tomatoes are actually fruits botanically, but are treated as vegetables in culinary contexts!',
      'potato': 'Potatoes were the first vegetable to be grown in space in 1995 on the Space Shuttle Columbia!',
      'cucumber': 'Cucumbers are 95% water and belong to the same family as melons and pumpkins!',
      'pepper': 'Bell peppers are rich in vitamin C - more than oranges!',
      'onion': 'Onions contain quercetin, a powerful antioxidant that may help reduce inflammation!',
      'garlic': 'Garlic has been used for centuries for its medicinal properties and contains allicin!',
      'mushroom': 'Mushrooms are the only vegetable source of vitamin D and are more closely related to animals than plants!',
    };

    const defaultFact = `${vegetableName} is a nutritious vegetable with many health benefits and culinary uses!`;
    
    // Cari fakta spesifik atau gunakan default
    const key = vegetableName.toLowerCase();
    return fallbackFacts[key] || defaultFact;
  }

  // TODO [Basic] Periksa apakah model sudah dimuat dan siap digunakan
  isReady() {
    return this.isModelLoaded && this.generator !== null && !this.isGenerating;
  }

  // Method tambahan untuk mendapatkan status model
  getModelStatus() {
    return {
      isLoaded: this.isModelLoaded,
      backend: this.currentBackend,
      isGenerating: this.isGenerating,
      currentTone: this.currentTone,
      config: this.config
    };
  }

  // Method untuk reset model (jika diperlukan)
  async resetModel() {
    if (this.generator) {
      this.generator = null;
      this.isModelLoaded = false;
      console.log('Model reset successfully');
    }
    // Reload model
    return this.loadModel();
  }
}