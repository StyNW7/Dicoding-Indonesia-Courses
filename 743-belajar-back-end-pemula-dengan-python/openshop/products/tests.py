"""
Unit tests for the products app.
Tests cover all CRUD operations and search functionality.
"""

from decimal import Decimal
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from .models import Product


def create_product(**kwargs):
    """Helper to create a product with default values."""
    defaults = {
        'name': 'Test Product',
        'description': 'A test product description.',
        'price': Decimal('99000.00'),
        'stock': 10,
        'category': 'Electronics',
    }
    defaults.update(kwargs)
    return Product.objects.create(**defaults)


class ProductCreateTest(APITestCase):
    """Tests for creating a new product (POST /api/products/)."""

    def test_create_product_success(self):
        url = reverse('product-list')
        data = {
            'name': 'Laptop',
            'description': 'A powerful laptop.',
            'price': '15000000.00',
            'stock': 5,
            'category': 'Electronics',
        }
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(Product.objects.count(), 1)
        self.assertEqual(response.data['name'], 'Laptop')

    def test_create_product_negative_price_fails(self):
        url = reverse('product-list')
        data = {
            'name': 'Bad Product',
            'description': 'Invalid price.',
            'price': '-1000.00',
            'stock': 5,
            'category': 'Test',
        }
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_create_product_empty_name_fails(self):
        url = reverse('product-list')
        data = {
            'name': '   ',
            'description': 'Empty name.',
            'price': '5000.00',
            'stock': 1,
            'category': 'Test',
        }
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)


class ProductListTest(APITestCase):
    """Tests for listing all products (GET /api/products/)."""

    def setUp(self):
        create_product(name='Product A')
        create_product(name='Product B')

    def test_get_product_list(self):
        url = reverse('product-list')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)


class ProductDetailTest(APITestCase):
    """Tests for retrieving a single product (GET /api/products/<id>/)."""

    def setUp(self):
        self.product = create_product(name='Detail Product')

    def test_get_product_detail(self):
        url = reverse('product-detail', args=[self.product.id])
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['name'], 'Detail Product')

    def test_get_nonexistent_product_returns_404(self):
        url = reverse('product-detail', args=[9999])
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)


class ProductUpdateTest(APITestCase):
    """Tests for updating a product (PUT/PATCH /api/products/<id>/)."""

    def setUp(self):
        self.product = create_product(name='Old Name', price=Decimal('10000.00'))

    def test_full_update_product(self):
        url = reverse('product-detail', args=[self.product.id])
        data = {
            'name': 'New Name',
            'description': 'Updated description.',
            'price': '20000.00',
            'stock': 20,
            'category': 'Updated Category',
        }
        response = self.client.put(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['name'], 'New Name')
        self.assertEqual(response.data['price'], '20000.00')

    def test_partial_update_product(self):
        url = reverse('product-detail', args=[self.product.id])
        data = {'price': '99999.00'}
        response = self.client.patch(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['price'], '99999.00')
        # Name should remain unchanged
        self.assertEqual(response.data['name'], 'Old Name')


class ProductDeleteTest(APITestCase):
    """Tests for deleting a product (DELETE /api/products/<id>/)."""

    def setUp(self):
        self.product = create_product()

    def test_delete_product(self):
        url = reverse('product-detail', args=[self.product.id])
        response = self.client.delete(url)
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertEqual(Product.objects.count(), 0)


class ProductSearchTest(APITestCase):
    """Tests for searching products (GET /api/products/?search=keyword)."""

    def setUp(self):
        create_product(name='Keyboard Mechanical', category='Computer')
        create_product(name='Mouse Wireless', category='Computer')
        create_product(name='Running Shoes', category='Sports')

    def test_search_by_name(self):
        url = reverse('product-list') + '?search=Keyboard'
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)
        self.assertEqual(response.data[0]['name'], 'Keyboard Mechanical')

    def test_search_by_category(self):
        url = reverse('product-list') + '?search=Computer'
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

    def test_search_no_results(self):
        url = reverse('product-list') + '?search=xyz_not_exist'
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)
