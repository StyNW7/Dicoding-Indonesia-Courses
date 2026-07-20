# Bukti Serving

Letakkan screenshot bukti model sedang di-serve di folder ini setelah kamu
menjalankan exporter secara lokal.

## Langkah

1. Jalankan model server (lihat root `README.md` untuk urutan lengkap):
   ```
   python "3.prometheus_exporter.py"
   ```
2. Di terminal lain, verifikasi service merespons:
   ```
   curl http://127.0.0.1:8000/health
   curl -X POST http://127.0.0.1:8000/predict -H "Content-Type: application/json" -d "{\"data\": [[-1.47, 1.20, -1.56, -1.31]]}"
   ```
3. Screenshot terminal yang menampilkan server berjalan (log Flask "Running on
   http://0.0.0.0:8000") dan/atau respons `/predict` yang berhasil.
4. Simpan sebagai `bukti_serving.jpg` / `.png` di folder ini.

Jika ingin memenuhi opsi "Docker Images" (advance), jalankan container hasil
`mlflow models build-docker` / image dari Docker Hub, lalu screenshot output
`docker ps` yang menunjukkan container berjalan.
