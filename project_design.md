# Flag Football Stats Dashboard

## Project Purpose and Goals

The purpose of this project is to build a **flag football stats-tracking and dashboard application**. Users will be able to record, store, and view stats for teams, players, games, and player combine results. This project demonstrates **database modeling, CRUD operations, REST APIs, and data visualization**.  

Goals:
- Track teams, players, games, player stats, and combine results.
- Display aggregate statistics for players and teams.
- Build a simple HTML/JavaScript frontend dashboard, with potential React integration later.
- Expandable to analytics, leaderboards, and live game tracking.

---

## Initial Entity-Relationship Diagram (ERD)

```mermaid
erDiagram
    TEAMS ||--o{ PLAYERS : has
    TEAMS ||--o{ GAMES : plays
    PLAYERS ||--o{ PLAYER_STATS : has
    GAMES ||--o{ PLAYER_STATS : includes
    PLAYERS ||--o{ COMBINE_RESULTS : has

    TEAMS {
        INTEGER id PK
        TEXT name
    }

    PLAYERS {
        INTEGER id PK
        TEXT name
        INTEGER team_id FK
        TEXT position
    }

    GAMES {
        INTEGER id PK
        TEXT date
        INTEGER home_team_id FK
        INTEGER away_team_id FK
        TEXT result
    }

    PLAYER_STATS {
        INTEGER id PK
        INTEGER game_id FK
        INTEGER player_id FK
        INTEGER touchdowns
        INTEGER receptions
        INTEGER yards
        INTEGER interceptions
        INTEGER sacks
        INTEGER flags_pulled
    }

    COMBINE_RESULTS {
        INTEGER id PK
        INTEGER player_id FK
        REAL forty_yard
        INTEGER bench_reps
        REAL vertical
        REAL broad_jump
        REAL shuttle
        REAL three_cone
    }
