# Project Overview

## Summary
<!-- One to three sentences describing the project -->
  This project is a web app for tracking flag football stats. When users create an account, they can create their own leagues to manage with the ability to add teams, players, record games and player stats.
  League managers can add other users as collaborators so they can also manage the league.
  
---

## Diagrams, Demo Video, or GIFs
<!-- Include architecture diagrams, ER diagrams, screenshots, or demo videos -->

- Diagram(s):
  - ![Supabase ERD Diagram](./images/supabase-schema.png)

- Demo Video / GIF:

https://github.com/user-attachments/assets/4e1db013-586c-47cc-aea1-e2fbd8a9cf6b


---

## What I Learned
<!-- Describe the main concepts, tools, or skills you learned during this project -->
I think most of what I learned in this project came from using Supabase for the backend. A lot of the work involved designing schemas for each table and crafting Row-Level Security Policies
that fit with the business requirements of the app. There were several times where I found encountered a bug, like a user not being able to insert a player to a team due to an issue in the
RLS policies.
---

## AI Integration
### Does your project integrate with AI in any interesting way?
<!-- If yes, describe how AI is integrated into the project -->
<!-- If no, briefly state that AI is not directly integrated -->
AI is not directly integrated. An idea I wanted to implement if time allowed was to have the app take voice (commentary) as an input and automatically interact with the database to update stats.
---

## Use of AI During Development
<!-- Describe how you used AI tools (e.g., ChatGPT, Copilot) to assist with design, debugging, learning, or implementation -->
I used ChatGPT heavily in almost every phase of the project. I got recommendations for database design and the tech stack. I also followed a plan to get to a minimum viable product.
I also used it for debugging, which was mainly for RLS polcies with an occasional frontend issue.
---

## Why This Project Is Interesting to Me
<!-- Explain your motivation for choosing this project and why it matters to you -->
I'm interested in sports and statistics. I also played for an intramural flag football team this semester, so that played a role in the inspiration. My vision for this project also included sports
analytics, but I didn't get to that much in the implementation for this project. I hope to add that on in the future.
---

## Key Learnings
<!-- Try to include at least 3 concrete learnings -->

1. I learned about RLS policies, what they are for, and how they affect database design.
2. Early database schema decisions have big consequences. A few times throughout the project, I updated the tables and added a new table. This resulted in the need for many frontend updates.
3. It's important to understand the relationship between database entities. For example, knowing that leagues have teams, teams play games, teams have players, and players have stats is crucial.

---

## System Design & Engineering Considerations
<!-- Explain relevant technical aspects of the system -->

### Architecture
<!-- High-level description of frontend, backend, database, and services -->

### Authentication & Authorization
<!-- How users authenticate and how permissions are enforced (e.g., RLS, roles) -->

### Scaling Characteristics
<!-- How the system scales, potential bottlenecks, and limits -->

### Performance Characteristics
<!-- Query performance, caching, client-side vs server-side work, etc. -->

### Failover & Reliability
<!-- Data durability, backups, failover strategies, or limitations -->

### Concurrency & Data Integrity
<!-- How concurrent updates are handled, conflicts avoided, or transactions managed -->

---

## Future Improvements (Optional)
<!-- Ideas for extending or improving the project -->
