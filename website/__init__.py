from flask import Flask, current_app, g, jsonify
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import inspect, text
from os import path
from flask_login import LoginManager
import sqlite3
from flask_migrate import Migrate
import os
from dotenv import load_dotenv
from config import TestingConfig, ProductionConfig
from prometheus_flask_exporter import PrometheusMetrics


metrics = PrometheusMetrics.for_app_factory()

db = SQLAlchemy()


def create_app(config_name="None"):
    load_dotenv()

    app = Flask(__name__)

    env = os.getenv('FLASK_ENV', 'production').lower()
    if env == 'testing':
        app.config.from_object(TestingConfig)
    else:
        app.config.from_object(ProductionConfig)

    db.init_app(app)
    metrics.init_app(app)

    from .middleware import monitor_requests

    #register blueprints
    from .views import views
    app.register_blueprint(views, url_prefix='/')
    from .auth import auth
    app.register_blueprint(auth, url_prefix='/')

    #setup login manager
    from .models import User
    login_manager = LoginManager()
    login_manager.login_view = 'auth.login'
    login_manager.init_app(app)

    # Load user
    @login_manager.user_loader
    def load_user(id):
        return User.query.get(int(id))

    return app


def create_database(app):
    try:
        # Check if the database exists in MySQL
        with app.app_context():
            engine = db.engine
            if not engine.dialect.has_database(engine.connect(), 'flaskdb'):  # Check if database exists
                print('Database does not exist, creating database...')
                with engine.connect() as conn:
                    conn.execute('CREATE DATABASE flaskdb')
                print('Database created successfully!')
    except Exception as e:
        print(f"Error creating database: {e}")



# if __name__ == "__main__":
#     create_app().run(debug=True)
