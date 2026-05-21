"""
Admin configuration for the products app.
"""

from django.contrib import admin
from .models import Product


@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ['name', 'category', 'price', 'stock', 'created_at']
    search_fields = ['name', 'category', 'description']
    list_filter = ['category', 'created_at']
    ordering = ['-created_at']
    readonly_fields = ['created_at', 'updated_at']
