from flask import Flask, current_app, g
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text
from os import path
from flask_login import LoginManager
import sqlite3
from flask_migrate import Migrate
import os

db = SQLAlchemy()


def create_app():
    app = Flask(__name__)
    # app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://root:andrei@localhost:3306/flaskdb'
    # app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://root:andrei@mysql-db:3306/flaskdb'
    # app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://root:andrei@127.0.0.1:3306/flaskdb'
    # app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://root:andrei@mysql-service:3306/flaskdb'
    app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://root:andrei@db:3306/flaskdb'

    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False  # Optional

    # Set the SECRET_KEY for session management
    app.config['SECRET_KEY'] = os.urandom(24)  # This generates a random key
    db.init_app(app)

    from .middleware import monitor_requests

    # Register Middleware
    @app.before_request
    def monitor_requests_wrapper():
        return monitor_requests()

    #register blueprints
    from .views import views
    app.register_blueprint(views, url_prefix='/')
    from .auth import auth
    app.register_blueprint(auth, url_prefix='/')

    with app.app_context():
        db.create_all()

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



if __name__ == "__main__":
    create_app().run(debug=True)
