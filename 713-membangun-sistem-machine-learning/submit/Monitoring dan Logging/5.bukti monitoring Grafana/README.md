# Bukti Monitoring Grafana

PENTING: nama dashboard Grafana **harus** mengandung username akun Dicoding
kamu, contoh `dashboard-<username_dicoding>`, agar terlihat di screenshot.

## Langkah

1. Jalankan Grafana (Docker paling cepat):
   ```
   docker run -d --name=grafana -p 3000:3000 grafana/grafana-oss
   ```
2. Login ke `http://localhost:3000` (default admin/admin), tambahkan data
   source **Prometheus** dengan URL `http://host.docker.internal:9090`
   (Windows/Mac) atau `http://172.17.0.1:9090` (Linux).
3. Buat dashboard baru, beri nama `dashboard-<username_dicoding>`.
4. Tambahkan satu panel per metrik yang sama dengan yang sudah kamu
   screenshot di folder Prometheus (minimal 3 untuk Basic, 5 untuk Skilled,
   10 untuk Advance).
5. Screenshot tiap panel/metrik dan simpan sebagai
   `1.monitoring_<metrik>.jpg`, `2.monitoring_<metrik>.jpg`, dst di folder ini
   — pastikan nama dashboard di bagian atas screenshot terlihat jelas.
