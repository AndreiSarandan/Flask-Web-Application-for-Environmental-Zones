import pytest
import sys
import os

# Ensure the root directory is in the Python path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from website import create_app, db

@pytest.fixture(scope='module')
def app():
    os.environ['FLASK_ENV'] = 'test_env'

    app = create_app('test_env')
    yield app
