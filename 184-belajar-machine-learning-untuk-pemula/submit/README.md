# Breast Cancer Wisconsin — Clustering & Classification

**Proyek Machine Learning** | Dicoding Indonesia — Belajar Machine Learning untuk Pemula

> Unsupervised clustering with K-Means followed by supervised classification with Decision Tree on the Breast Cancer Wisconsin dataset.

---

## Overview

This project applies a two-stage machine learning pipeline to the Breast Cancer Wisconsin dataset:

1. **K-Means Clustering** — groups samples by morphological similarity, without using diagnosis labels.
2. **Decision Tree Classification** — learns to predict the cluster label of unseen samples.

The workflow covers end-to-end ML practice: EDA, preprocessing, clustering with elbow-method tuning, cluster interpretation, and classification with full evaluation.

---

## Dataset

| Attribute | Detail |
|---|---|
| **Name** | Breast Cancer Wisconsin (Diagnostic) |
| **Source** | [Kaggle — UCI ML Repository](https://www.kaggle.com/datasets/uciml/breast-cancer-wisconsin-data) |
| **File** | `data.csv` |
| **Samples** | 569 |
| **Raw columns** | 33 (`id`, `diagnosis`, 30 numeric features, `Unnamed: 32`) |
| **Used columns** | 31 (after removing `id` and `Unnamed: 32`) |
| **Target (original)** | `diagnosis` — B: Benign (357, 62.7%) / M: Malignant (212, 37.3%) |

### Feature Groups

Each cell nucleus is described across three statistical summaries — **mean**, **standard error (se)**, and **worst** — for 10 base measurements:

| # | Feature |
|---|---|
| 1 | `radius` — mean distance from center to perimeter |
| 2 | `texture` — standard deviation of gray-scale values |
| 3 | `perimeter` |
| 4 | `area` |
| 5 | `smoothness` — local variation in radius lengths |
| 6 | `compactness` — perimeter² / area − 1.0 |
| 7 | `concavity` — severity of concave portions of the contour |
| 8 | `concave points` — number of concave portions |
| 9 | `symmetry` |
| 10 | `fractal_dimension` — coastline approximation |

---

## Project Structure

```
184-belajar-machine-learning-untuk-pemula/
├── data.csv                  # Dataset
├── code.ipynb                # Main notebook (full pipeline)
├── model_clustering          # Saved K-Means model (joblib)
├── decision_tree_model.h5    # Saved Decision Tree model (joblib)
└── tasks/
    └── criteria.md           # Submission criteria reference
```

---

## Dependencies

```
pandas
numpy
matplotlib
seaborn
scikit-learn
yellowbrick
joblib
```

Install all at once:

```bash
pip install pandas numpy matplotlib seaborn scikit-learn yellowbrick joblib
```

---

## Notebook Structure

| Section | Description |
|---|---|
| **1. Import Library** | All required imports and display configuration |
| **2. Load Dataset** | Read CSV, preview, `df.info()`, `df.describe()` |
| **3. EDA** | Class distribution, boxplots, correlation heatmap, histograms |
| **4. Preprocessing** | Drop irrelevant columns, encode `diagnosis`, StandardScaler |
| **5. Clustering** | Elbow Method → K-Means training → scatter visualization |
| **6. Cluster Interpretation** | Aggregation stats (mean/min/max), bar charts, descriptive analysis |
| **7. Classification Setup** | Feature/target split, stratified train-test split (80/20) |
| **8. Decision Tree** | Train, predict, evaluate (accuracy, report, confusion matrix, feature importance) |
| **9. Conclusion** | Summary of results and saved models |

---

## Results

### Data Cleaning Summary

| Step | Result |
|---|---|
| Missing values | `Unnamed: 32`: 569/569 (100%) — dropped |
| Duplicate rows | 0 |
| Columns removed | `id`, `Unnamed: 32` |
| Encoding | `diagnosis`: B → 0, M → 1 |
| Scaling | StandardScaler (mean ≈ 0, std ≈ 1) |

---

### Clustering — K-Means (k = 5)

The Elbow Method identified **k = 5** as the optimal number of clusters (inertia: 8692.22).

| Cluster | Samples | % of Total | Malignant (%) | Interpretation |
|---|---|---|---|---|
| **0** | 39 | 6.9% | **100.0%** | Very large, highly irregular tumors |
| **1** | 51 | 9.0% | **66.7%** | Medium-sized, moderately irregular tumors |
| **2** | 122 | 21.4% | **100.0%** | Medium-to-large malignant tumors |
| **3** | 205 | 36.0% | 7.3% | Small-to-medium, mostly benign tumors |
| **4** | 152 | 26.7% | **1.3%** | Small, highly regular benign tumors |

**Key cluster statistics (mean values):**

| Cluster | radius_mean | area_mean | concavity_mean | concave_pts_mean |
|---|---|---|---|---|
| 0 | 21.25 | 1430.0 | 0.2575 | 0.1364 |
| 1 | 13.11 | 542.9 | 0.1807 | 0.0719 |
| 2 | 17.64 | 981.3 | 0.1384 | 0.0814 |
| 3 | 12.93 | 524.2 | 0.0321 | 0.0213 |
| 4 | 11.44 | 407.9 | 0.0513 | 0.0300 |

**Biological interpretation:**
- Clusters 0 and 2 are purely Malignant — distinguished by size (Cluster 0 is significantly larger with higher concavity).
- Cluster 3 and 4 are predominantly Benign — Cluster 4 contains the smallest and most regular cells.
- Cluster 1 is mixed, representing borderline cases with moderate size and irregularity.

---

### Classification — Decision Tree

**Train/Test split:** 455 training samples (80%) / 114 test samples (20%), stratified.

| Metric | Value |
|---|---|
| **Accuracy** | **86.84%** |
| Tree depth | 9 levels |
| Leaf nodes | 41 |
| Features used | 31 |

**Classification Report (per cluster):**

| Cluster | Precision | Recall | F1-Score | Support |
|---|---|---|---|---|
| Cluster 0 | 1.00 | 0.88 | 0.93 | 8 |
| Cluster 1 | 0.75 | 0.90 | 0.82 | 10 |
| Cluster 2 | 0.92 | 0.92 | 0.92 | 24 |
| Cluster 3 | 0.90 | 0.85 | 0.88 | 41 |
| Cluster 4 | 0.81 | 0.84 | 0.83 | 31 |
| **Macro avg** | **0.88** | **0.88** | **0.87** | 114 |
| **Weighted avg** | **0.87** | **0.87** | **0.87** | 114 |

Cluster 0 achieves perfect precision (1.00) — all samples predicted as Cluster 0 are correct. Cluster 1 has the lowest precision (0.75), which is expected given it contains the most morphologically ambiguous samples (mixed Benign/Malignant).

---

### Saved Models

| File | Algorithm | Format |
|---|---|---|
| `model_clustering` | K-Means (k=5) | joblib |
| `decision_tree_model.h5` | Decision Tree | joblib |

Load models for inference:

```python
import joblib

model_clustering = joblib.load('model_clustering')
decision_tree_model = joblib.load('decision_tree_model.h5')
```

---

## How to Run

1. Ensure `data.csv` is in the same directory as `code.ipynb`.
2. Install dependencies (see [Dependencies](#dependencies)).
3. Open `code.ipynb` in Jupyter and run all cells top-to-bottom (`Run All`).

---

## Author

**Stanley Nathanael Wijaya**
Submission for Dicoding Indonesia — *Belajar Machine Learning untuk Pemula*
