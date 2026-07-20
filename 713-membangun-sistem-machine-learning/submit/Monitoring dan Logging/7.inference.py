"""
Kriteria 4 - Script inference untuk menguji model yang sedang di-serve
sekaligus membangkitkan traffic supaya metrik di Prometheus/Grafana terisi.

Jalankan setelah "3.prometheus_exporter.py" aktif di port 8000:
    python "7.inference.py"
    python "7.inference.py" --loop 200 --delay 0.2
"""

import argparse
import random
import time

import requests

ENDPOINT = "http://127.0.0.1:8000/predict"

SAMPLE_ROWS = [
    [-1.47, 1.20, -1.56, -1.31],   # cenderung Iris-setosa (data sudah discale)
    [0.55, -0.36, 0.25, 0.13],      # cenderung Iris-versicolor
    [1.15, -0.13, 0.98, 1.18],      # cenderung Iris-virginica
]


def send_request():
    row = random.choice(SAMPLE_ROWS)
    response = requests.post(ENDPOINT, json={"data": [row]}, timeout=5)
    print(response.status_code, response.json())


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--loop", type=int, default=20, help="Jumlah request yang dikirim")
    parser.add_argument("--delay", type=float, default=0.5, help="Jeda antar request (detik)")
    args = parser.parse_args()

    for i in range(args.loop):
        try:
            send_request()
        except requests.exceptions.RequestException as exc:
            print(f"Request gagal: {exc}")
        time.sleep(args.delay)


if __name__ == "__main__":
    main()
