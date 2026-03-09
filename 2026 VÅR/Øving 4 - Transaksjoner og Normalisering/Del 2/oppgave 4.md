## Oppgave 4: Test av phantom reads

Et phantom read skjer når en transaksjon leser et sett av rader to ganger, og i mellomtiden har en annen transaksjon satt inn nye rader som gjør at andre lesing gir flere rader.

### Eksempel til kjøring
Anta at `konto` har kolonner som gjør at vi kan søke på saldo.

**Klient 1**
```sql
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT * FROM konto WHERE saldo > 100;
```

**Klient 2**
```sql
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
INSERT INTO konto (kontonr, saldo) VALUES (99, 1000);
COMMIT;
```

**Klient 1 igjen**
```sql
SELECT * FROM konto WHERE saldo > 100;
COMMIT;
```

#### Forventet resultat
Ved `READ COMMITTED` kan Klient 1 få opp en ekstra rad i andre `SELECT`. Det er et phantom read.

#### Hvordan unngå phantom reads?
Bruk `SERIALIZABLE` (eller mekanismer som next-key locking i InnoDB under visse spørringer).

### Svar
For å teste phantom reads kan Klient 1 lese et utvalg rader med en betingelse, mens Klient 2 setter inn en ny rad som oppfyller betingelsen før Klient 1 leser på nytt. Hvis Klient 1 da får opp en ekstra rad i andre lesing, har vi phantom read. Dette skjer typisk ved lavere isolasjonsnivåer som `READ COMMITTED`, men hindres ved `SERIALIZABLE`.

