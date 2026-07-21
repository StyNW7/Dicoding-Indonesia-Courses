# SMSML_Stanley-Nathanael-Wijaya

Submission proyek akhir kelas **Membangun Sistem Machine Learning** (Dicoding),
dibangun di atas dataset **Iris**. Struktur folder ini mengikuti format resmi
submission:

```
SMSML_Stanley-Nathanael-Wijaya/
├── Eksperimen_SML_Stanley-Nathanael-Wijaya.txt   -> https://github.com/StyNW7/Dicoding_Eksperimen_SML_Stanley-Nathanael-Wijaya
├── Eksperimen_SML_Stanley-Nathanael-Wijaya/      -> isi repo Kriteria 1 (push terpisah)
├── Membangun_model/                              -> Kriteria 2
├── Workflow-CI.txt                               -> https://github.com/StyNW7/Dicoding_713_Workflow_CI
├── Workflow-CI/                                  -> isi repo Kriteria 3 (push terpisah)
└── Monitoring dan Logging/                       -> Kriteria 4
```

`Eksperimen_SML_Stanley-Nathanael-Wijaya/` dan `Workflow-CI/` harus di-push
sebagai **repository GitHub terpisah** (bukan bagian dari repo utama ini),
dengan visibilitas **Public**. Lihat `README.md` di masing-masing folder untuk
instruksi lengkap.

## Alur data end-to-end

```
Iris.csv (raw)
   │  Eksperimen_SML_.../preprocessing/  (notebook manual + automate_*.py)
   ▼
train.csv / test.csv (siap latih)
   │  Membangun_model/modelling.py & modelling_tuning.py  (MLflow tracking + tuning)
   │  Workflow-CI/MLProject/  (retraining otomatis via GitHub Actions -> MLflow Project)
   ▼
model.pkl / MLflow model artifact
   │  Monitoring dan Logging/3.prometheus_exporter.py  (serving + metrik)
   ▼
Prometheus -> Grafana (visualisasi & alerting)
```

## Urutan menjalankan semuanya secara lokal

```bash
# 0. Buat & aktifkan virtual environment (Python 3.12.7 direkomendasikan)
python -m venv .venv
.venv\Scripts\activate        # Windows
pip install -r Membangun_model/requirements.txt
pip install -r "Monitoring dan Logging/requirements.txt"

# 1. Kriteria 1 - preprocessing
cd Eksperimen_SML_Stanley-Nathanael-Wijaya/preprocessing
python "automate_Stanley-Nathanael-Wijaya.py"
cd ../..

# Salin dataset hasil preprocessing ke folder Kriteria 2 & 3
# (sudah dilakukan sekali di repo ini, ulangi jika dataset berubah)

# 2. Kriteria 2 - training + MLflow
cd Membangun_model
mlflow ui &                 # buka tab baru, biarkan berjalan di 127.0.0.1:5000
python modelling.py
python modelling_tuning.py
cd ..

# 3. Kriteria 3 - CI (cek lokal sebelum push ke GitHub)
cd Workflow-CI/MLProject
mlflow run . --env-manager=local
cd ../..

# 4. Kriteria 4 - serving + monitoring
cd "Monitoring dan Logging"
python "3.prometheus_exporter.py" &
python "7.inference.py" --loop 50 --delay 0.2
# lalu jalankan Prometheus & Grafana, lihat README masing-masing subfolder.
```

## Status implementasi per kriteria (target: Skilled, siap-Advance)

| Kriteria | Basic | Skilled | Advance |
|---|---|---|---|
| 1. Eksperimen dataset | ✅ notebook manual (load, EDA, preprocessing) | ✅ `automate_Stanley-Nathanael-Wijaya.py` | ✅ kode workflow tersedia (`preprocessing.yml`) — jalankan minimal 1x setelah repo di-push |
| 2. Membangun model | ✅ `modelling.py` + autolog | ✅ `modelling_tuning.py` + tuning + manual logging | ✅ kode DagsHub tersedia (`DagsHub.txt`) — aktifkan dengan kredensial sendiri |
| 3. Workflow CI | ✅ folder `MLProject` + workflow dasar | ✅ upload artifact ke GitHub Actions | ✅ kode build & push Docker tersedia — perlu secrets Docker Hub |
| 4. Monitoring & Logging | ✅ serving + 3 metrik Prometheus/Grafana | ✅ 5+ metrik + 1 alert | ✅ 12 metrik tersedia + 3 contoh rule alert — screenshot & dashboard perlu dibuat manual |

Langkah-langkah yang **membutuhkan akun/kredensial eksternal atau screenshot
manual** (GitHub, DagsHub, Docker Hub, Prometheus UI, Grafana UI) tidak bisa
diselesaikan secara otomatis dari sini — ikuti instruksi di README masing-masing
subfolder untuk melengkapinya.
