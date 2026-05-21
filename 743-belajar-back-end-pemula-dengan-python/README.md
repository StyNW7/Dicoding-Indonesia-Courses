<div align="center">

# 🛍️ OpenShop RESTful API

**Backend RESTful API profesional untuk manajemen produk toko online**

*Proyek Akhir — Belajar Back-End Pemula dengan Python | Dicoding Indonesia*

---

![Python](https://img.shields.io/badge/Python-3.10%2B-3776AB?style=flat-square&logo=python&logoColor=white)
![Django](https://img.shields.io/badge/Django-4.2-092E20?style=flat-square&logo=django&logoColor=white)
![DRF](https://img.shields.io/badge/Django_REST_Framework-3.14-ff1709?style=flat-square&logo=django&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-3-003B57?style=flat-square&logo=sqlite&logoColor=white)
![Gunicorn](https://img.shields.io/badge/Gunicorn-21.2-499848?style=flat-square&logo=gunicorn&logoColor=white)
![Tests](https://img.shields.io/badge/Tests-12%20passed-brightgreen?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)

</div>

---

## 📖 Deskripsi Proyek

**OpenShop RESTful API** adalah layanan backend yang dibangun menggunakan **Python**, **Django**, dan **Django REST Framework** untuk mengelola data produk toko online secara penuh.

API ini menyediakan operasi **CRUD** lengkap (Create, Read, Update, Delete) serta kemampuan **pencarian produk** berdasarkan nama, kategori, dan deskripsi. Proyek ini dirancang dengan arsitektur RESTful yang bersih, validasi data yang ketat, pengujian otomatis, dan dokumentasi yang komprehensif.

### Fitur Utama

| # | Fitur | Deskripsi |
|---|---|---|
| 1 | **Simpan Produk** | Menambahkan data produk baru ke database |
| 2 | **Tampilkan Produk** | Menampilkan semua produk atau detail satu produk |
| 3 | **Ubah Produk** | Memperbarui seluruh atau sebagian data produk |
| 4 | **Hapus Produk** | Menghapus data produk dari database |
| 5 | **Cari Produk** | Mencari produk berdasarkan nama, kategori, atau deskripsi |

---

## 🏗️ Arsitektur & Teknologi

```
Client (Postman / Browser / Frontend)
        │
        │  HTTP Requests
        ▼
┌───────────────────────────────┐
│        Django URLs Router     │  ← /api/products/
├───────────────────────────────┤
│      ProductViewSet (DRF)     │  ← Business Logic
├───────────────────────────────┤
│     ProductSerializer (DRF)   │  ← Validasi & Serialisasi
├───────────────────────────────┤
│       Product Model (ORM)     │  ← Struktur Data
├───────────────────────────────┤
│         SQLite Database       │  ← Penyimpanan
└───────────────────────────────┘
```

### Stack Teknologi

| Teknologi | Versi | Kegunaan |
|---|---|---|
| Python | 3.10+ | Bahasa pemrograman utama |
| Django | 4.2 | Web framework |
| Django REST Framework | 3.14 | Pembangunan RESTful API |
| SQLite | 3 | Database (development) |
| Gunicorn | 21.2 | WSGI server (production/deployment) |

---

## 📁 Struktur Proyek

```
openshop/
│
├── manage.py                    # Entry point CLI Django
├── requirements.txt             # Daftar dependency Python
├── README.md                    # Dokumentasi proyek
├── .gitignore                   # File yang diabaikan Git
│
├── openshop/                    # Konfigurasi proyek utama
│   ├── __init__.py
│   ├── settings.py              # Konfigurasi Django & DRF
│   ├── urls.py                  # URL routing tingkat proyek
│   ├── wsgi.py                  # WSGI entry point (Gunicorn)
│   └── asgi.py                  # ASGI entry point
│
└── products/                    # Aplikasi produk
    ├── __init__.py
    ├── apps.py                  # Konfigurasi aplikasi
    ├── models.py                # Model database Product
    ├── serializers.py           # Serializer & validasi data
    ├── views.py                 # ViewSet & logika endpoint
    ├── urls.py                  # URL routing aplikasi
    ├── admin.py                 # Konfigurasi Django Admin
    ├── tests.py                 # Unit tests (12 test cases)
    └── migrations/
        ├── __init__.py
        └── 0001_initial.py      # Migrasi awal database
```

---

## 🚀 Panduan Instalasi & Menjalankan Proyek

### Prasyarat

Pastikan sistem Anda memiliki:
- **Python 3.10** atau lebih baru → [python.org](https://www.python.org/downloads/)
- **pip** (biasanya sudah terinstal bersama Python)
- **Git** (opsional, untuk clone repositori)

Verifikasi instalasi:
```bash
python --version   # Python 3.10.x
pip --version      # pip 23.x
```

---

### Langkah 1 — Masuk ke Direktori Proyek

```bash
cd openshop
```

---

### Langkah 2 — Buat Virtual Environment

Virtual environment mengisolasi dependency proyek agar tidak bentrok dengan sistem.

```bash
python -m venv venv
```

---

### Langkah 3 — Aktifkan Virtual Environment

**Windows (Command Prompt / PowerShell):**
```bash
venv\Scripts\activate
```

**macOS / Linux:**
```bash
source venv/bin/activate
```

Setelah aktif, prompt terminal akan berubah menjadi:
```
(venv) $
```

---

### Langkah 4 — Install Dependency

```bash
pip install -r requirements.txt
```

Dependency yang akan terinstal:
```
Django==4.2.x
djangorestframework==3.14.x
gunicorn==21.2.x
```

---

### Langkah 5 — Migrasi Database

Perintah ini membuat skema tabel database berdasarkan model yang sudah didefinisikan.

```bash
python manage.py migrate
```

Output yang diharapkan:
```
Operations to perform:
  Apply all migrations: admin, auth, contenttypes, products, sessions
Running migrations:
  Applying products.0001_initial... OK
  ...
```

---

### Langkah 6 — (Opsional) Buat Superuser Admin

Untuk mengakses antarmuka admin Django di `/admin/`.

```bash
python manage.py createsuperuser
```

Ikuti prompt untuk mengisi username, email, dan password.

---

### Langkah 7 — Jalankan Server

```bash
python manage.py runserver
```

Server akan berjalan di:

| URL | Deskripsi |
|---|---|
| `http://127.0.0.1:8000/api/products/` | Browsable API (DRF) |
| `http://127.0.0.1:8000/admin/` | Django Admin Panel |

---

## 📋 Model Data: Product

| Field | Tipe | Keterangan |
|---|---|---|
| `id` | `BigAutoField` | Primary key, otomatis |
| `name` | `CharField(100)` | Nama produk (**wajib**) |
| `description` | `TextField` | Deskripsi produk (**wajib**) |
| `price` | `DecimalField(12,2)` | Harga produk, tidak boleh negatif |
| `stock` | `PositiveIntegerField` | Jumlah stok, tidak boleh negatif |
| `category` | `CharField(100)` | Kategori produk (**wajib**) |
| `created_at` | `DateTimeField` | Waktu dibuat (otomatis) |
| `updated_at` | `DateTimeField` | Waktu diperbarui (otomatis) |

### Aturan Validasi

- `name` — tidak boleh kosong atau hanya spasi
- `price` — tidak boleh bernilai negatif
- `stock` — tidak boleh bernilai negatif

---

## 🔌 Dokumentasi API Endpoint

**Base URL:** `http://127.0.0.1:8000`

### Ringkasan Endpoint

| Method | Endpoint | Deskripsi |
|---|---|---|
| `GET` | `/api/products/` | Ambil semua produk |
| `POST` | `/api/products/` | Tambah produk baru |
| `GET` | `/api/products/{id}/` | Ambil detail produk |
| `PUT` | `/api/products/{id}/` | Update seluruh data produk |
| `PATCH` | `/api/products/{id}/` | Update sebagian data produk |
| `DELETE` | `/api/products/{id}/` | Hapus produk |
| `GET` | `/api/products/?search={keyword}` | Cari produk |

---

### `GET /api/products/` — Ambil Semua Produk

Menampilkan daftar seluruh produk, diurutkan dari yang terbaru.

**Request:**
```http
GET /api/products/ HTTP/1.1
Host: 127.0.0.1:8000
```

**Response `200 OK`:**
```json
[
  {
    "id": 1,
    "name": "Laptop Gaming ASUS ROG",
    "description": "Laptop gaming performa tinggi dengan GPU RTX 4060.",
    "price": "18500000.00",
    "stock": 5,
    "category": "Electronics",
    "created_at": "2026-05-21T10:00:00.000000Z",
    "updated_at": "2026-05-21T10:00:00.000000Z"
  },
  {
    "id": 2,
    "name": "Keyboard Mechanical RGB",
    "description": "Keyboard gaming dengan switch blue dan backlight RGB.",
    "price": "850000.00",
    "stock": 20,
    "category": "Accessories",
    "created_at": "2026-05-21T09:00:00.000000Z",
    "updated_at": "2026-05-21T09:00:00.000000Z"
  }
]
```

---

### `POST /api/products/` — Tambah Produk Baru

Menyimpan data produk baru ke dalam database.

**Request:**
```http
POST /api/products/ HTTP/1.1
Host: 127.0.0.1:8000
Content-Type: application/json

{
  "name": "Mouse Wireless Logitech",
  "description": "Mouse wireless ergonomis dengan DPI adjustable.",
  "price": "450000.00",
  "stock": 30,
  "category": "Accessories"
}
```

**Response `201 Created`:**
```json
{
  "id": 3,
  "name": "Mouse Wireless Logitech",
  "description": "Mouse wireless ergonomis dengan DPI adjustable.",
  "price": "450000.00",
  "stock": 30,
  "category": "Accessories",
  "created_at": "2026-05-21T11:30:00.000000Z",
  "updated_at": "2026-05-21T11:30:00.000000Z"
}
```

**Response `400 Bad Request` (validasi gagal):**
```json
{
  "price": ["Price cannot be negative."]
}
```

---

### `GET /api/products/{id}/` — Ambil Detail Produk

Menampilkan detail satu produk berdasarkan ID.

**Request:**
```http
GET /api/products/3/ HTTP/1.1
Host: 127.0.0.1:8000
```

**Response `200 OK`:**
```json
{
  "id": 3,
  "name": "Mouse Wireless Logitech",
  "description": "Mouse wireless ergonomis dengan DPI adjustable.",
  "price": "450000.00",
  "stock": 30,
  "category": "Accessories",
  "created_at": "2026-05-21T11:30:00.000000Z",
  "updated_at": "2026-05-21T11:30:00.000000Z"
}
```

**Response `404 Not Found`:**
```json
{
  "detail": "No Product matches the given query."
}
```

---

### `PUT /api/products/{id}/` — Update Seluruh Data Produk

Mengganti seluruh data produk. Semua field wajib disertakan.

**Request:**
```http
PUT /api/products/3/ HTTP/1.1
Host: 127.0.0.1:8000
Content-Type: application/json

{
  "name": "Mouse Wireless Logitech MX Master 3",
  "description": "Mouse wireless premium dengan sensor presisi tinggi untuk profesional.",
  "price": "1200000.00",
  "stock": 15,
  "category": "Accessories"
}
```

**Response `200 OK`:**
```json
{
  "id": 3,
  "name": "Mouse Wireless Logitech MX Master 3",
  "description": "Mouse wireless premium dengan sensor presisi tinggi untuk profesional.",
  "price": "1200000.00",
  "stock": 15,
  "category": "Accessories",
  "created_at": "2026-05-21T11:30:00.000000Z",
  "updated_at": "2026-05-21T14:00:00.000000Z"
}
```

---

### `PATCH /api/products/{id}/` — Update Sebagian Data Produk

Memperbarui hanya field yang dikirimkan. Field lain tidak berubah.

**Request:**
```http
PATCH /api/products/3/ HTTP/1.1
Host: 127.0.0.1:8000
Content-Type: application/json

{
  "price": "1100000.00",
  "stock": 25
}
```

**Response `200 OK`:**
```json
{
  "id": 3,
  "name": "Mouse Wireless Logitech MX Master 3",
  "description": "Mouse wireless premium dengan sensor presisi tinggi untuk profesional.",
  "price": "1100000.00",
  "stock": 25,
  "category": "Accessories",
  "created_at": "2026-05-21T11:30:00.000000Z",
  "updated_at": "2026-05-21T15:00:00.000000Z"
}
```

---

### `DELETE /api/products/{id}/` — Hapus Produk

Menghapus produk secara permanen dari database.

**Request:**
```http
DELETE /api/products/3/ HTTP/1.1
Host: 127.0.0.1:8000
```

**Response `204 No Content`:**
```
(body kosong)
```

---

### `GET /api/products/?search={keyword}` — Cari Produk

Mencari produk berdasarkan kata kunci pada field `name`, `category`, dan `description`. Pencarian bersifat **case-insensitive**.

**Request:**
```http
GET /api/products/?search=wireless HTTP/1.1
Host: 127.0.0.1:8000
```

**Response `200 OK`:**
```json
[
  {
    "id": 3,
    "name": "Mouse Wireless Logitech MX Master 3",
    "description": "Mouse wireless premium dengan sensor presisi tinggi untuk profesional.",
    "price": "1100000.00",
    "stock": 25,
    "category": "Accessories",
    "created_at": "2026-05-21T11:30:00.000000Z",
    "updated_at": "2026-05-21T15:00:00.000000Z"
  }
]
```

**Response `200 OK` (tidak ditemukan):**
```json
[]
```

> **Tip:** Pencarian juga mendukung filter berdasarkan kategori.
> Contoh: `GET /api/products/?search=Electronics`

---

## 🧪 Menjalankan Unit Test

Proyek ini dilengkapi dengan **12 unit test** yang mencakup seluruh fungsionalitas API.

```bash
python manage.py test products --verbosity=2
```

### Daftar Test Cases

| Test Class | Test Case | Deskripsi |
|---|---|---|
| `ProductCreateTest` | `test_create_product_success` | Produk berhasil dibuat |
| `ProductCreateTest` | `test_create_product_negative_price_fails` | Harga negatif ditolak |
| `ProductCreateTest` | `test_create_product_empty_name_fails` | Nama kosong ditolak |
| `ProductListTest` | `test_get_product_list` | Daftar produk berhasil diambil |
| `ProductDetailTest` | `test_get_product_detail` | Detail produk berhasil diambil |
| `ProductDetailTest` | `test_get_nonexistent_product_returns_404` | Produk tidak ada mengembalikan 404 |
| `ProductUpdateTest` | `test_full_update_product` | PUT berhasil memperbarui semua field |
| `ProductUpdateTest` | `test_partial_update_product` | PATCH berhasil memperbarui sebagian field |
| `ProductDeleteTest` | `test_delete_product` | Produk berhasil dihapus |
| `ProductSearchTest` | `test_search_by_name` | Pencarian berdasarkan nama berhasil |
| `ProductSearchTest` | `test_search_by_category` | Pencarian berdasarkan kategori berhasil |
| `ProductSearchTest` | `test_search_no_results` | Pencarian tanpa hasil mengembalikan list kosong |

**Output yang diharapkan:**
```
Found 12 test(s).
test_create_product_empty_name_fails ... ok
test_create_product_negative_price_fails ... ok
test_create_product_success ... ok
test_delete_product ... ok
test_get_nonexistent_product_returns_404 ... ok
test_get_product_detail ... ok
test_get_product_list ... ok
test_search_by_category ... ok
test_search_by_name ... ok
test_search_no_results ... ok
test_full_update_product ... ok
test_partial_update_product ... ok

----------------------------------------------------------------------
Ran 12 tests in 0.063s

OK
```

---

## 🌐 Pengujian dengan Postman

Postman sangat direkomendasikan untuk menguji endpoint API secara manual.

### Setup Postman

1. Download dan install [Postman](https://www.postman.com/downloads/)
2. Buat **Collection** baru dengan nama `OpenShop API`
3. Set **base URL** variable: `http://127.0.0.1:8000`

### Contoh Request di Postman

| Aksi | Method | URL |
|---|---|---|
| List semua produk | `GET` | `{{base_url}}/api/products/` |
| Buat produk | `POST` | `{{base_url}}/api/products/` |
| Detail produk | `GET` | `{{base_url}}/api/products/1/` |
| Update penuh | `PUT` | `{{base_url}}/api/products/1/` |
| Update sebagian | `PATCH` | `{{base_url}}/api/products/1/` |
| Hapus produk | `DELETE` | `{{base_url}}/api/products/1/` |
| Cari produk | `GET` | `{{base_url}}/api/products/?search=laptop` |

> Untuk request `POST`, `PUT`, `PATCH` — set header `Content-Type: application/json` dan isi **Body → raw → JSON**.

---

## 🖥️ Browsable API (Django REST Framework)

Django REST Framework menyediakan antarmuka web interaktif untuk mengakses API langsung dari browser.

Buka: **http://127.0.0.1:8000/api/products/**

Fitur yang tersedia:
- Melihat daftar semua endpoint
- Melakukan request `GET`, `POST`, `PUT`, `PATCH`, `DELETE` langsung dari browser
- Melihat response JSON yang terformat rapi

---

## ⚙️ Django Admin Panel

Django Admin memungkinkan pengelolaan data produk melalui antarmuka visual.

**URL:** `http://127.0.0.1:8000/admin/`

Fitur admin yang dikonfigurasi:
- **List Display:** Nama, Kategori, Harga, Stok, Tanggal Dibuat
- **Search:** Cari berdasarkan nama, kategori, deskripsi
- **Filter:** Filter berdasarkan kategori dan tanggal dibuat
- **Ordering:** Diurutkan dari produk terbaru

---

## 🚢 Deploy dengan Gunicorn

Gunicorn adalah WSGI HTTP server untuk menjalankan aplikasi Django di lingkungan production.

### Langkah Deploy

**1. Sesuaikan konfigurasi `settings.py` untuk production:**

```python
DEBUG = False
ALLOWED_HOSTS = ['your-domain.com', 'your-server-ip']
SECRET_KEY = 'your-strong-production-secret-key'
```

**2. Kumpulkan static files:**

```bash
python manage.py collectstatic
```

**3. Jalankan Gunicorn:**

```bash
gunicorn openshop.wsgi --bind 0.0.0.0:8000
```

**4. Jalankan dengan beberapa worker (production):**

```bash
gunicorn openshop.wsgi --bind 0.0.0.0:8000 --workers 3 --daemon
```

| Flag | Deskripsi |
|---|---|
| `--bind 0.0.0.0:8000` | Mendengarkan semua interface di port 8000 |
| `--workers 3` | Menjalankan 3 worker processes |
| `--daemon` | Menjalankan Gunicorn di background |

---

## 📚 Referensi Perintah Terminal

Rangkuman seluruh perintah dari awal hingga proyek berjalan:

```bash
# 1. Masuk ke direktori proyek
cd openshop

# 2. Buat virtual environment
python -m venv venv

# 3. Aktifkan virtual environment (Windows)
venv\Scripts\activate

# 4. Install semua dependency
pip install -r requirements.txt

# 5. Jalankan migrasi database
python manage.py migrate

# 6. (Opsional) Buat superuser
python manage.py createsuperuser

# 7. Jalankan development server
python manage.py runserver

# 8. Jalankan semua unit test
python manage.py test products --verbosity=2

# 9. (Production) Jalankan dengan Gunicorn
gunicorn openshop.wsgi --bind 0.0.0.0:8000
```

---

## ✅ Checklist Submission Dicoding

- [x] RESTful API dapat menyimpan data produk → `POST /api/products/`
- [x] RESTful API dapat menampilkan data produk → `GET /api/products/` & `GET /api/products/{id}/`
- [x] RESTful API dapat mengubah data produk → `PUT /api/products/{id}/` & `PATCH /api/products/{id}/`
- [x] RESTful API dapat menghapus data produk → `DELETE /api/products/{id}/`
- [x] RESTful API dapat mencari data produk → `GET /api/products/?search={keyword}`

---

## 📄 Lisensi

Proyek ini dibuat untuk keperluan **pendidikan** dalam rangka submission kelas **Belajar Back-End Pemula dengan Python** di [Dicoding Indonesia](https://www.dicoding.com).

---

<div align="center">

Dibuat dengan ❤️ menggunakan Python & Django REST Framework

**[Dicoding Indonesia](https://www.dicoding.com) — Belajar Back-End Pemula dengan Python**

</div>
