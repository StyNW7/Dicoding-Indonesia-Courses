"""
Kriteria 2 - Basic: melatih model Machine Learning dengan MLflow autolog,
tracking disimpan secara lokal (MLflow Tracking UI di 127.0.0.1).

Jalankan:
    mlflow ui   (di terminal terpisah, agar UI dapat diakses di http://127.0.0.1:5000)
    python modelling.py
"""

import os

import mlflow
import mlflow.sklearn
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score

DATASET_DIR = os.path.join(os.path.dirname(__file__), "iris_preprocessing")


def load_dataset():
    train_df = pd.read_csv(os.path.join(DATASET_DIR, "train.csv"))
    test_df = pd.read_csv(os.path.join(DATASET_DIR, "test.csv"))

    X_train = train_df.drop(columns=["Species"])
    y_train = train_df["Species"]
    X_test = test_df.drop(columns=["Species"])
    y_test = test_df["Species"]
    return X_train, X_test, y_train, y_test


def main():
    mlflow.set_tracking_uri("http://127.0.0.1:5000/")
    mlflow.set_experiment("Iris Classification - Basic")

    X_train, X_test, y_train, y_test = load_dataset()

    mlflow.sklearn.autolog()

    with mlflow.start_run(run_name="random_forest_baseline"):
        model = RandomForestClassifier(n_estimators=100, random_state=42)
        model.fit(X_train, y_train)

        y_pred = model.predict(X_test)
        acc = accuracy_score(y_test, y_pred)
        print(f"Test accuracy: {acc:.4f}")


if __name__ == "__main__":
    main()
