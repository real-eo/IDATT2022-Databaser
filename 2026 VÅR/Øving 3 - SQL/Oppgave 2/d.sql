SELECT oh.ordrenr,
       oh.dato,
       od.delnr,
       d.beskrivelse,
       od.kvantum,
       p.pris,
       od.kvantum * p.pris AS belop
FROM ordrehode oh
JOIN ordredetalj od ON oh.ordrenr = od.ordrenr
JOIN delinfo d ON od.delnr = d.delnr
JOIN prisinfo p ON p.delnr = od.delnr AND p.levnr = oh.levnr
WHERE oh.ordrenr = 16;