import uuid
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = []

    operations = [
        migrations.CreateModel(
            name='Product',
            fields=[
                ('id', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=255)),
                ('sku', models.CharField(max_length=100)),
                ('description', models.TextField()),
                ('shop', models.CharField(max_length=255)),
                ('location', models.CharField(max_length=255)),
                ('price', models.IntegerField()),
                ('discount', models.IntegerField(default=0)),
                ('category', models.CharField(max_length=100)),
                ('stock', models.IntegerField()),
                ('is_available', models.BooleanField(default=True)),
                ('is_delete', models.BooleanField(default=False)),
                ('picture', models.CharField(max_length=500)),
            ],
            options={
                'ordering': ['-id'],
            },
        ),
    ]
