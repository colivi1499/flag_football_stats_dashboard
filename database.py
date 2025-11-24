import sqlite3
from flask import g
import os

DB_PATH = os.path.join(os.path.dirname(__file__), "flagfootball.db")
print(DB_PATH)

# ---- CONNECTION MANAGEMENT ---- #

def get_db():
    """Get a database connection for the current request."""
    if "db" not in g:
        g.db = sqlite3.connect(DB_PATH)
        g.db.row_factory = sqlite3.Row
        g.db.execute("PRAGMA foreign_keys = ON;")
    return g.db

def close_db(e=None):
    """Close the database connection at the end of the request."""
    db = g.pop("db", None)
    if db is not None:
        db.close()

# ---- DATABASE INIT ---- #

def init_db():
    """Initialize the database from models.sql."""
    conn = sqlite3.connect(DB_PATH)
    with open("models.sql", "r") as f:
        conn.executescript(f.read())
    conn.close()
