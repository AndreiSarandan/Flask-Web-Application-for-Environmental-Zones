from flask import request, jsonify
from flask_login import current_user
from .request_monitoring import log_request, detect_suspicious_behavior, block_ip
from datetime import datetime, timezone

def monitor_requests():
    ip_address = request.remote_addr  # Get the client's IP address
    endpoint = request.path  # Get the requested endpoint

    print("ip address:", ip_address)
    print("endpoint:", endpoint)


    # Skip logging static files and favicon requests
    if endpoint.startswith('/static') or endpoint == '/favicon.ico':
        return  # Do nothing for static files


    user_id = current_user.id if current_user.is_authenticated else None

    if user_is_blocked(ip_address):
        return jsonify({"error": "Your IP has been blocked due to excessive requests."}), 429

    # Log the request
    log_request(ip_address, endpoint, user_id)

    # Check if the IP has exceeded the request threshold
    if detect_suspicious_behavior(ip_address):
        block_ip(ip_address,user_id)
        return jsonify({"error": "Your IP has been blocked due to excessive requests."}), 429


def user_is_blocked(ip_address):
    from .models import BlockedUser
    blocked_user = BlockedUser.query.filter_by(ip_address=ip_address).first()

    current_time=datetime.now(timezone.utc)
    formatted_current_time = current_time.strftime('%d.%m.%Y %H:%M:%S')
    print("current time:",formatted_current_time)

    if blocked_user:
        blocked_until=blocked_user.blocked_until
        formatted_blocked_user_time = blocked_until.strftime('%d.%m.%Y %H:%M:%S')
        print("current time:",formatted_blocked_user_time)

        if formatted_blocked_user_time > formatted_current_time:
            return True
    
    return False