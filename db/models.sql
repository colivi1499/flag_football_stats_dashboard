-- Drop in correct order
DROP TABLE IF EXISTS combine_results;
DROP TABLE IF EXISTS player_stats;
DROP TABLE IF EXISTS games;
DROP TABLE IF EXISTS players;
DROP TABLE IF EXISTS teams;
DROP TABLE IF EXISTS league_managers;
DROP TABLE IF EXISTS leagues;

-- Create leagues first
CREATE TABLE leagues (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  created_by uuid DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at timestamptz DEFAULT now()
);

-- Teams belong to a league
CREATE TABLE teams (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    league_id INTEGER NOT NULL REFERENCES leagues(id) ON DELETE CASCADE
);

-- Players
CREATE TABLE players (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    team_id INTEGER NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    position TEXT,
    league_id INTEGER REFERENCES leagues(id) ON DELETE CASCADE
);

-- Games
CREATE TABLE games (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    home_team_id INTEGER NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    away_team_id INTEGER NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    result TEXT,
    league_id INTEGER REFERENCES leagues(id) ON DELETE CASCADE
);

-- Player stats
CREATE TABLE player_stats (
    id SERIAL PRIMARY KEY,
    game_id INTEGER NOT NULL REFERENCES games(id) ON DELETE CASCADE,
    player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    touchdowns INTEGER DEFAULT 0,
    receptions INTEGER DEFAULT 0,
    yards INTEGER DEFAULT 0,
    interceptions INTEGER DEFAULT 0,
    sacks INTEGER DEFAULT 0,
    flags_pulled INTEGER DEFAULT 0,
    league_id INTEGER REFERENCES leagues(id) ON DELETE CASCADE
);

-- Combine results
CREATE TABLE combine_results (
    id SERIAL PRIMARY KEY,
    player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    forty_yard REAL,
    bench_reps INTEGER,
    vertical REAL,
    broad_jump REAL,
    shuttle REAL,
    three_cone REAL,
    league_id INTEGER REFERENCES leagues(id) ON DELETE CASCADE
);

-- League managers
CREATE TABLE league_managers (
  league_id INT NOT NULL REFERENCES leagues(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role TEXT DEFAULT 'manager',
  PRIMARY KEY (league_id, user_id)
);

CREATE OR REPLACE FUNCTION delete_league_if_no_managers()
RETURNS TRIGGER AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM league_managers
    WHERE league_id = OLD.league_id
  ) THEN
    DELETE FROM leagues WHERE id = OLD.league_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_delete_empty_league
AFTER DELETE ON league_managers
FOR EACH ROW
EXECUTE FUNCTION delete_league_if_no_managers();
