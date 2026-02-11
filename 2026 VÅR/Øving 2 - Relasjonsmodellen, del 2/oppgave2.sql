-- 2.1)
SELECT g.player, g.teamid, gm.mdate
FROM goal g
JOIN eteam t ON g.teamid = t.id
JOIN game gm ON g.matchid = gm.id
WHERE t.teamname = 'Germany';

-- 2.2)
SELECT g.player, COUNT(*) AS goals
FROM goal g
JOIN eteam t ON g.teamid = t.id
WHERE t.teamname = 'Germany'
GROUP BY g.player
ORDER BY goals DESC;

-- 2.3)
SELECT g.player, g.teamid, t.coach, g.gtime
FROM goal g
JOIN eteam t ON g.teamid = t.id
WHERE g.gtime <= 10
ORDER BY g.gtime;

-- 2.4)
SELECT gm.mdate, t.teamname
FROM game gm
JOIN eteam t ON gm.team1 = t.id
WHERE t.coach = 'Fernando Santos'
ORDER BY gm.mdate;

-- 2.5)
SELECT gm.mdate, t.teamname
FROM game gm
JOIN eteam t ON gm.team1 = t.id
WHERE t.coach = 'Fernando Santos'
UNION
SELECT gm.mdate, t.teamname
FROM game gm
JOIN eteam t ON gm.team2 = t.id
WHERE t.coach = 'Fernando Santos'
ORDER BY mdate;