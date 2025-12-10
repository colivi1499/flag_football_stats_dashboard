import psycopg2
from psycopg2.extras import RealDictCursor
from flask import g
import os

DB_URI = os.environ.get("DATABASE_URL")

from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

def get_db():
    if "db" not in g:
        g.db = psycopg2.connect(DB_URI, cursor_factory=RealDictCursor)
    return g.db

def query_db(query, args=(), one=False):
    db = get_db()
    cur = db.cursor()
    cur.execute(query, args)
    if query.strip().upper().startswith("SELECT"):
        rv = cur.fetchall()
    else:
        db.commit()
        rv = None
    cur.close()
    if one and rv:
        return rv[0]
    return rv

def close_db(e=None):
    db = g.pop("db", None)
    if db is not None:
        db.close()

def init_db(app):
    app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://username:password@host:port/dbname'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    db.init_app(app)