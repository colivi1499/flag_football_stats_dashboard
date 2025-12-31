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
My initial project design was to use HTML/JS frontend with a Python (Flask) backend which connected to a SQLite database hosted locally. However, due to the need for more scalability and authentication, I
transitioned to a Supabase backend and Supabase authentication.


### Authentication & Authorization
<!-- How users authenticate and how permissions are enforced (e.g., RLS, roles) -->
Credentials for authentication are stored in Supabase. When a new user registers, a verification email is sent. RLS policies are in place to make sure only league managers have modification
privileges for entities in that league.

### Scaling Characteristics
<!-- How the system scales, potential bottlenecks, and limits -->
The system is limited by Supabase's free tier. In production, I could upgrade to accomodate a higher volume of reads/writes and emails sent. 

### Performance Characteristics
<!-- Query performance, caching, client-side vs server-side work, etc. -->
In the current implementation, some logic such as sorting and aggregating stats is handled by the client. The server (Supabase) handles simple queries to the database. If, in the future, 
the application logic is sensitive and should be hidden from the client, it could be implemented in Supabase. If heavy computations are required, for machine learning, for example, another
server may be required and access through API calls.

### Failover & Reliability
<!-- Data durability, backups, failover strategies, or limitations -->
The Supabase server runs on us-west-2. If this server were to go down, the app would not work.

### Concurrency & Data Integrity
<!-- How concurrent updates are handled, conflicts avoided, or transactions managed -->
Supabase uses PostgreSQL, which handles concurrent reads and writes with row-level locks, so conflicts are avoided.

---

## Future Improvements
<!-- Ideas for extending or improving the project -->
To extend the project, I would likely want to refactor the frontend code to move from raw HTML/CSS/JS to use Tailwind or Bootstrap and React. I would also want to separate concerns to
make the code more maintainable. By using Tailwind or Bootstrap and React, I would make the UI/UX more clean and remove duplicate HTML structures. I would also want to add more advanced analytics features
to answer questions like "who is the most valuable player?" and predict the win/loss probabilities for a given matchup.
