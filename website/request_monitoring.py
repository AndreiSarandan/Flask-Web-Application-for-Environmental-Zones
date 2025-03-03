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

def block_ip(ip_address, user_id=None, ban_duration_minutes=1,treshold_permanent_ban=2):
    # set duration of temporary ban    
    block_until = datetime.now(timezone.utc) + timedelta(minutes=ban_duration_minutes)
    
    # Block the IP address
    blocked_ip = BlockedUser.query.filter_by(ip_address=ip_address).first()
    #if IP is NOT on the blocked list -> add to block list
    if not blocked_ip:
        blocked_ip = BlockedUser(ip_address=ip_address,user_id=user_id ,blocked_until=block_until,total_bans=1)
        db.session.add(blocked_ip)

    #if IP IS ALREADY on the blocked list -> update the list
    else:
        blocked_ip.total_bans=blocked_ip.total_bans+1

        #if treshold for permanent ban is reached -> perma ban (2099)
        if blocked_ip.total_bans>=treshold_permanent_ban:
            blocked_ip.blocked_until=datetime(2099,1,1, tzinfo=timezone.utc)
        else:
            blocked_ip.blocked_until = block_until
    
    
    db.session.commit()


def detect_suspicious_behavior(ip_address, threshold=50, time_window=60):
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
    
