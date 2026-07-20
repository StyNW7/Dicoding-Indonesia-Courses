# PGABL_Stanley-Nathanael-Wijaya

Submission proyek akhir **Pengembangan Generative AI berbasis LLM**: Fine-tuned Chatbot Tim Legal
berbasis RAG.

```
PGABL_Stanley-Nathanael-Wijaya/
├── Fine-tuning_submission_PGABL_Stanley-Nathanael-Wijaya.ipynb
├── GRPO_submission_PGABL_Stanley-Nathanael-Wijaya.ipynb   (Advanced, opsional)
├── RAG_submission_PGABL_Stanley-Nathanael-Wijaya.ipynb
├── link_huggingface.txt
├── requirements.txt
└── README.md
```

## Kenapa notebook ini belum punya output terekam

Fine-tuning SLM (QLoRA, SFTTrainer >=800 steps) dan GRPO membutuhkan GPU yang layak (idealnya
Colab/Kaggle T4 16GB ke atas). Mesin yang dipakai untuk menyusun proyek ini hanya punya **GPU GTX
1050 4GB (arsitektur Pascal, tanpa Tensor Core)** — kombinasi VRAM kecil + tidak ada akselerasi
Tensor Core membuat training QLoRA di sini realistis memakan banyak jam dan rawan gagal karena
keterbatasan hardware, persis skenario yang diantisipasi oleh catatan resmi submission:

> "Jika mengalami keterbatasan komputasi, Anda sangat dianjurkan untuk memanfaatkan GPU free tier
> yang tersedia di Google Colab atau Kaggle."

Karena itu, ketiga notebook di folder ini disusun **lengkap dan siap jalan end-to-end**, tapi perlu
dieksekusi olehmu di Colab/Kaggle (atau mesin dengan GPU >=T4) agar outputnya benar-benar terekam
sebelum dikirim — sesuai instruksi submission ("pastikan notebook dijalankan terlebih dahulu").

## Urutan menjalankan

1. **Fine-tuning_submission...ipynb** di Colab (GPU T4):
   - Isi `HF_TOKEN` (write token) dan `HF_USERNAME` saat diminta (`getpass`, tidak pernah plaintext).
   - Opsional: isi `WANDB_API_KEY` untuk logging kurva loss ke Weights & Biases.
   - Jalankan seluruh sel dari atas ke bawah. Cell terakhir push model ke
     `https://huggingface.co/<username>/qwen2.5-1.5b-legal-chatbot-id` (public, method `merged_16bit`).
2. **GRPO_submission...ipynb** (opsional, untuk poin Advanced Kriteria 1) — lanjutan dari notebook
   di atas, memuat kembali model instruct hasil fine-tuning lalu melatihnya dengan `GRPOTrainer`.
3. **RAG_submission...ipynb**:
   - Mengunduh otomatis 4 dokumen UU/PP wajib dari Google Drive resmi kelas.
   - Memuat model dari `FT_REPO_ID` (default: hasil notebook 1; ganti ke repo `*-grpo` bila ingin
     memakai hasil notebook 2 untuk poin Advanced RAG test case).
   - Jalankan sel demi sel; gunakan `run_chat_loop()` atau `demo.launch()` untuk mencoba interface.

## Status implementasi per kriteria (kode sudah lengkap untuk ketiganya)

| Kriteria | Basic | Skilled | Advanced |
|---|---|---|---|
| 1. Fine-tuning | ✅ mapping chat template (print before/after), QLoRA 4-bit+double quant, LoRA di MHA+FFN, SFTTrainer 800 steps, push `merged_16bit` | ✅ train/val split + `eval_strategy="steps"`, 2 eksperimen hyperparameter + perbandingan kurva loss | ✅ notebook GRPO terpisah dengan 4 reward function sesuai spesifikasi + test case wajib |
| 2. RAG | ✅ PDF loader + text splitter (chunk 1000/overlap 150 eksplisit), embedding open-source ke ChromaDB, prompt `{context}`/`{question}`, interface (loop + Gradio) | ✅ metadata enrichment & filtering + sitasi, Ensemble Retriever (BM25+vektor, bobot 0.4/0.6, k=5), Parent-Child Retriever | ✅ HyDE (2 jawaban halusinasi), Reranker Cross-Encoder Top-K=3, fallback DuckDuckGo Search berbasis threshold skor |

## Yang perlu kamu lakukan sendiri (butuh akun/kredensial pribadi)

- Membuat Hugging Face **write token** dan menjalankan notebook agar model benar-benar ter-push ke
  akunmu (saya tidak bisa push ke akun HF milikmu).
- Menjalankan notebook di Colab/Kaggle dengan GPU supaya seluruh output sel (termasuk kurva loss,
  hasil generate, dan hasil retrieval) benar-benar terekam sebelum notebook dikirim — reviewer
  menolak submission yang selnya belum pernah dijalankan.
- Mengisi `link_huggingface.txt` dengan tautan repo HF final (public), dan memastikan repo tidak
  memakai model fine-tuning pihak lain.
- (Opsional) Membuat akun Weights & Biases jika ingin logging kurva loss di sana.
