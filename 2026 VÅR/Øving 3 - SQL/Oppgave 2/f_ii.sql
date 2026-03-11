CREATE VIEW levinfo_view AS
SELECT l.levnr,
       l.navn,
       l.adresse,
       l.levby,
       b.fylke,
       l.postnr
FROM levinfo2 l
JOIN byfylke b ON l.levby = b.levby;