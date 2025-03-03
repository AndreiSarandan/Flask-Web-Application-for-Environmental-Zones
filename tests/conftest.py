# tests/conftest.py

import pytest
import sys
import os

# Ensure the root directory is in the Python path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from website import create_app, db

@pytest.fixture(scope='module')
def app():
    app = create_app('TestingConfig')
    with app.app_context():
        yield app

@pytest.fixture(scope='module')
def client(app):
    return app.test_client()

@pytest.fixture(scope='function')
def init_database(app):
    with app.app_context():
        db.create_all()
        yield db
        db.session.remove()
        db.drop_all()
