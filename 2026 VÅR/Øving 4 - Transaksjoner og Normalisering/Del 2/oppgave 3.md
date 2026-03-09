## Oppgave 3
### Forløp
- Klient 1: `READ UNCOMMITTED`
- Klient 2: `SERIALIZABLE`

-> Begge starter transaksjon.

```
Klient 1 starter
Klient 2 starter
Klient 1 select sum(saldo) from konto;
Klient 2 update konto set saldo = saldo + 10 where kontonr=1;
Klient 1 select sum(saldo) from konto;
Klient 2 commit;
Klient 1 select sum(saldo) from konto;
Klient 1 commit
```


### Hva skjer?
Siden Klient 1 bruker `READ UNCOMMITTED`, kan den i prinsippet lese ikke-committede endringer. Det betyr at summen i steg 5 kan være forskjellig fra steg 3, selv før Klient 2 committer.

Dette viser et mulig dirty read / manglende stabilitet i lesingen.

### Hva vil skje om Klient 1 bruker andre isolasjonsnivåer?
#### `READ COMMITTED`
Klient 1 vil bare se committede data.
- Før commit fra Klient 2 ser den gammel verdi
- Etter commit kan den se ny verdi

Dette kan gi non-repeatable read.

#### `REPEATABLE READ`
Klient 1 vil se samme snapshot gjennom hele transaksjonen. 
Alle `select sum(...)` i samme transaksjon vil normalt gi samme resultat, selv om Klient 2 committer underveis.

#### `SERIALIZABLE`
Strengeste nivå. Lesing og skriving må oppføre seg som sekvensiell kjøring. Klient 2 kan bli blokkert, eller lesingene/samspillet blir sterkt begrenset.

### Svar
Med `READ UNCOMMITTED` kan Klient 1 lese endringer gjort av Klient 2 før commit. Med `READ COMMITTED` ser Klient 1 bare committede endringer, så resultatet kan endre seg etter commit. Med `REPEATABLE READ` vil Klient 1 normalt få samme sum hele transaksjonen. Med `SERIALIZABLE` blir samtidigheten enda mer begrenset for å hindre slike fenomener.