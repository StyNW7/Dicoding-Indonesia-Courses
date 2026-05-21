from django.contrib import admin
from .models import Product


@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ['name', 'shop', 'category', 'price', 'stock', 'is_available', 'is_delete']
    search_fields = ['name', 'sku', 'category', 'shop', 'location']
    list_filter = ['category', 'is_available', 'is_delete']
    ordering = ['name']
