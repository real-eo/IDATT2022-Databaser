## Oppgave 1
### Forløp
- Klient 1: `READ UNCOMMITTED`
- Klient 2: `SERIALIZABLE`

-> Begge starter transaksjon.

``` 
Klient 1 leser konto 1.
Klient 2 leser konto 1.
Klient 1 oppdaterer konto 1 til saldo = 1.
Klient 1 committer.
Klient 2 committer.
```

### Hva skjer og hvorfor?
Klient 2 med `SERIALIZABLE` tar i praksis en svært streng lesing. I MySQL vil en vanlig `SELECT` normalt være en konsistent lesing uten å bli blokkert av en samtidig oppdatering, men ved `SERIALIZABLE` behandles lesing strengere, og det kan føre til at oppdateringen eller senere operasjoner må vente avhengig av nøyaktig kjøremønster.

Poenget er:
- Klient 2 skal ikke lese uryddige/innekonsistente data.
- `SERIALIZABLE` skal gi et resultat som om transaksjonene kjørte etter hverandre.
  
### Hva hadde skjedd om Klient 2 hadde brukt et annet isolasjonsnivå?
- `READ UNCOMMITTED`: kunne i prinsippet lest ikke-committede data
- `READ COMMITTED`: ser bare committede data
- `REPEATABLE READ`: vil beholde samme snapshot gjennom hele transaksjonen
- `SERIALIZABLE`: strengest, hindrer flere samtidighetsproblemer

### Svar
Klient 2 vil ikke se en "skitten" verdi fra Klient 1 før commit. Med `SERIALIZABLE` blir samtidigheten mer begrenset for å sikre seriell oppførsel. Ved lavere isolasjonsnivå ville mer samtidighet vært tillatt, men samtidig så vil flere uønskede bivirkninger som "dirty read" eller "non-repeatable read" potensielt oppstå, avhengig av nivå.

