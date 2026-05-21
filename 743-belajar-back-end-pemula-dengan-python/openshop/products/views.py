"""
Views for the products app.
Uses ModelViewSet to provide full CRUD operations and search functionality.
"""

from rest_framework import viewsets, filters
from .models import Product
from .serializers import ProductSerializer


class ProductViewSet(viewsets.ModelViewSet):
    """
    ViewSet for Product model providing:
    - list:   GET  /api/products/
    - create: POST /api/products/
    - retrieve: GET /api/products/<id>/
    - update: PUT /api/products/<id>/
    - partial_update: PATCH /api/products/<id>/
    - destroy: DELETE /api/products/<id>/

    Search by name, category, or description:
    - GET /api/products/?search=keyword
    """

    queryset = Product.objects.all().order_by('-created_at')
    serializer_class = ProductSerializer
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['name', 'category', 'description']
    ordering_fields = ['name', 'price', 'stock', 'created_at']
