-- =====================================================================
-- Sports League Database Full Setup Script
-- =====================================================================

-- 1. DATABASE CREATION
-- Drop the database if it exists to ensure a clean start, then create and select it.
-- ---------------------------------------------------------------------
DROP DATABASE IF EXISTS sports;
CREATE DATABASE sports;
USE sports;


-- =====================================================================
-- 2. TABLE DEFINITIONS (DDL)
-- Creating the schema for Teams, Players, Games, and PlayerStats.
-- ---------------------------------------------------------------------

-- Teams Table: Stores information about each team.
CREATE TABLE Teams (
    team_id INT PRIMARY KEY,
    team_name VARCHAR(100) NOT NULL UNIQUE
);

-- Players Table: Stores information about each player and their team affiliation.
CREATE TABLE Players (
    player_id INT PRIMARY KEY,
    player_name VARCHAR(100) NOT NULL,
    team_id INT,
    FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);

-- Games Table: Stores information about each game, including teams and scores.
CREATE TABLE Games (
    game_id INT PRIMARY KEY,
    team1_id INT,
    team2_id INT,
    score_team1 INT,
    score_team2 INT,
    game_date DATE,
    FOREIGN KEY (team1_id) REFERENCES Teams(team_id),
    FOREIGN KEY (team2_id) REFERENCES Teams(team_id)
);

-- PlayerStats Table: Stores individual player statistics for each game.
CREATE TABLE PlayerStats (
    stat_id INT PRIMARY KEY AUTO_INCREMENT,
    player_id INT,
    game_id INT,
    points INT,
    assists INT,
    rebounds INT,
    FOREIGN KEY (player_id) REFERENCES Players(player_id),
    FOREIGN KEY (game_id) REFERENCES Games(game_id) ON DELETE CASCADE
);


-- =====================================================================
-- 3. DATA INSERTION (DML)
-- Populating the tables with sample data.
-- ---------------------------------------------------------------------

-- Inserting 20 sample teams
INSERT INTO Teams (team_id, team_name) VALUES
(1, 'Red Dragons'), (2, 'Blue Tigers'), (3, 'Green Sharks'), (4, 'Yellow Eagles'),
(5, 'Black Panthers'), (6, 'White Wolves'), (7, 'Orange Bears'), (8, 'Purple Lions'),
(9, 'Silver Falcons'), (10, 'Gold Hawks'), (11, 'Crimson Hawks'), (12, 'Azure Foxes'),
(13, 'Emerald Snakes'), (14, 'Amber Owls'), (15, 'Ivory Elephants'), (16, 'Navy Dolphins'),
(17, 'Bronze Rhinos'), (18, 'Violet Lynxes'), (19, 'Steel Bulls'), (20, 'Titan Bears');

-- Inserting 20 sample players + 1 player without a team for the LEFT JOIN query
INSERT INTO Players (player_id, player_name, team_id) VALUES
(1, 'John Doe', 1), (2, 'Jane Smith', 2), (3, 'Michael Brown', 3), (4, 'Emily Davis', 4),
(5, 'David Wilson', 5), (6, 'Sarah Moore', 6), (7, 'James Taylor', 7), (8, 'Linda Anderson', 8),
(9, 'Robert Lee', 9), (10, 'Maria Martinez', 10), (11, 'Chris Evans', 11), (12, 'Scarlett Johnson', 12),
(13, 'Mark Ruffalo', 13), (14, 'Jeremy Renner', 14), (15, 'Tom Holland', 15), (16, 'Benedict Cumberbatch', 16),
(17, 'Chadwick Boseman', 17), (18, 'Elizabeth Olsen', 18), (19, 'Paul Rudd', 19), (20, 'Tom Hardy', 20),
(21, 'Free Agent Player', NULL);

-- Inserting 20 sample games with updated, recent dates
INSERT INTO Games (game_id, team1_id, team2_id, score_team1, score_team2, game_date) VALUES
(1, 1, 2, 5, 3, '2025-08-01'), (2, 3, 4, 2, 4, '2025-08-02'), (3, 5, 6, 6, 6, '2025-08-03'),
(4, 7, 8, 3, 3, '2025-08-04'), (5, 9, 10, 7, 1, '2025-08-05'), (6, 1, 3, 4, 2, '2025-08-15'),
(7, 2, 4, 5, 5, '2025-08-16'), (8, 6, 7, 6, 2, '2025-08-17'), (9, 8, 9, 4, 6, '2025-08-18'),
(10, 5, 10, 7, 3, '2025-08-19'), (11, 11, 12, 3, 5, '2025-08-20'), (12, 13, 14, 4, 4, '2025-08-21'),
(13, 15, 16, 7, 6, '2025-08-22'), (14, 17, 18, 5, 8, '2025-08-23'), (15, 19, 20, 9, 2, '2025-08-24'),
(16, 11, 13, 6, 5, '2025-08-25'), (17, 12, 14, 7, 4, '2025-08-26'), (18, 15, 17, 5, 6, '2025-08-27'),
(19, 16, 18, 8, 7, '2025-08-28'), (20, 19, 11, 4, 3, '2025-08-29');

-- Inserting 20 sample player statistics
INSERT INTO PlayerStats (player_id, game_id, points, assists, rebounds) VALUES
(1, 1, 5, 3, 8), (2, 1, 3, 5, 4), (3, 2, 2, 1, 2), (4, 2, 4, 3, 5), (5, 3, 6, 4, 7),
(6, 3, 6, 5, 6), (7, 4, 3, 2, 4), (8, 4, 3, 3, 3), (9, 5, 7, 1, 9), (10, 5, 1, 1, 2),
(11, 11, 3, 2, 5), (12, 11, 5, 4, 6), (13, 12, 4, 3, 3), (14, 12, 4, 5, 4), (15, 13, 7, 2, 8),
(16, 13, 6, 4, 7), (17, 14, 5, 1, 5), (18, 14, 8, 3, 9), (19, 15, 9, 2, 11), (20, 15, 2, 1, 3);


-- =====================================================================
-- 4. ADVANCED FEATURES (VIEW AND TRIGGERS)
-- Adding a summary view and data integrity triggers.
-- ---------------------------------------------------------------------

-- Creating a View to summarize player statistics
CREATE OR REPLACE VIEW PlayerStatisticsSummary AS
SELECT
    p.player_name,
    t.team_name,
    COUNT(ps.game_id) AS games_played,
    COALESCE(SUM(ps.points), 0) AS total_points,
    COALESCE(AVG(ps.points), 0) AS avg_points_per_game,
    COALESCE(SUM(ps.assists), 0) AS total_assists,
    COALESCE(SUM(ps.rebounds), 0) AS total_rebounds
FROM Players p
LEFT JOIN Teams t ON p.team_id = t.team_id
LEFT JOIN PlayerStats ps ON p.player_id = ps.player_id
GROUP BY p.player_id, p.player_name, t.team_name;

-- Creating Triggers to ensure points cannot be negative
-- The DELIMITER is changed to $$ to allow the trigger body to be defined.
DELIMITER $$

CREATE TRIGGER before_playerstats_insert
BEFORE INSERT ON PlayerStats
FOR EACH ROW
BEGIN
    IF NEW.points < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Points cannot be negative.';
    END IF;
    IF NEW.assists < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Assists cannot be negative.';
    END IF;
    IF NEW.rebounds < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Rebounds cannot be negative.';
    END IF;
END$$

CREATE TRIGGER before_playerstats_update
BEFORE UPDATE ON PlayerStats
FOR EACH ROW
BEGIN
    IF NEW.points < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Points cannot be negative.';
    END IF;
    IF NEW.assists < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Assists cannot be negative.';
    END IF;
    IF NEW.rebounds < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Rebounds cannot be negative.';
    END IF;
END$$

-- Resetting the delimiter back to the default semicolon.
DELIMITER ;


-- =====================================================================
-- 5. SCRIPT EXECUTION COMPLETE
-- The database is now fully set up and ready for querying.
-- ---------------------------------------------------------------------

SELECT 'Database setup complete. You can now run your analysis queries.' AS status;

-- Example: You can test the view immediately after running the script.
SELECT * FROM PlayerStatisticsSummary LIMIT 5;


select * from players;

SELECT p.player_name, SUM(ps.points) AS total_points 
FROM Players p 
JOIN PlayerStats ps ON p.player_id = ps.player_id 
GROUP BY p.player_name 
ORDER BY total_points DESC;


SELECT p.player_name,ps.points
FROM Players p 
JOIN PlayerStats ps ON p.player_id = ps.player_id 
where ps.points>5;

select t.team_id,p.player_name,t.team_name
 from players p  
 left join teams t on p.team_id=t.team_id
 order by t.team_name desc;
 
 
 -- 1. Query to calculate the total points scored by each player
SELECT
    p.player_name,
    SUM(ps.points) AS total_points
FROM
    PlayerStats AS ps
JOIN
    Players AS p ON ps.player_id = p.player_id
GROUP BY
    p.player_name
ORDER BY
    total_points DESC;

-- 2. Query to find players who scored points between 3 and 6
SELECT p.player_name,ps.points
FROM PlayerStats AS ps
JOIN Players AS p ON ps.player_id = p.player_id
WHERE ps.points BETWEEN 3 AND 6
ORDER BY ps.points DESC;

-- 3. Find players from the same team
-- This query finds pairs of players on the same team.
SELECT
    p1.player_name,p1.player_id,
    t.team_name,t.team_id
FROM
    Players p1 JOIN Teams t ON p1.team_id = t.team_id
    order by t.team_id asc;

SELECT 
    p1.player_name AS player1_name,
    p2.player_name AS player2_name,
    t.team_name
FROM players p1
JOIN players p2 
    ON p1.team_id = p2.team_id 
   AND p1.player_id <> p2.player_id   -- allows pairs both ways
JOIN teams t 
    ON p1.team_id = t.team_id
ORDER BY t.team_name, p1.player_name, p2.player_name;


-- 4. Find games played in the last 30 days

SELECT game_id, team1_id, team2_id, score_team1, score_team2, game_date
FROM Games																
WHERE game_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
  AND game_date <= CURDATE()
UNION ALL
SELECT NULL AS game_id, NULL AS team1_id, NULL AS team2_id, NULL AS score_team1, NULL AS score_team2, 
       'No games played in the last 30 days' AS game_date
WHERE NOT EXISTS (
    SELECT 1 
    FROM Games
    WHERE game_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
      AND game_date <= CURDATE()
);

SELECT
    game_id,
    t1.team_name AS team1,
    t2.team_name AS team2,
    score_team1,
    score_team2,
    game_date
FROM Games g
JOIN Teams t1 ON g.team1_id = t1.team_id
JOIN Teams t2 ON g.team2_id = t2.team_id
WHERE game_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);


-- 5. Create a view to summarize player statistics
CREATE OR REPLACE VIEW PlayerStatisticsSummary AS
SELECT
    p.player_name,
    t.team_name,
    COUNT(ps.game_id) AS games_played,
    COALESCE(SUM(ps.points), 0) AS total_points,
    COALESCE(AVG(ps.points), 0) AS avg_points_per_game,
    COALESCE(SUM(ps.assists), 0) AS total_assists,
    COALESCE(SUM(ps.rebounds), 0) AS total_rebounds
FROM Players p
LEFT JOIN Teams t ON p.team_id = t.team_id
LEFT JOIN PlayerStats ps ON p.player_id = ps.player_id
GROUP BY p.player_id, p.player_name, t.team_name;

-- After creating the view, query it like this:
SELECT * FROM PlayerStatisticsSummary;

-- 6. Create a trigger to ensure points cannot be negative before inserting or updating
-- This trigger is set up to run BEFORE an INSERT or UPDATE on the PlayerStats table.
-- If the new 'points' value is less than 0, it will raise an error and prevent the operation.
DELIMITER $$
CREATE TRIGGER check_negative_points
BEFORE INSERT ON PlayerStats
FOR EACH ROW
BEGIN
    IF NEW.points < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Points cannot be a negative value.';
    END IF;
END$$
DELIMITER ;


-- You can also create a separate trigger for updates
DELIMITER $$
CREATE TRIGGER check_negative_points_update
BEFORE UPDATE ON PlayerStats
FOR EACH ROW
BEGIN
    IF NEW.points < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Points cannot be a negative value.';
    END IF;
END$$
DELIMITER ;

-- 7. Fetch all players and their respective teams, including players without a team
SELECT
    p.player_name,
    t.team_name
FROM
    Players AS p
LEFT JOIN
    Teams AS t ON p.team_id = t.team_id;

-- 8. Total points scored by players, grouped by their teams
SELECT
    t.team_name,
    SUM(ps.points) AS total_team_points
FROM
    Teams AS t
JOIN
    Players AS p ON t.team_id = p.team_id
JOIN
    PlayerStats AS ps ON p.player_id = ps.player_id
GROUP BY
    t.team_name
ORDER BY
    total_team_points DESC;

-- 9. Players who scored more than 5 points
SELECT
    p.player_name,
    ps.points
FROM
    PlayerStats AS ps
JOIN
    Players AS p ON ps.player_id = p.player_id
WHERE
    ps.points > 5
ORDER BY
    ps.points DESC;


-- 10. Update and assign Sarah Moore to the team Green Sharks
set sql_safe_updates=0;
UPDATE Players
SET team_id = (SELECT team_id FROM Teams WHERE team_name = 'Green Sharks')
WHERE player_name = 'Sarah Moore';

-- 11. Deleting all records where the game id is 5
DELETE FROM PlayerStats WHERE game_id = 5;
DELETE FROM Games WHERE game_id = 5;

-- 12. Players who scored more than the average points in a specific game
-- This query finds players who scored more than the average points of the game they participated in.
SELECT
    p.player_name,
    ps.points,
    ps.game_id
FROM
    PlayerStats AS ps
JOIN
    Players AS p ON ps.player_id = p.player_id
WHERE
    ps.points > (SELECT AVG(points) FROM PlayerStats WHERE game_id = ps.game_id);

-- 13. Find the top 3 players who have scored the highest total points across all games.
SELECT
    p.player_name,
    SUM(ps.points) AS total_points
FROM
    PlayerStats AS ps
JOIN
    Players AS p ON ps.player_id = p.player_id
GROUP BY
    p.player_name
ORDER BY
    total_points DESC
LIMIT 3;

-- 14. Retrieve a list of teams that have won at least one game, considering a win as having a higher score than the opposing team.
SELECT distinct
    g.game_id,
    t.team_name AS winning_team,
    GREATEST(g.score_team1, g.score_team2) AS won_by_score,
    opp.team_name AS opponent_team
FROM Games g
JOIN Teams t
  ON (g.team1_id = t.team_id AND g.score_team1 > g.score_team2)
   OR (g.team2_id = t.team_id AND g.score_team2 > g.score_team1)
JOIN Teams opp
  ON ( (t.team_id = g.team1_id AND opp.team_id = g.team2_id) 
    OR (t.team_id = g.team2_id AND opp.team_id = g.team1_id) )
ORDER BY g.game_id ASC;

select * from teams;

-- 15. Determine the average number of rebounds per player for each team and list the teams in descending order of average rebounds.
SELECT
    t.team_name,
    AVG(ps.rebounds) AS avg_team_rebounds
FROM
    PlayerStats AS ps
JOIN
    Players AS p ON ps.player_id = p.player_id
JOIN
    Teams AS t ON p.team_id = t.team_id
GROUP BY
    t.team_name
ORDER BY
    avg_team_rebounds DESC;