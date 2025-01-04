from flask import request, jsonify
from flask_login import current_user
from .request_monitoring import log_request, detect_suspicious_behavior, block_ip

def monitor_requests():
    ip_address = request.remote_addr  # Get the client's IP address
    endpoint = request.path  # Get the requested endpoint

    print("ip address:", ip_address)
    print("endpoint:", endpoint)


    # Skip logging static files and favicon requests
    if endpoint.startswith('/static') or endpoint == '/favicon.ico':
        return  # Do nothing for static files


    user_id = current_user.id if current_user.is_authenticated else None

    # Log the request
    log_request(ip_address, endpoint, user_id)

    # Check if the IP has exceeded the request threshold
    if detect_suspicious_behavior(ip_address):
        block_ip(ip_address)
        return jsonify({"error": "Your IP has been blocked due to excessive requests."}), 429
