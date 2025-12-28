-- supabase-postgres

-- ==================================================
-- FUNCTIONS
-- ==================================================

CREATE OR REPLACE FUNCTION can_manage_league(uid uuid, lid int)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM league_managers
    WHERE user_id = uid
      AND league_id = lid
  );
$$;

-- Auto-add league creator as manager
CREATE OR REPLACE FUNCTION add_creator_as_manager()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  INSERT INTO league_managers (league_id, user_id)
  VALUES (NEW.id, NEW.created_by);
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS add_league_creator_manager ON leagues;

CREATE TRIGGER add_league_creator_manager
AFTER INSERT ON leagues
FOR EACH ROW
EXECUTE FUNCTION add_creator_as_manager();

-- ==================================================
-- ENABLE RLS
-- ==================================================

ALTER TABLE leagues ENABLE ROW LEVEL SECURITY;
ALTER TABLE league_managers ENABLE ROW LEVEL SECURITY;
ALTER TABLE teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE players ENABLE ROW LEVEL SECURITY;
ALTER TABLE games ENABLE ROW LEVEL SECURITY;
ALTER TABLE player_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE combine_results ENABLE ROW LEVEL SECURITY;

-- ==================================================
-- PUBLIC READ POLICIES
-- ==================================================

DROP POLICY IF EXISTS "Public Read on leagues" ON leagues;
CREATE POLICY "Public Read on leagues"
ON leagues FOR SELECT TO public USING (true);

DROP POLICY IF EXISTS "Public Read on league_managers" ON league_managers;
CREATE POLICY "Public Read on league_managers"
ON league_managers FOR SELECT TO public USING (true);

DROP POLICY IF EXISTS "Public Read on teams" ON teams;
CREATE POLICY "Public Read on teams"
ON teams FOR SELECT TO public USING (true);

DROP POLICY IF EXISTS "Public Read on players" ON players;
CREATE POLICY "Public Read on players"
ON players FOR SELECT TO public USING (true);

DROP POLICY IF EXISTS "Public Read on games" ON games;
CREATE POLICY "Public Read on games"
ON games FOR SELECT TO public USING (true);

DROP POLICY IF EXISTS "Public Read on player_stats" ON player_stats;
CREATE POLICY "Public Read on player_stats"
ON player_stats FOR SELECT TO public USING (true);

DROP POLICY IF EXISTS "Public Read on combine_results" ON combine_results;
CREATE POLICY "Public Read on combine_results"
ON combine_results FOR SELECT TO public USING (true);

-- ==================================================
-- LEAGUES
-- ==================================================

DROP POLICY IF EXISTS "Authenticated users can create leagues" ON leagues;
CREATE POLICY "Authenticated users can create leagues"
ON leagues FOR INSERT TO authenticated
WITH CHECK (created_by = auth.uid());

DROP POLICY IF EXISTS "League owners can update league" ON leagues;
CREATE POLICY "League owners can update league"
ON leagues FOR UPDATE TO authenticated
USING (auth.uid() = created_by);

DROP POLICY IF EXISTS "League owners can delete league" ON leagues;
CREATE POLICY "League owners can delete league"
ON leagues FOR DELETE TO authenticated
USING (auth.uid() = created_by);

-- ==================================================
-- LEAGUE MANAGERS
-- ==================================================

DROP POLICY IF EXISTS "Managers can view managers" ON league_managers;
CREATE POLICY "Managers can view managers"
ON league_managers FOR SELECT TO authenticated
USING (can_manage_league(auth.uid(), league_id));

DROP POLICY IF EXISTS "Managers can modify managers" ON league_managers;
CREATE POLICY "Managers can modify managers"
ON league_managers
FOR ALL
TO authenticated
USING (can_manage_league((SELECT auth.uid())::uuid, league_id))
WITH CHECK (can_manage_league((SELECT auth.uid())::uuid, league_id));

-- ==================================================
-- TEAMS
-- ==================================================

DROP POLICY IF EXISTS "Managers can insert teams" ON teams;
CREATE POLICY "Managers can insert teams"
ON teams FOR INSERT TO authenticated
WITH CHECK (can_manage_league(auth.uid(), league_id));

DROP POLICY IF EXISTS "Managers can update teams" ON teams;
CREATE POLICY "Managers can update teams"
ON teams FOR UPDATE TO authenticated
USING (can_manage_league(auth.uid(), league_id));

DROP POLICY IF EXISTS "Managers can delete teams" ON teams;
CREATE POLICY "Managers can delete teams"
ON teams FOR DELETE TO authenticated
USING (can_manage_league(auth.uid(), league_id));

-- ==================================================
-- PLAYERS
-- ==================================================

DROP POLICY IF EXISTS "Managers can insert players" ON players;
CREATE POLICY "Managers can insert players"
ON players FOR INSERT TO authenticated
WITH CHECK (can_manage_league(auth.uid(), league_id));

DROP POLICY IF EXISTS "Managers can update players" ON players;
CREATE POLICY "Managers can update players"
ON players FOR UPDATE TO authenticated
USING (can_manage_league(auth.uid(), league_id));

DROP POLICY IF EXISTS "Managers can delete players" ON players;
CREATE POLICY "Managers can delete players"
ON players FOR DELETE TO authenticated
USING (can_manage_league(auth.uid(), league_id));

-- ==================================================
-- GAMES
-- ==================================================

DROP POLICY IF EXISTS "Managers can insert games" ON games;
CREATE POLICY "Managers can insert games"
ON games FOR INSERT TO authenticated
WITH CHECK (can_manage_league(auth.uid(), league_id));

DROP POLICY IF EXISTS "Managers can update games" ON games;
CREATE POLICY "Managers can update games"
ON games FOR UPDATE TO authenticated
USING (can_manage_league(auth.uid(), league_id));

DROP POLICY IF EXISTS "Managers can delete games" ON games;
CREATE POLICY "Managers can delete games"
ON games FOR DELETE TO authenticated
USING (can_manage_league(auth.uid(), league_id));

-- ==================================================
-- PLAYER STATS
-- ==================================================

DROP POLICY IF EXISTS "Managers can insert player_stats" ON player_stats;
CREATE POLICY "Managers can insert player_stats"
ON player_stats FOR INSERT TO authenticated
WITH CHECK (can_manage_league(auth.uid(), league_id));

DROP POLICY IF EXISTS "Managers can update player_stats" ON player_stats;
CREATE POLICY "Managers can update player_stats"
ON player_stats FOR UPDATE TO authenticated
USING (can_manage_league(auth.uid(), league_id));

DROP POLICY IF EXISTS "Managers can delete player_stats" ON player_stats;
CREATE POLICY "Managers can delete player_stats"
ON player_stats FOR DELETE TO authenticated
USING (can_manage_league(auth.uid(), league_id));

-- ==================================================
-- COMBINE RESULTS
-- ==================================================

DROP POLICY IF EXISTS "Managers can insert combine_results" ON combine_results;
CREATE POLICY "Managers can insert combine_results"
ON combine_results FOR INSERT TO authenticated
WITH CHECK (can_manage_league(auth.uid(), league_id));

DROP POLICY IF EXISTS "Managers can update combine_results" ON combine_results;
CREATE POLICY "Managers can update combine_results"
ON combine_results FOR UPDATE TO authenticated
USING (can_manage_league(auth.uid(), league_id));

DROP POLICY IF EXISTS "Managers can delete combine_results" ON combine_results;
CREATE POLICY "Managers can delete combine_results"
ON combine_results FOR DELETE TO authenticated
USING (can_manage_league(auth.uid(), league_id));
