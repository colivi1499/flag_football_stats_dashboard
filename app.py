import sqlite3
from flask import Flask, request, jsonify, render_template
from database import get_db, close_db

app = Flask(__name__)

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/players_page")
def players_page():
    return render_template("players.html")


@app.route("/player_stats_page")
def player_stats_page():
    return render_template("player_stats.html")

@app.route("/teams_page")
def teams_page():
    return render_template("teams.html")

@app.route("/games_page")
def games_page():
    return render_template("games.html")

# -------- TEAM ENDPOINTS -------- #

@app.route("/teams", methods=["POST"])
def create_team():
    data = request.json
    name = data.get("name")

    conn = get_db()
    cur = conn.cursor()
    cur.execute("INSERT INTO teams (name) VALUES (?)", (name,))
    conn.commit()

    return jsonify({"id": cur.lastrowid, "name": name}), 201

@app.route("/teams/<int:team_id>", methods=["DELETE"])
def delete_team(team_id):
    conn = get_db()
    cur = conn.cursor()

    existing = cur.execute("SELECT id FROM teams WHERE id = ?", (team_id,)).fetchone()
    if not existing:
        return jsonify({"error": "Team not found"}), 404

    cur.execute("DELETE FROM teams WHERE id = ?", (team_id,))
    conn.commit()
    return jsonify({"status": "deleted", "id": team_id})


@app.route("/teams", methods=["GET"])
def list_teams():
    conn = get_db()
    teams = conn.execute("SELECT * FROM teams").fetchall()
    return jsonify([dict(t) for t in teams])


# -------- PLAYER ENDPOINTS -------- #

@app.route("/players", methods=["GET"])
def list_players():
    conn = get_db()
    players = conn.execute("""
        SELECT players.*, teams.name AS team_name
        FROM players
        JOIN teams ON teams.id = players.team_id
    """).fetchall()
    return jsonify([dict(p) for p in players])

@app.route("/players", methods=["POST"])
def create_player():
    data = request.json
    name = data.get("name")
    team_id = data.get("team_id")

    conn = get_db()
    cur = conn.cursor()
    try:
        cur.execute("INSERT INTO players (name, team_id) VALUES (?, ?)", (name, team_id))
    except sqlite3.IntegrityError as e:
        return jsonify({"error": str(e)}), 400
    conn.commit()

    return jsonify({"id": cur.lastrowid, "name": name, "team_id": team_id}), 201

@app.route("/players/<int:player_id>", methods=["GET"])
def get_player(player_id):
    conn = get_db()
    player = conn.execute("SELECT * FROM players WHERE id = ?", (player_id,)).fetchone()
    if player:
        return jsonify(dict(player))
    return jsonify({"error": "Player not found"}), 404


@app.route("/players/<int:player_id>", methods=["DELETE"])
def delete_player(player_id):
    conn = get_db()
    cur = conn.cursor()

    cur.execute("DELETE FROM player_stats WHERE player_id = ?", (player_id,))
    cur.execute("DELETE FROM players WHERE id = ?", (player_id,))
    conn.commit()

    return jsonify({"status": "deleted", "player_id": player_id})

# -------- PLAYER_STATS ENDPOINTS -------- #
@app.route("/stats", methods=["POST"])
def update_stats():
    data = request.json

    player_id = data.get("player_id")
    game_id = data.get("game_id")

    touchdowns = data.get("touchdowns", 0)
    receptions = data.get("receptions", 0)
    yards = data.get("yards", 0)
    interceptions = data.get("interceptions", 0)
    sacks = data.get("sacks", 0)
    flags_pulled = data.get("flags_pulled", 0)

    conn = get_db()
    cur = conn.cursor()

    existing = cur.execute("""
        SELECT id FROM player_stats
        WHERE player_id = ? AND game_id = ?
    """, (player_id, game_id)).fetchone()

    if existing:
        cur.execute("""
            UPDATE player_stats
            SET touchdowns = ?,
                receptions = ?,
                yards = ?,
                interceptions = ?,
                sacks = ?,
                flags_pulled = ?
            WHERE player_id = ? AND game_id = ?
        """, (
            touchdowns, receptions, yards,
            interceptions, sacks, flags_pulled,
            player_id, game_id
        ))
    else:
        try:
            cur.execute("""
                INSERT INTO player_stats (
                    game_id, player_id, touchdowns, receptions, yards,
                    interceptions, sacks, flags_pulled
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                game_id, player_id,
                touchdowns, receptions, yards,
                interceptions, sacks, flags_pulled
            ))
        except sqlite3.IntegrityError as e:
            return jsonify({"error": str(e)}), 400

    conn.commit()
    return jsonify({"status": "ok"}), 200


@app.route("/players/<int:player_id>/stats", methods=["GET"])
def get_player_stats(player_id):
    conn = get_db()

    stats = conn.execute("""
        SELECT 
            ps.id,
            ps.game_id,
            g.date AS game_date,
            g.result AS result,
            home.name AS home_team,
            away.name AS away_team,
            ps.touchdowns,
            ps.receptions,
            ps.yards,
            ps.interceptions,
            ps.sacks,
            ps.flags_pulled
        FROM player_stats ps
        JOIN games g ON g.id = ps.game_id
        JOIN teams home ON home.id = g.home_team_id
        JOIN teams away ON away.id = g.away_team_id
        WHERE ps.player_id = ?
        ORDER BY g.date
    """, (player_id,)).fetchall()

    return jsonify([dict(s) for s in stats])


@app.route("/games/<int:game_id>/stats", methods=["GET"])
def get_game_stats(game_id):
    conn = get_db()

    stats = conn.execute("""
        SELECT
            ps.id,
            ps.player_id,
            p.name AS player_name,
            ps.touchdowns,
            ps.receptions,
            ps.yards,
            ps.interceptions,
            ps.sacks,
            ps.flags_pulled
        FROM player_stats ps
        JOIN players p ON p.id = ps.player_id
        WHERE ps.game_id = ?
    """, (game_id,)).fetchall()

    return jsonify([dict(s) for s in stats])

# --------- GAMES ENDPOINTS --------- #
@app.route("/games", methods=["POST"])
def create_game():
    data = request.json
    date = data.get("date")
    home_team_id = data.get("home_team_id")
    away_team_id = data.get("away_team_id")
    result = data.get("result")  # Optional

    if not date or not home_team_id or not away_team_id:
        return jsonify({"error": "date, home_team_id, and away_team_id are required"}), 400

    conn = get_db()
    cur = conn.cursor()

    try:
        cur.execute("""
            INSERT INTO games (date, home_team_id, away_team_id, result)
            VALUES (?, ?, ?, ?)
        """, (date, home_team_id, away_team_id, result))
        conn.commit()
        return jsonify({
            "id": cur.lastrowid,
            "date": date,
            "home_team_id": home_team_id,
            "away_team_id": away_team_id,
            "result": result
        }), 201
    except sqlite3.IntegrityError as e:
        return jsonify({"error": str(e)}), 400
    
@app.route("/games", methods=["GET"])
def list_games():
    conn = get_db()
    games = conn.execute("""
        SELECT 
            g.id,
            g.date,
            g.result,
            home.name AS home_team,
            away.name AS away_team
        FROM games g
        JOIN teams home ON home.id = g.home_team_id
        JOIN teams away ON away.id = g.away_team_id
        ORDER BY g.date
    """).fetchall()

    # Convert SQLite rows to dictionaries
    return jsonify([dict(game) for game in games])

    
@app.route("/games/<int:game_id>", methods=["DELETE"])
def delete_game(game_id):
    conn = get_db()
    cur = conn.cursor()

    # Check if game exists
    existing = cur.execute("SELECT id FROM games WHERE id = ?", (game_id,)).fetchone()
    if not existing:
        return jsonify({"error": "Game not found"}), 404

    # Delete game — player_stats referencing this game will also be deleted if ON DELETE CASCADE is enabled
    cur.execute("DELETE FROM games WHERE id = ?", (game_id,))
    conn.commit()

    return jsonify({"status": "deleted", "id": game_id}), 200



@app.teardown_appcontext
def teardown_db(exception):
    close_db()


if __name__ == "__main__":
    app.run(debug=True)
