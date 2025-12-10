import os
import jwt
from flask import request, abort
from functools import wraps

SUPABASE_JWT_SECRET = os.getenv("SUPABASE_JWT_SECRET")

def require_auth(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        
        auth_header = request.headers.get('Authorization')
        if not auth_header:
            abort(401, "Missing Authorization header")

        try:
            scheme, token = auth_header.split(" ")
            if scheme.lower() != "bearer":
                abort(401)
        except ValueError:
            abort(401)

        try:
            payload = jwt.decode(
                token,
                SUPABASE_JWT_SECRET,
                algorithms=["HS256"]
            )
        except jwt.ExpiredSignatureError:
            abort(401, "Token expired")
        except jwt.InvalidTokenError:
            abort(401, "Invalid token")

        request.user = payload

        return f(*args, **kwargs)
    return wrapper
