import os

class Config:
    """
    Base configuration with defaults. Override in subclasses.
    """
    SECRET_KEY = os.getenv('SECRET_KEY', 'fallback-secret-key')
    SQLALCHEMY_TRACK_MODIFICATIONS = False

class TestingConfig(Config):
    """Configuration for testing environment"""
    TESTING = True
    DEBUG = True
    # SQLite in-memory for fast tests
    SQLALCHEMY_DATABASE_URI = 'sqlite:///:memory:'

class ProductionConfig(Config):
    """Configuration for production environment (RDS MySQL)"""
    DEBUG = False
    # Read database credentials from environment variables
    DB_USER = os.getenv('MYSQL_USER')
    DB_PASS = os.getenv('MYSQL_PASS')
    DB_HOST = os.getenv('MYSQL_HOST')
    DB_PORT = os.getenv('MYSQL_PORT', 3306)
    DB_NAME = os.getenv('MYSQL_DB')

    SQLALCHEMY_DATABASE_URI = (
        f"mysql+pymysql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    )