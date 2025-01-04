from datetime import datetime, timezone, timedelta
from .models import BlockedUser, User, RequestLog
from . import db

def log_request(ip_address, endpoint, user_id):
    """
    Logs a user's request in the RequestLog table.
    """
    request_log = RequestLog(user_id=user_id, ip_address=ip_address, endpoint=endpoint, timestamp=datetime.now(timezone.utc))
    db.session.add(request_log)
    db.session.commit()

def block_ip(ip_address, user_id=None, duration_minutes=5):
    # Blocks an IP address for a specified duration.
        
        
    block_until = datetime.now(timezone.utc) + timedelta(minutes=duration_minutes)
    
    # Block the IP address
    blocked_ip = BlockedUser.query.filter_by(ip_address=ip_address).first()
    if not blocked_ip:
        blocked_ip = BlockedUser(ip_address=ip_address, blocked_until=block_until)
        db.session.add(blocked_ip)
    else:
        blocked_ip.blocked_until = block_until
    
    
    db.session.commit()


def detect_suspicious_behavior(ip_address, threshold=100, time_window=60):
    """
    Checks if an IP has exceeded the request threshold within the given time window.
    """
    time_limit = datetime.now(timezone.utc) - timedelta(seconds=time_window)

    # Count requests made by the IP in the last time window
    request_count = RequestLog.query.filter(
        RequestLog.ip_address == ip_address,
        RequestLog.timestamp > time_limit
    ).count()

    return request_count > threshold
    
