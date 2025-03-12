import pytest
from website.models import User
from website import db
from werkzeug.security import generate_password_hash

def login_user(client, email, password):
    # Adjust the URL and form field names to match your login endpoint
    return client.post('/login', data=dict(
        email=email,
        password=password
    ), follow_redirects=True)

def test_login_user(app):
    # Create a test client from the Flask app fixture
    client = app.test_client()

    # Define test user credentials
    test_email = "testuser@example.com"
    test_password = "Testpas123"

    # Hash the test password
    hashed_password = generate_password_hash(test_password, method='sha256')

    # Ensure the test user exists in the test database
    with app.app_context():
        user = User.query.filter_by(email=test_email).first()
        if not user:
            user = User(email=test_email, password=hashed_password)
            db.session.add(user)
            db.session.commit()

    # Attempt to log in with the test user credentials
    response = login_user(client, test_email, test_password)
    
    # Print output for debugging purposes
    print("Login response:", response.data.decode('utf-8'))
    
    # Check for an element in the response that indicates successful login.
    # This might be a "Logout" link, a welcome message, or any other text your app renders upon successful login.
    assert b"Logout" in response.data or b"My Profile" in response.data, "Login failed. Check login process and credentials."
