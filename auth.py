import jwt
from flask import request, abort

def require_auth(f):
    def wrapper(*args, **kwargs):
        auth_header = request.headers.get('Authorization')
        if not auth_header:
            abort(401)
        token = auth_header.split(" ")[1]
        try:
            payload = jwt.decode(token, 'SUPABASE_JWT_SECRET', algorithms=['HS256'])
        except jwt.ExpiredSignatureError:
            abort(401)
        except jwt.InvalidTokenError:
            abort(401)
        return f(*args, **kwargs)
    return wrapper
