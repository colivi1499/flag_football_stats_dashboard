DROP TABLE IF EXISTS teams;
DROP TABLE IF EXISTS players;
DROP TABLE IF EXISTS games;
DROP TABLE IF EXISTS player_stats;
DROP TABLE IF EXISTS combine_results;


CREATE TABLE teams (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE players (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    team_id INTEGER NOT NULL,
    position TEXT,
    FOREIGN KEY(team_id) REFERENCES teams(id) ON DELETE CASCADE
);

CREATE TABLE games (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date TEXT NOT NULL,
    home_team_id INTEGER NOT NULL,
    away_team_id INTEGER NOT NULL,
    result TEXT,
    FOREIGN KEY(home_team_id) REFERENCES teams(id) ON DELETE CASCADE,
    FOREIGN KEY(away_team_id) REFERENCES teams(id) ON DELETE CASCADE
);

CREATE TABLE player_stats (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    game_id INTEGER NOT NULL,
    player_id INTEGER NOT NULL,
    touchdowns INTEGER DEFAULT 0,
    receptions INTEGER DEFAULT 0,
    yards INTEGER DEFAULT 0,
    interceptions INTEGER DEFAULT 0,
    sacks INTEGER DEFAULT 0,
    flags_pulled INTEGER DEFAULT 0,
    FOREIGN KEY(game_id) REFERENCES games(id) ON DELETE CASCADE,
    FOREIGN KEY(player_id) REFERENCES players(id) ON DELETE CASCADE
);

CREATE TABLE combine_results (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    player_id INTEGER NOT NULL,
    forty_yard REAL,
    bench_reps INTEGER,
    vertical REAL,
    broad_jump REAL,
    shuttle REAL,
    three_cone REAL,
    FOREIGN KEY(player_id) REFERENCES players(id) ON DELETE CASCADE
);

