"""
WSGI config for openshop project.
Used by Gunicorn for deployment: gunicorn openshop.wsgi
"""

import os
from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'openshop.settings')

application = get_wsgi_application()
