
from website import create_app
from flask_migrate import Migrate
import json

app = create_app()

# with open('secrets.json') as f:
#     secrets = json.load(f)
    
# print(secrets)

if __name__ == '__main__':
    app.run(debug='True')