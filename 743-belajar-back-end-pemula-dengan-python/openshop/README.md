<div align="center">

# 🛍️ OpenShop RESTful API

**A professional backend RESTful API for online store product management**

*Final Project — Belajar Back-End Pemula dengan Python | Dicoding Indonesia*

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

## 📖 About the Project

**OpenShop RESTful API** is a backend service built with **Python**, **Django**, and **Django REST Framework** to manage online store product data.

The API provides full **CRUD** operations (Create, Read, Update, Delete) along with **product search** capability by name, category, and description. The project is designed with a clean RESTful architecture, strict data validation, automated testing, and comprehensive documentation.

### Core Features

| # | Feature | Description |
|---|---|---|
| 1 | **Create Product** | Add new product data to the database |
| 2 | **Read Product** | Retrieve all products or a single product's detail |
| 3 | **Update Product** | Fully or partially update product data |
| 4 | **Delete Product** | Permanently remove a product from the database |
| 5 | **Search Product** | Search products by name, category, or description |

---

## 🏗️ Architecture & Technology

```
Client (Postman / Browser / Frontend)
        │
        │  HTTP Requests
        ▼
┌───────────────────────────────┐
│        Django URL Router      │  ← /api/products/
├───────────────────────────────┤
│      ProductViewSet (DRF)     │  ← Business Logic
├───────────────────────────────┤
│     ProductSerializer (DRF)   │  ← Validation & Serialization
├───────────────────────────────┤
│       Product Model (ORM)     │  ← Data Structure
├───────────────────────────────┤
│         SQLite Database       │  ← Data Storage
└───────────────────────────────┘
```

### Technology Stack

| Technology | Version | Purpose |
|---|---|---|
| Python | 3.10+ | Primary programming language |
| Django | 4.2 | Web framework |
| Django REST Framework | 3.14 | RESTful API toolkit |
| SQLite | 3 | Database (development) |
| Gunicorn | 21.2 | WSGI server (production/deployment) |

---

## 📁 Project Structure

```
openshop/
│
├── manage.py                    # Django CLI entry point
├── requirements.txt             # Python dependency list
├── README.md                    # Project documentation
├── .gitignore                   # Git ignored files
│
├── openshop/                    # Main project configuration
│   ├── __init__.py
│   ├── settings.py              # Django & DRF configuration
│   ├── urls.py                  # Project-level URL routing
│   ├── wsgi.py                  # WSGI entry point (Gunicorn)
│   └── asgi.py                  # ASGI entry point
│
└── products/                    # Products application
    ├── __init__.py
    ├── apps.py                  # Application configuration
    ├── models.py                # Product database model
    ├── serializers.py           # Serializer & data validation
    ├── views.py                 # ViewSet & endpoint logic
    ├── urls.py                  # Application URL routing
    ├── admin.py                 # Django Admin configuration
    ├── tests.py                 # Unit tests (12 test cases)
    └── migrations/
        ├── __init__.py
        └── 0001_initial.py      # Initial database migration
```

---

## 🚀 Installation & Setup Guide

### Prerequisites

Make sure your system has:
- **Python 3.10** or newer → [python.org](https://www.python.org/downloads/)
- **pip** (usually bundled with Python)
- **Git** (optional, for cloning the repository)

Verify your installation:
```bash
python --version   # Python 3.10.x
pip --version      # pip 23.x
```

---

### Step 1 — Navigate to the Project Directory

```bash
cd openshop
```

---

### Step 2 — Create a Virtual Environment

A virtual environment isolates project dependencies to prevent conflicts with your system packages.

```bash
python -m venv venv
```

---

### Step 3 — Activate the Virtual Environment

**Windows (Command Prompt / PowerShell):**
```bash
venv\Scripts\activate
```

**macOS / Linux:**
```bash
source venv/bin/activate
```

Once activated, your terminal prompt will change to:
```
(venv) $
```

---

### Step 4 — Install Dependencies

```bash
pip install -r requirements.txt
```

Packages that will be installed:
```
Django==4.2.x
djangorestframework==3.14.x
gunicorn==21.2.x
```

---

### Step 5 — Run Database Migrations

This command creates the database schema based on the defined models.

```bash
python manage.py migrate
```

Expected output:
```
Operations to perform:
  Apply all migrations: admin, auth, contenttypes, products, sessions
Running migrations:
  Applying products.0001_initial... OK
  ...
```

---

### Step 6 — (Optional) Create an Admin Superuser

Required to access the Django Admin panel at `/admin/`.

```bash
python manage.py createsuperuser
```

Follow the prompts to set a username, email, and password.

---

### Step 7 — Start the Development Server

```bash
python manage.py runserver
```

The server will be available at:

| URL | Description |
|---|---|
| `http://127.0.0.1:8000/api/products/` | Browsable API (DRF) |
| `http://127.0.0.1:8000/admin/` | Django Admin Panel |

---

## 📋 Data Model: Product

| Field | Type | Description |
|---|---|---|
| `id` | `BigAutoField` | Primary key, auto-generated |
| `name` | `CharField(100)` | Product name (**required**) |
| `description` | `TextField` | Product description (**required**) |
| `price` | `DecimalField(12,2)` | Product price, cannot be negative |
| `stock` | `PositiveIntegerField` | Stock quantity, cannot be negative |
| `category` | `CharField(100)` | Product category (**required**) |
| `created_at` | `DateTimeField` | Creation timestamp (auto-set) |
| `updated_at` | `DateTimeField` | Last update timestamp (auto-set) |

### Validation Rules

- `name` — must not be empty or whitespace-only
- `price` — must not be a negative value
- `stock` — must not be a negative value

---

## 🔌 API Endpoint Documentation

**Base URL:** `http://127.0.0.1:8000`

### Endpoint Overview

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/api/products/` | Retrieve all products |
| `POST` | `/api/products/` | Create a new product |
| `GET` | `/api/products/{id}/` | Retrieve a single product |
| `PUT` | `/api/products/{id}/` | Fully update a product |
| `PATCH` | `/api/products/{id}/` | Partially update a product |
| `DELETE` | `/api/products/{id}/` | Delete a product |
| `GET` | `/api/products/?search={keyword}` | Search products |

---

### `GET /api/products/` — Retrieve All Products

Returns a list of all products ordered from newest to oldest.

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
    "name": "ASUS ROG Gaming Laptop",
    "description": "High-performance gaming laptop with RTX 4060 GPU.",
    "price": "18500000.00",
    "stock": 5,
    "category": "Electronics",
    "created_at": "2026-05-21T10:00:00.000000Z",
    "updated_at": "2026-05-21T10:00:00.000000Z"
  },
  {
    "id": 2,
    "name": "RGB Mechanical Keyboard",
    "description": "Gaming keyboard with blue switches and RGB backlight.",
    "price": "850000.00",
    "stock": 20,
    "category": "Accessories",
    "created_at": "2026-05-21T09:00:00.000000Z",
    "updated_at": "2026-05-21T09:00:00.000000Z"
  }
]
```

---

### `POST /api/products/` — Create a New Product

Saves a new product into the database.

**Request:**
```http
POST /api/products/ HTTP/1.1
Host: 127.0.0.1:8000
Content-Type: application/json

{
  "name": "Logitech Wireless Mouse",
  "description": "Ergonomic wireless mouse with adjustable DPI.",
  "price": "450000.00",
  "stock": 30,
  "category": "Accessories"
}
```

**Response `201 Created`:**
```json
{
  "id": 3,
  "name": "Logitech Wireless Mouse",
  "description": "Ergonomic wireless mouse with adjustable DPI.",
  "price": "450000.00",
  "stock": 30,
  "category": "Accessories",
  "created_at": "2026-05-21T11:30:00.000000Z",
  "updated_at": "2026-05-21T11:30:00.000000Z"
}
```

**Response `400 Bad Request` (validation failed):**
```json
{
  "price": ["Price cannot be negative."]
}
```

---

### `GET /api/products/{id}/` — Retrieve a Single Product

Returns the details of one product by its ID.

**Request:**
```http
GET /api/products/3/ HTTP/1.1
Host: 127.0.0.1:8000
```

**Response `200 OK`:**
```json
{
  "id": 3,
  "name": "Logitech Wireless Mouse",
  "description": "Ergonomic wireless mouse with adjustable DPI.",
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

### `PUT /api/products/{id}/` — Fully Update a Product

Replaces all fields of the specified product. All fields are required.

**Request:**
```http
PUT /api/products/3/ HTTP/1.1
Host: 127.0.0.1:8000
Content-Type: application/json

{
  "name": "Logitech MX Master 3 Wireless Mouse",
  "description": "Premium wireless mouse with high-precision sensor for professionals.",
  "price": "1200000.00",
  "stock": 15,
  "category": "Accessories"
}
```

**Response `200 OK`:**
```json
{
  "id": 3,
  "name": "Logitech MX Master 3 Wireless Mouse",
  "description": "Premium wireless mouse with high-precision sensor for professionals.",
  "price": "1200000.00",
  "stock": 15,
  "category": "Accessories",
  "created_at": "2026-05-21T11:30:00.000000Z",
  "updated_at": "2026-05-21T14:00:00.000000Z"
}
```

---

### `PATCH /api/products/{id}/` — Partially Update a Product

Updates only the fields provided in the request body. All other fields remain unchanged.

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
  "name": "Logitech MX Master 3 Wireless Mouse",
  "description": "Premium wireless mouse with high-precision sensor for professionals.",
  "price": "1100000.00",
  "stock": 25,
  "category": "Accessories",
  "created_at": "2026-05-21T11:30:00.000000Z",
  "updated_at": "2026-05-21T15:00:00.000000Z"
}
```

---

### `DELETE /api/products/{id}/` — Delete a Product

Permanently removes a product from the database.

**Request:**
```http
DELETE /api/products/3/ HTTP/1.1
Host: 127.0.0.1:8000
```

**Response `204 No Content`:**
```
(empty body)
```

---

### `GET /api/products/?search={keyword}` — Search Products

Searches products by keyword across the `name`, `category`, and `description` fields. The search is **case-insensitive**.

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
    "name": "Logitech MX Master 3 Wireless Mouse",
    "description": "Premium wireless mouse with high-precision sensor for professionals.",
    "price": "1100000.00",
    "stock": 25,
    "category": "Accessories",
    "created_at": "2026-05-21T11:30:00.000000Z",
    "updated_at": "2026-05-21T15:00:00.000000Z"
  }
]
```

**Response `200 OK` (no results):**
```json
[]
```

> **Tip:** Search also works against categories.
> Example: `GET /api/products/?search=Electronics`

---

## 🧪 Running Unit Tests

This project includes **12 unit tests** covering all API functionality.

```bash
python manage.py test products --verbosity=2
```

### Test Cases

| Test Class | Test Case | Description |
|---|---|---|
| `ProductCreateTest` | `test_create_product_success` | Product is successfully created |
| `ProductCreateTest` | `test_create_product_negative_price_fails` | Negative price is rejected |
| `ProductCreateTest` | `test_create_product_empty_name_fails` | Empty name is rejected |
| `ProductListTest` | `test_get_product_list` | Product list is retrieved successfully |
| `ProductDetailTest` | `test_get_product_detail` | Single product detail is retrieved |
| `ProductDetailTest` | `test_get_nonexistent_product_returns_404` | Non-existent product returns 404 |
| `ProductUpdateTest` | `test_full_update_product` | PUT successfully updates all fields |
| `ProductUpdateTest` | `test_partial_update_product` | PATCH successfully updates partial fields |
| `ProductDeleteTest` | `test_delete_product` | Product is successfully deleted |
| `ProductSearchTest` | `test_search_by_name` | Search by name returns correct results |
| `ProductSearchTest` | `test_search_by_category` | Search by category returns correct results |
| `ProductSearchTest` | `test_search_no_results` | Search with no match returns empty list |

**Expected terminal output:**
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

## 🌐 Testing with Postman

Postman is the recommended tool for manually testing and exploring the API endpoints.

### Postman Setup

1. Download and install [Postman](https://www.postman.com/downloads/)
2. Create a new **Collection** named `OpenShop API`
3. Add an **Environment** variable: `base_url` = `http://127.0.0.1:8000`

### Request Reference

| Action | Method | URL |
|---|---|---|
| List all products | `GET` | `{{base_url}}/api/products/` |
| Create a product | `POST` | `{{base_url}}/api/products/` |
| Get product detail | `GET` | `{{base_url}}/api/products/1/` |
| Full update | `PUT` | `{{base_url}}/api/products/1/` |
| Partial update | `PATCH` | `{{base_url}}/api/products/1/` |
| Delete a product | `DELETE` | `{{base_url}}/api/products/1/` |
| Search products | `GET` | `{{base_url}}/api/products/?search=laptop` |

> For `POST`, `PUT`, and `PATCH` requests — set the header `Content-Type: application/json` and provide the payload under **Body → raw → JSON**.

---

## 🖥️ Browsable API (Django REST Framework)

Django REST Framework ships with an interactive web UI to explore the API directly in your browser — no Postman required.

Open: **http://127.0.0.1:8000/api/products/**

Available features:
- View all available endpoints
- Perform `GET`, `POST`, `PUT`, `PATCH`, `DELETE` requests directly from the browser
- View nicely formatted JSON responses

---

## ⚙️ Django Admin Panel

The Django Admin panel provides a visual interface to manage product data.

**URL:** `http://127.0.0.1:8000/admin/`

Configured admin features:
- **List Display:** Name, Category, Price, Stock, Created At
- **Search:** Search by name, category, or description
- **Filters:** Filter by category and creation date
- **Ordering:** Sorted by newest product first

---

## 🚢 Deployment with Gunicorn

Gunicorn is a production-grade WSGI HTTP server for running Django applications.

### Deployment Steps

**1. Update `settings.py` for production:**

```python
DEBUG = False
ALLOWED_HOSTS = ['your-domain.com', 'your-server-ip']
SECRET_KEY = 'your-strong-production-secret-key'
```

**2. Collect static files:**

```bash
python manage.py collectstatic
```

**3. Start Gunicorn:**

```bash
gunicorn openshop.wsgi --bind 0.0.0.0:8000
```

**4. Run with multiple workers (recommended for production):**

```bash
gunicorn openshop.wsgi --bind 0.0.0.0:8000 --workers 3 --daemon
```

| Flag | Description |
|---|---|
| `--bind 0.0.0.0:8000` | Listen on all network interfaces at port 8000 |
| `--workers 3` | Spawn 3 worker processes |
| `--daemon` | Run Gunicorn in the background |

---

## 📚 Quick Command Reference

All commands from initial setup to a running server in one place:

```bash
# 1. Navigate to the project directory
cd openshop

# 2. Create a virtual environment
python -m venv venv

# 3. Activate the virtual environment (Windows)
venv\Scripts\activate

# 4. Install all dependencies
pip install -r requirements.txt

# 5. Run database migrations
python manage.py migrate

# 6. (Optional) Create an admin superuser
python manage.py createsuperuser

# 7. Start the development server
python manage.py runserver

# 8. Run all unit tests
python manage.py test products --verbosity=2

# 9. (Production) Start with Gunicorn
gunicorn openshop.wsgi --bind 0.0.0.0:8000
```

---

## ✅ Dicoding Submission Checklist

- [x] RESTful API can save product data → `POST /api/products/`
- [x] RESTful API can display product data → `GET /api/products/` & `GET /api/products/{id}/`
- [x] RESTful API can update product data → `PUT /api/products/{id}/` & `PATCH /api/products/{id}/`
- [x] RESTful API can delete product data → `DELETE /api/products/{id}/`
- [x] RESTful API can search product data → `GET /api/products/?search={keyword}`

---

## 📄 License

This project was built for **educational purposes** as a final submission for the **Belajar Back-End Pemula dengan Python** course at [Dicoding Indonesia](https://www.dicoding.com).

---

<div align="center">

Built with ❤️ using Python & Django REST Framework

**[Dicoding Indonesia](https://www.dicoding.com) — Belajar Back-End Pemula dengan Python**

</div>
