# initial_db.py
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text
from os import path
from .models import Zone 

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///your_database.db'  # Update the URI
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

def create_database():
    from .models import Zone
    with app.app_context():
        db.create_all()
        print("Database created!")

        # SQL statements to insert initial data into the Zone table
        sql_statements = """
            INSERT INTO zone (country, city, descriptions, required_pass, minimum_euro) VALUES
            ('France', 'Paris', 'Beautiful city with many green spaces.', 'GreenPass123', '50'),
            ('Germany', 'Berlin', 'Capital city with parks and recreational areas.', 'EcoPass456', '40'),
            ('Italy', 'Rome', 'Historic city with parks and gardens.', 'NaturePass789', '55'),
            ('Spain', 'Madrid', 'Vibrant city with green zones and outdoor activities.', 'MadGreenPass', '45'),
            ('United Kingdom', 'London', 'Large city with various parks and green initiatives.', 'LondonGreen123', '60')
        """

        # Execute the SQL statements
        with db.engine.connect() as connection:
            connection.execute(text(sql_statements))

        print("Initial Zone data added to the database!")

        # Print the content of the Zone table
        print("Content of the Zone table:")
        zones = Zone.query.all()
        for zone in zones:
            print(zone.id, zone.country, zone.city, zone.descriptions, zone.required_pass, zone.minimum_euro)


if __name__ == "__main__":
    create_database()
