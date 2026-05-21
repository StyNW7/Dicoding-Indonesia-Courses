"""
URL routing for the products app.
Uses DefaultRouter to automatically generate RESTful endpoints.
"""

from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import ProductViewSet

# DefaultRouter generates:
#   GET    /api/products/         -> list
#   POST   /api/products/         -> create
#   GET    /api/products/<id>/    -> retrieve
#   PUT    /api/products/<id>/    -> update
#   PATCH  /api/products/<id>/    -> partial_update
#   DELETE /api/products/<id>/    -> destroy
router = DefaultRouter()
router.register(r'products', ProductViewSet, basename='product')

urlpatterns = [
    path('', include(router.urls)),
]
