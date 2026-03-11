SELECT oh.*, od.*
FROM ordrehode oh
JOIN ordredetalj od ON oh.ordrenr = od.ordrenr
WHERE oh.levnr = 44;