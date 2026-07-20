"""
Kriteria 2 - Skilled (+ Advance-ready): melatih model dengan hyperparameter
tuning (GridSearchCV) dan MANUAL logging ke MLflow (bukan autolog), dengan
metrik yang setara autolog plus artefak tambahan.

Tracking lokal (skilled):
    mlflow ui
    python modelling_tuning.py

Tracking online ke DagsHub (advance): set environment variable berikut
sebelum menjalankan script, atau isi langsung di bagian "DagsHub (advance)"
di bawah.
    DAGSHUB_REPO_OWNER, DAGSHUB_REPO_NAME
"""

import json
import os

import joblib
import matplotlib.pyplot as plt
import mlflow
import mlflow.sklearn
import pandas as pd
import seaborn as sns
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import (
    accuracy_score,
    confusion_matrix,
    f1_score,
    precision_score,
    recall_score,
)
from sklearn.model_selection import GridSearchCV
from sklearn.utils import estimator_html_repr

DATASET_DIR = os.path.join(os.path.dirname(__file__), "iris_preprocessing")
ARTIFACT_DIR = os.path.join(os.path.dirname(__file__), "artifacts_tmp")

PARAM_GRID = {
    "n_estimators": [50, 100, 200],
    "max_depth": [None, 5, 10],
    "min_samples_split": [2, 5],
}


def load_dataset():
    train_df = pd.read_csv(os.path.join(DATASET_DIR, "train.csv"))
    test_df = pd.read_csv(os.path.join(DATASET_DIR, "test.csv"))

    X_train = train_df.drop(columns=["Species"])
    y_train = train_df["Species"]
    X_test = test_df.drop(columns=["Species"])
    y_test = test_df["Species"]
    return X_train, X_test, y_train, y_test


def setup_tracking():
    """Aktifkan tracking online ke DagsHub jika kredensial tersedia (advance),
    jika tidak jatuh kembali ke tracking lokal (skilled)."""
    repo_owner = os.environ.get("DAGSHUB_REPO_OWNER")
    repo_name = os.environ.get("DAGSHUB_REPO_NAME")

    if repo_owner and repo_name:
        import dagshub

        dagshub.init(repo_owner=repo_owner, repo_name=repo_name, mlflow=True)
        print(f"Tracking online ke DagsHub: {repo_owner}/{repo_name}")
    else:
        mlflow.set_tracking_uri("http://127.0.0.1:5000/")
        print("Tracking lokal ke http://127.0.0.1:5000/")

    mlflow.set_experiment("Iris Classification - Tuning")


def main():
    os.makedirs(ARTIFACT_DIR, exist_ok=True)
    setup_tracking()

    X_train, X_test, y_train, y_test = load_dataset()

    with mlflow.start_run(run_name="random_forest_gridsearch"):
        grid_search = GridSearchCV(
            RandomForestClassifier(random_state=42),
            param_grid=PARAM_GRID,
            cv=5,
            scoring="accuracy",
            n_jobs=-1,
        )
        grid_search.fit(X_train, y_train)
        best_model = grid_search.best_estimator_

        y_pred = best_model.predict(X_test)

        # ---- metrik setara autolog ----
        acc = accuracy_score(y_test, y_pred)
        precision = precision_score(y_test, y_pred, average="macro")
        recall = recall_score(y_test, y_pred, average="macro")
        f1 = f1_score(y_test, y_pred, average="macro")
        training_score = grid_search.best_score_

        mlflow.log_params(grid_search.best_params_)
        mlflow.log_param("cv_folds", 5)
        mlflow.log_metric("accuracy", acc)
        mlflow.log_metric("precision_macro", precision)
        mlflow.log_metric("recall_macro", recall)
        mlflow.log_metric("f1_macro", f1)
        mlflow.log_metric("training_score", training_score)

        mlflow.sklearn.log_model(best_model, artifact_path="model")

        # ---- artefak tambahan setara autolog ----
        cm = confusion_matrix(y_test, y_pred)
        cm_path = os.path.join(ARTIFACT_DIR, "training_confusion_matrix.png")
        plt.figure(figsize=(6, 5))
        sns.heatmap(cm, annot=True, fmt="d", cmap="Blues")
        plt.title("Confusion Matrix")
        plt.xlabel("Predicted")
        plt.ylabel("Actual")
        plt.savefig(cm_path, bbox_inches="tight")
        plt.close()
        mlflow.log_artifact(cm_path)

        metric_info = {
            "accuracy": acc,
            "precision_macro": precision,
            "recall_macro": recall,
            "f1_macro": f1,
            "best_params": grid_search.best_params_,
        }
        metric_info_path = os.path.join(ARTIFACT_DIR, "metric_info.json")
        with open(metric_info_path, "w") as f:
            json.dump(metric_info, f, indent=2)
        mlflow.log_artifact(metric_info_path)

        # ---- 2 artefak tambahan di luar cakupan autolog (advance) ----
        estimator_html_path = os.path.join(ARTIFACT_DIR, "estimator.html")
        with open(estimator_html_path, "w") as f:
            f.write(estimator_html_repr(best_model))
        mlflow.log_artifact(estimator_html_path)

        importances = pd.Series(
            best_model.feature_importances_, index=X_train.columns
        ).sort_values(ascending=False)
        fi_path = os.path.join(ARTIFACT_DIR, "feature_importance.png")
        plt.figure(figsize=(6, 4))
        importances.plot(kind="bar")
        plt.title("Feature Importance")
        plt.tight_layout()
        plt.savefig(fi_path)
        plt.close()
        mlflow.log_artifact(fi_path)

        model_pkl_path = os.path.join(ARTIFACT_DIR, "model.pkl")
        joblib.dump(best_model, model_pkl_path)
        mlflow.log_artifact(model_pkl_path)

        print(f"Best params: {grid_search.best_params_}")
        print(f"Test accuracy: {acc:.4f} | precision: {precision:.4f} | "
              f"recall: {recall:.4f} | f1: {f1:.4f}")


if __name__ == "__main__":
    main()
