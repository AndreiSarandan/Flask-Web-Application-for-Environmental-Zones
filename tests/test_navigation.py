import json
import pytest
from website.models import User, Car, Zone
from website import db
from werkzeug.security import generate_password_hash

def login_user(client, email, password):
    response = client.post('/login', data=dict(
        email=email,
        password=password
    ), follow_redirects=True)
    print("Login response:", response.data.decode('utf-8'))
    return response

def setup_test_data():
    # Add test data for Berlin LEZ
    berlin_lez = Zone(
        country='Germany',
        city='Berlin',
        registration_class='SomeClass',
        minimum_diesel='Euro 1',
        minimum_petrol='Euro 4',
        fines='50 - 200 €',
        registration_type='Sticker',
        registration_validity='Permanent',
        required_registration='Umweltplakette Green - 4',
        exception_country='None',
        description='LEZ in Berlin'
    )
    db.session.add(berlin_lez)

    # Add test data for Paris LEZ
    paris_lez = Zone(
        country='France',
        city='Paris',
        registration_class='SomeClass',
        minimum_diesel='Euro 6',
        minimum_petrol='Euro 4',
        fines='68 - 180 €',
        registration_type='Sticker',
        registration_validity='Permanent',
        required_registration="Crit'Air 3",
        exception_country='None',
        description='LEZ in Paris'
    )
    db.session.add(paris_lez)

    db.session.commit()


def test_navigation_get(client, init_database):
    # Setup test data and login
    hashed_password = generate_password_hash('testpassword', method='sha256')
    user = User(email='test@example.com', password=hashed_password)
    db.session.add(user)
    db.session.commit()

    login_user(client, 'test@example.com', 'testpassword')

    response = client.get('/maps', follow_redirects=True)
    assert response.status_code == 200


def test_add_new_car(client, init_database):
    # Setup test data
    hashed_password = generate_password_hash('testpassword', method='sha256')
    user = User(email='test@example.com', password=hashed_password)
    db.session.add(user)
    db.session.commit()

    login_response = login_user(client, 'test@example.com', 'testpassword')
    assert b'Logout' in login_response.data or b'My Profile' in login_response.data, "User login failed. Check credentials and login process."

    # Prepare POST data for adding a new car
    post_data = {
        'brand': 'Toyota',
        'model': 'Prius',
        'year': '2015',
        'fuel_type': 'Hybrid',
        'euro_standard': 'Euro 6',
        'registration_country': 'UK',
        'has_dpf': 'on',
        'Belgium_registration': '',
        'Bulgaria_registration': '',
        'Denmark_registration': '',
        'France_registration': '',
        'Germany_registration': '',
        'Greece_registration': '',
        'Netherlands_registration': '',
        'Norway_registration': '',
        'Poland_registration': '',
        'Spain_registration': '',
        'United Kingdom_registration': ''
    }
    print("user id:", user.id)

    response = client.post('/new-car', data=post_data, follow_redirects=True)
    assert response.status_code == 200

    # Log the response content for debugging
    response_data = response.data.decode('utf-8')
    print("Response data:", response_data)

    # Check if the car was added
    car = Car.query.filter_by(owner_id=user.id, brand='Toyota', model='Prius').first()
    print("Car:", car)
    assert car is not None, "Car should be added to the database."
    assert car.year == 2015
    assert car.fuel_type == 'Hybrid'
    assert car.euro_standard == 'Euro 6'
    assert car.registration_country == 'UK'
    assert car.dpf is True


def test_navigation_post_valid_with_new_car(client, init_database):
    # Setup test data
    setup_test_data()

    hashed_password = generate_password_hash('testpassword', method='sha256')
    user = User(email='test@example.com', password=hashed_password)
    db.session.add(user)
    db.session.commit()

    login_response = login_user(client, 'test@example.com', 'testpassword')
    assert b'Logout' in login_response.data or b'My Profile' in login_response.data, "User login failed. Check credentials and login process."

    # Add a new car first
    post_data_new_car = {
        'brand': 'Toyota',
        'model': 'Prius',
        'year': '2015',
        'fuel_type': 'Hybrid',
        'euro_standard': 'Euro 6',
        'registration_country': 'UK',
        'has_dpf': 'on',
        'Belgium_registration': '',
        'Bulgaria_registration': '',
        'Denmark_registration': '',
        'France_registration': '',
        'Germany_registration': '4',
        'Greece_registration': '',
        'Netherlands_registration': '',
        'Norway_registration': '',
        'Poland_registration': '',
        'Spain_registration': '',
        'United Kingdom_registration': ''
    }

    client.post('/new-car', data=post_data_new_car, follow_redirects=True)

    # Retrieve the added car
    car = Car.query.filter_by(owner_id=user.id, brand='Toyota', model='Prius').first()
    assert car is not None, "Car should be added to the database."

    # Prepare POST data for the /maps route using the added car
    post_data_maps = {
        'selected-car': car.id,
        'destinations': 'Berlin, Germany,Paris, France',
        'cityCountryData': json.dumps([
            {'country': 'Germany', 'city': 'Berlin'},
            {'country': 'France', 'city': 'Paris'}
        ]),
        'selected-car-registration-date': '2020-01-01'  # Example registration date
    }

    response = client.post('/maps', data=post_data_maps, follow_redirects=True)
    assert response.status_code == 200
    
    # Log the response content for debugging
    try:
        data = response.get_json(silent=True)
        if data is None:
            print("Response content type:", response.content_type)
            print("Response data:", response.data.decode('utf-8'))
        assert data is not None, "Expected JSON data, got None"
    except Exception as e:
        print("Exception occurred:", str(e))
        print("Response data:", response.data)
        raise e

    # Check for expected structure and values for Berlin
    assert 'Berlin' in data
    berlin_data = data['Berlin']
    assert berlin_data['country'] == 'Germany'
    assert berlin_data['notification_type'] == 'success'
    assert berlin_data['notification_msg'] == 'Selected vehicle is allowed to drive in Berlin.'
    assert berlin_data['city_official_page'] ==None
    assert berlin_data['city_required_registration_type'] == 'Sticker'
    assert berlin_data['city_required_registration'].strip() == 'Umweltplakette Green - 4'
    assert berlin_data['city_fines'] == 'Penalties for not complying to the regulations: 50 - 200 \u20ac.'

    # Check for expected structure and values for Paris
    assert 'Paris' in data
    paris_data = data['Paris']
    assert paris_data['country'] == 'France'
    assert paris_data['notification_type'] == 'error'
    assert paris_data['notification_msg'] == 'Selected vehicle is NOT allowed to drive in Paris.'
    assert paris_data['city_official_page'] == None
    assert paris_data['city_required_registration_type'] == 'Sticker'
    assert paris_data['city_required_registration'].strip() == "Crit'Air 3"
    assert paris_data['city_fines'] == 'Penalties for not complying to the regulations: 68 - 180 \u20ac.'
