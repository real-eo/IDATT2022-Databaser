## *Oppgave 2*

*Et sett med tabeller (relasjoner) i relasjonsmodellen ser slik ut på relasjonell form der primærnøkler er streket under, mens fremmednøkler er markert med \*:*
```SQL
BLOMSTER(_bid_, bnavn, btype*, pris, storrelse, beskrivelse)
BLOMSTTYPE(_btype_, typenavn, betypenavn*)
BEGIVENHET(_beid_, dato, tidspunkt, betypenavn*, stednavn*, beskrivelse)
STED(_stednavn_, adresse, postnr, beskrivelse)
BEGIVTYPE(_betypenavn_, beskrivelse)
LEVERING(_levnr_, bid*, beid*, kundetelefon)
```

*Tabellene inneholder noen attributter i en tenkt database for bestilling med levering av ulike blomster (blomsterbuketter) til ulike begivenheter, som konfirmasjon, bryllup og begravelse. En begivenhet finner sted på et sted med en gitt adresse. Sted her kan f.eks. være en navngitt kirke eller selskapslokale. Attributtet tidspunkt er et gitt klokkeslett og viser sammen med dato når en begivenhet finner sted. Kundedata er begrenset til attributtet kundetelefon.*

*Attributtnavn på fremmednøkler er likt attributtnavn til primærnøkler de refererer til.*

### SQL-oppgaver
*I deloppgavene under skal du skrive SQL-setninger (spørringer) - en eller flere for hver oppgave - for å komme fram til svaret. TIPS: Løs deloppgavene i den rekkefølgen de står.*



# Oppgave a)

*Skriv ut antall begivenheter som finner sted i "Ila kirke" (dvs. stednavn = "Ila kirke") i juni 2025.*

```SQL
SELECT COUNT(beid) AS antall 
FROM BEGIVENHET
WHERE stednavn = 'Ila kirke'
  AND dato >= '2025-06-01'
  AND dato <  '2025-07-01';
``` 



# Oppgave b)

*Skriv ut bid, bnavn og beid på alle blomster(-buketter) som leveres til bryllup (dvs. betypenavn = "bryllup") i "Ila kirke" på dato = '2025-05-24' sortert alfabetisk på bnavn.*

```SQL
SELECT L.bid, B.bnavn, L.beid
FROM       LEVERING   AS L
INNER JOIN BLOMSTER   AS B  ON L.bid = B.bid
INNER JOIN BEGIVENHET AS BE ON L.beid = BE.beid
WHERE BE.betypenavn = 'bryllup'
  AND BE.stednavn = 'Ila kirke'
  AND BE.dato = '2025-05-24'
ORDER BY B.bnavn ASC;
```



# Oppgave c)

*Finn for hvert bryllup på dato = '2025-05-24' den totale prisen for blomster som leveres til bryllupet. Kun bryllup som har minst en leveranse skal være med i svaret.*

```SQL
SELECT BE.beid, SUM(B.pris) AS total
FROM       LEVERING   AS L
INNER JOIN BLOMSTER   AS B  ON L.bid = B.bid
INNER JOIN BEGIVENHET AS BE ON L.beid = BE.beid
WHERE BE.betypenavn = 'bryllup'
  AND BE.dato = '2025-05-24'
GROUP BY BE.beid;
```



# Oppgave d)

*Det er meningen at blomster som leveres til bryllup er blomstertyper som er beregnet for bryllup (dvs. betypenavn = "bryllup"), men vi har ingen garanti for at dette stemmer. Sjekk om det finnes bryllup som har flere antall leveranser av blomster som ikke er beregnet for bryllup enn antall leveranse som er beregnet for bryllup. Skriv ut beid for disse bryllupene*

```SQL
SELECT BE.beid, 
FROM       LEVERING   AS L
INNER JOIN BLOMSTER   AS B  ON L.bid = B.bid
INNER JOIN BEGIVENHET AS BE ON L.beid = BE.beid
INNER JOIN BLOMSTTYPE AS BT ON BT.btype = B.btype
WHERE BE.betypenavn = 'bryllup'
GROUP BY BE.beid
HAVING SUM(CASE WHEN BT.betypenavn <> 'bryllup' THEN 1 ELSE 0 END)
     > SUM(CASE WHEN BT.betypenavn  = 'bryllup' THEN 1 ELSE 0 END);
```
