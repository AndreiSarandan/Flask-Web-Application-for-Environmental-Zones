import requests
import time

# Configurations
server_url = "http://127.0.0.1:5000"  
endpoint = "/eligibility-check"  
total_requests = 60  
delay = 0.2  

# Send requests
for i in range(total_requests):
    try:
        response = requests.get(f"{server_url}{endpoint}")
        print(f"Request {i + 1}: {response.status_code} - {response.text[:100]} ...")
        time.sleep(delay)
    except requests.exceptions.RequestException as e:
        print(f"Error on request {i + 1}: {e}")