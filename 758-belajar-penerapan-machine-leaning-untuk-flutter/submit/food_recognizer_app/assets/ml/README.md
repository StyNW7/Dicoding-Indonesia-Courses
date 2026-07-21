# Model ML

Letakkan berkas model TensorFlow Lite di folder ini dengan nama persis:

```
assets/ml/food_classifier.tflite
```

Unduh modelnya dari Kaggle (perlu login akun Kaggle):
https://www.kaggle.com/models/google/aiy/tfLite/vision-classifier-food-v1

`labels.txt` di folder ini **sudah disertakan** (2024 baris: `__background__` +
2023 nama makanan sesuai urutan output model, diambil dari label map resmi
Google di `https://www.gstatic.com/aihub/tfhub/labelmaps/aiy_food_V1_labelmap.csv`).
Anda tidak perlu mengunduhnya lagi kecuali ingin memverifikasi ulang.

Spesifikasi model (lihat `others.pdf`):
- Input: gambar 224x224 RGB.
- Output: probabilitas 2023 nama makanan (+ 1 kelas `__background__` di index 0).
