-- --------------------------------------------------
-- ENABLE RLS ON ALL TABLES
-- --------------------------------------------------
ALTER TABLE leagues ENABLE ROW LEVEL SECURITY;
ALTER TABLE league_managers ENABLE ROW LEVEL SECURITY;
ALTER TABLE teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE players ENABLE ROW LEVEL SECURITY;
ALTER TABLE games ENABLE ROW LEVEL SECURITY;
ALTER TABLE player_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE combine_results ENABLE ROW LEVEL SECURITY;

-- --------------------------------------------------
-- 1️⃣ Public read access for everyone
-- --------------------------------------------------
CREATE POLICY "Public Read on leagues"
ON leagues
FOR SELECT
TO public
USING (true);

CREATE POLICY "Public Read on league_managers"
ON league_managers
FOR SELECT
TO public
USING (true);

CREATE POLICY "Public Read on teams"
ON teams
FOR SELECT
TO public
USING (true);

CREATE POLICY "Public Read on players"
ON players
FOR SELECT
TO public
USING (true);

CREATE POLICY "Public Read on games"
ON games
FOR SELECT
TO public
USING (true);

CREATE POLICY "Public Read on player_stats"
ON player_stats
FOR SELECT
TO public
USING (true);

CREATE POLICY "Public Read on combine_results"
ON combine_results
FOR SELECT
TO public
USING (true);

-- --------------------------------------------------
-- 2️⃣ League owners can modify their league
-- --------------------------------------------------
CREATE POLICY "League owners can update league"
ON leagues
FOR UPDATE
TO authenticated
USING (auth.uid() = created_by);

CREATE POLICY "League owners can delete league"
ON leagues
FOR DELETE
TO authenticated
USING (auth.uid() = created_by);

-- --------------------------------------------------
-- 3️⃣ Managers can insert/update/delete league data
-- --------------------------------------------------
-- Teams
CREATE POLICY "Managers can insert teams"
ON teams
FOR INSERT
TO authenticated
WITH CHECK (
  league_id IN (SELECT league_id FROM league_managers WHERE user_id = auth.uid())
);

CREATE POLICY "Managers can update teams"
ON teams
FOR UPDATE
TO authenticated
USING (
  league_id IN (SELECT league_id FROM league_managers WHERE user_id = auth.uid())
);

CREATE POLICY "Managers can delete teams"
ON teams
FOR DELETE
TO authenticated
USING (
  league_id IN (SELECT league_id FROM league_managers WHERE user_id = auth.uid())
);

-- Players
CREATE POLICY "Managers can insert players"
ON players
FOR INSERT
TO authenticated
WITH CHECK (
  league_id IN (SELECT league_id FROM league_managers WHERE user_id = auth.uid())
);

CREATE POLICY "Managers can update players"
ON players
FOR UPDATE
TO authenticated
USING (
  league_id IN (SELECT league_id FROM league_managers WHERE user_id = auth.uid())
);

CREATE POLICY "Managers can delete players"
ON players
FOR DELETE
TO authenticated
USING (
  league_id IN (SELECT league_id FROM league_managers WHERE user_id = auth.uid())
);

-- Games
CREATE POLICY "Managers can insert games"
ON games
FOR INSERT
TO authenticated
WITH CHECK (
  league_id IN (SELECT league_id FROM league_managers WHERE user_id = auth.uid())
);

CREATE POLICY "Managers can update games"
ON games
FOR UPDATE
TO authenticated
USING (
  league_id IN (SELECT league_id FROM league_managers WHERE user_id = auth.uid())
);

CREATE POLICY "Managers can delete games"
ON games
FOR DELETE
TO authenticated
USING (
  league_id IN (SELECT league_id FROM league_managers WHERE user_id = auth.uid())
);

-- Player Stats
CREATE POLICY "Managers can insert player_stats"
ON player_stats
FOR INSERT
TO authenticated
WITH CHECK (
  league_id IN (SELECT league_id FROM league_managers WHERE user_id = auth.uid())
);

CREATE POLICY "Managers can update player_stats"
ON player_stats
FOR UPDATE
TO authenticated
USING (
  league_id IN (SELECT league_id FROM league_managers WHERE user_id = auth.uid())
);

CREATE POLICY "Managers can delete player_stats"
ON player_stats
FOR DELETE
TO authenticated
USING (
  league_id IN (SELECT league_id FROM league_managers WHERE user_id = auth.uid())
);

-- Combine Results
CREATE POLICY "Managers can insert combine_results"
ON combine_results
FOR INSERT
TO authenticated
WITH CHECK (
  league_id IN (SELECT league_id FROM league_managers WHERE user_id = auth.uid())
);

CREATE POLICY "Managers can update combine_results"
ON combine_results
FOR UPDATE
TO authenticated
USING (
  league_id IN (SELECT league_id FROM league_managers WHERE user_id = auth.uid())
);

CREATE POLICY "Managers can delete combine_results"
ON combine_results
FOR DELETE
TO authenticated
USING (
  league_id IN (SELECT league_id FROM league_managers WHERE user_id = auth.uid())
);

-- --------------------------------------------------
-- Only league managers can manage managers
-- --------------------------------------------------
CREATE POLICY "League managers can modify managers"
ON league_managers
FOR ALL
TO authenticated
USING (
  league_id IN (SELECT league_id FROM league_managers WHERE user_id = auth.uid())
)
WITH CHECK (
  league_id IN (SELECT league_id FROM league_managers WHERE user_id = auth.uid())
);
