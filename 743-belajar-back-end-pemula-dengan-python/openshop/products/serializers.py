from rest_framework import serializers
from .models import Product


class ProductSerializer(serializers.ModelSerializer):
    _links = serializers.SerializerMethodField()

    class Meta:
        model = Product
        fields = [
            'id', 'name', 'sku', 'description', 'shop', 'location',
            'price', 'discount', 'category', 'stock', 'is_available',
            'is_delete', 'picture', '_links',
        ]
        read_only_fields = ['id', '_links']
        extra_kwargs = {
            'is_delete': {'required': False},
        }

    def get__links(self, obj):
        request = self.context.get('request')
        base = f"{request.scheme}://{request.get_host()}" if request else ""
        return [
            {
                "rel": "self",
                "href": f"{base}/products",
                "action": "POST",
                "types": ["application/json"],
            },
            {
                "rel": "self",
                "href": f"{base}/products/{obj.id}/",
                "action": "GET",
                "types": ["application/json"],
            },
            {
                "rel": "self",
                "href": f"{base}/products/{obj.id}/",
                "action": "PUT",
                "types": ["application/json"],
            },
            {
                "rel": "self",
                "href": f"{base}/products/{obj.id}/",
                "action": "DELETE",
                "types": ["application/json"],
            },
        ]
