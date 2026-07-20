"""
Kriteria 4 - Serving model + Prometheus exporter.

Menjalankan sebuah Flask API yang men-serve model Iris (hasil training pada
Kriteria 2/3) sekaligus mengekspos endpoint /metrics dengan >= 10 metrik
Prometheus (basic butuh 3, skilled 5, advance 10).

Jalankan:
    python "3.prometheus_exporter.py"

Endpoint:
    POST /predict   -> melakukan prediksi & mencatat metrik
    GET  /health     -> health check sederhana
    GET  /metrics    -> metrik dalam format Prometheus
"""

import os
import time

import joblib
import pandas as pd
import psutil
from flask import Flask, jsonify, request
from prometheus_client import (
    CONTENT_TYPE_LATEST,
    Counter,
    Gauge,
    Histogram,
    generate_latest,
)

MODEL_PATH = os.environ.get(
    "MODEL_PATH",
    os.path.join(
        os.path.dirname(__file__), "..", "Membangun_model", "artifacts_tmp", "model.pkl"
    ),
)
FEATURE_COLUMNS = ["SepalLengthCm", "SepalWidthCm", "PetalLengthCm", "PetalWidthCm"]
SPECIES_MAP = {0: "Iris-setosa", 1: "Iris-versicolor", 2: "Iris-virginica"}

app = Flask(__name__)

START_TIME = time.time()

# ---------------------------------------------------------------------------
# Prometheus metrics (>= 10 metrik berbeda untuk memenuhi kriteria Advance)
# ---------------------------------------------------------------------------
HTTP_REQUESTS_TOTAL = Counter(
    "http_requests_total", "Total HTTP request yang diterima", ["endpoint", "method", "status"]
)
REQUEST_LATENCY = Histogram(
    "http_request_duration_seconds", "Durasi pemrosesan request", ["endpoint"]
)
PREDICTION_COUNT = Counter(
    "prediction_count_total", "Jumlah prediksi per kelas", ["predicted_class"]
)
PREDICTION_ERRORS = Counter(
    "prediction_errors_total", "Jumlah error saat melakukan prediksi"
)
ACTIVE_REQUESTS = Gauge("active_requests", "Jumlah request yang sedang diproses")
MODEL_ACCURACY = Gauge("model_accuracy", "Akurasi model pada test set (dari training)")
MODEL_F1_SCORE = Gauge("model_f1_score", "F1-score macro model pada test set")
MODEL_LOAD_TIME = Gauge("model_load_time_seconds", "Waktu yang dibutuhkan untuk memuat model")
SYSTEM_CPU_USAGE = Gauge("system_cpu_usage", "Penggunaan CPU sistem (%)")
SYSTEM_RAM_USAGE = Gauge("system_ram_usage", "Penggunaan RAM sistem (%)")
SYSTEM_RAM_USAGE_MB = Gauge("system_ram_usage_mb", "Penggunaan RAM sistem (MB)")
PROCESS_UPTIME = Gauge("process_uptime_seconds", "Lama waktu exporter berjalan (detik)")
THROUGHPUT_TOTAL = Counter("throughput_requests_total", "Total request yang berhasil diproses")

_model = None


def load_model():
    global _model
    start = time.time()
    _model = joblib.load(MODEL_PATH)
    MODEL_LOAD_TIME.set(time.time() - start)

    # Nilai akurasi/F1 hasil evaluasi terakhir (lihat metric_info.json dari modelling_tuning.py)
    metric_info_path = os.path.join(
        os.path.dirname(__file__), "..", "Membangun_model", "artifacts_tmp", "metric_info.json"
    )
    if os.path.exists(metric_info_path):
        import json

        with open(metric_info_path) as f:
            info = json.load(f)
        MODEL_ACCURACY.set(info.get("accuracy", 0))
        MODEL_F1_SCORE.set(info.get("f1_macro", 0))


@app.before_request
def before_request():
    request._start_time = time.time()
    ACTIVE_REQUESTS.inc()


@app.after_request
def after_request(response):
    latency = time.time() - getattr(request, "_start_time", time.time())
    REQUEST_LATENCY.labels(endpoint=request.path).observe(latency)
    HTTP_REQUESTS_TOTAL.labels(
        endpoint=request.path, method=request.method, status=response.status_code
    ).inc()
    ACTIVE_REQUESTS.dec()

    SYSTEM_CPU_USAGE.set(psutil.cpu_percent())
    mem = psutil.virtual_memory()
    SYSTEM_RAM_USAGE.set(mem.percent)
    SYSTEM_RAM_USAGE_MB.set(mem.used / (1024 * 1024))
    PROCESS_UPTIME.set(time.time() - START_TIME)
    return response


@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "ok"})


@app.route("/predict", methods=["POST"])
def predict():
    try:
        payload = request.get_json(force=True)
        df = pd.DataFrame(payload["data"], columns=FEATURE_COLUMNS)
        preds = _model.predict(df)

        for p in preds:
            PREDICTION_COUNT.labels(predicted_class=SPECIES_MAP.get(int(p), str(p))).inc()
        THROUGHPUT_TOTAL.inc(len(preds))

        return jsonify(
            {"predictions": [SPECIES_MAP.get(int(p), str(p)) for p in preds]}
        )
    except Exception as exc:  # noqa: BLE001
        PREDICTION_ERRORS.inc()
        return jsonify({"error": str(exc)}), 400


@app.route("/metrics", methods=["GET"])
def metrics():
    return generate_latest(), 200, {"Content-Type": CONTENT_TYPE_LATEST}


if __name__ == "__main__":
    load_model()
    app.run(host="0.0.0.0", port=8000)
