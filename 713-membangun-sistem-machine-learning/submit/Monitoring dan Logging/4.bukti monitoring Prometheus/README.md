# Bukti Monitoring Prometheus

`3.prometheus_exporter.py` mengekspos 12 metrik lewat `/metrics`, cukup untuk
Basic (3), Skilled (5), dan Advance (10). Ambil screenshot query masing-masing
metrik di Prometheus UI (`http://127.0.0.1:9090/graph`) dan simpan di sini
dengan format `1.monitoring_<metrik>.jpg`, `2.monitoring_<metrik>.jpg`, dst.

Daftar metrik yang tersedia (pilih sesuai target poin):

1. `http_requests_total`
2. `http_request_duration_seconds`
3. `prediction_count_total`
4. `prediction_errors_total`
5. `active_requests`
6. `model_accuracy`
7. `model_f1_score`
8. `model_load_time_seconds`
9. `system_cpu_usage`
10. `system_ram_usage`
11. `system_ram_usage_mb`
12. `process_uptime_seconds`
13. `throughput_requests_total`

## Cara menjalankan Prometheus lokal

1. Download Prometheus dari https://prometheus.io/download/ lalu extract.
2. Jalankan exporter (lihat root README) sehingga `127.0.0.1:8000/metrics` aktif.
3. Jalankan Prometheus dengan config di folder ini (`../2.prometheus.yml`):
   ```
   ./prometheus --config.file=../2.prometheus.yml
   ```
4. Buka `http://127.0.0.1:9090`, jalankan query tiap metrik pada tab **Graph**,
   lalu screenshot hasilnya.
5. Untuk membangkitkan traffic sebelum screenshot, jalankan:
   ```
   python "../7.inference.py" --loop 100 --delay 0.1
   ```
