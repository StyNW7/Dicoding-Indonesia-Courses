# Membangun_model

Bagian **Kriteria 2** (Membangun Model Machine Learning). Dijalankan di
local environment sebagai jembatan ke Kriteria 3.

```
Membangun_model/
├── modelling.py            (Basic: MLflow autolog)
├── modelling_tuning.py     (Skilled/Advance: GridSearchCV + manual logging)
├── iris_preprocessing/     (dataset siap latih, hasil dari Kriteria 1)
├── requirements.txt
├── DagsHub.txt
├── screenshoot_dashboard.jpg   (isi manual, lihat langkah di bawah)
└── screenshoot_artifak.jpg     (isi manual, lihat langkah di bawah)
```

## Menjalankan

```
pip install -r requirements.txt

# Terminal 1: jalankan MLflow Tracking UI lokal
mlflow ui

# Terminal 2: basic (autolog)
python modelling.py

# Terminal 2: skilled (tuning + manual logging)
python modelling_tuning.py

# Advance (opsional, tracking online ke DagsHub):
# set DAGSHUB_REPO_OWNER=<username> && set DAGSHUB_REPO_NAME=<repo> && python modelling_tuning.py
```

## Mengambil screenshot yang diminta

1. Buka `http://127.0.0.1:5000` setelah `modelling.py` / `modelling_tuning.py`
   selesai berjalan.
2. Screenshot halaman **Experiments** (daftar run) → simpan sebagai
   `screenshoot_dashboard.jpg`.
3. Klik salah satu run → tab **Artifacts** → screenshot daftar artefak
   (model, confusion matrix, metric_info.json, estimator.html, dll) → simpan
   sebagai `screenshoot_artifak.jpg`.
