## Oppgave 2a
### Forløp
- Begge klienter bruker `READ UNCOMMITTED`

-> Begge starter transaksjon.

```
Klient 1 oppdaterer kontonr=1 til 1
Klient 2 prøver å oppdatere kontonr=1 til 2
Klient 1 oppdaterer kontonr=2 til 1
Klient 1 commit
Klient 2 oppdaterer kontonr=2 til 2
Klient 2 commit
```

### Hva blir resultatet?
Sluttresultatet blir normalt:
- `kontonr=1` får saldo = 2
- `kontonr=2` får saldo = 2
  

### Hvorfor må det være slik?
Selv om isolasjonsnivået er `READ UNCOMMITTED`, så tar `UPDATE` fortsatt eksklusive låser på radene. Klient 2 må vente når Klient 1 holder lås på `kontonr=1`. Etter at Klient 1 committer, kan Klient 2 fortsette og overskrive verdiene.

Altså:
- skrive-skrive-konflikter håndteres med låser
- siste commit/oppdatering "vinner" her

### Svar
Resultatet blir at begge kontoene til slutt får saldo 2. Grunnen er at `UPDATE` krever eksklusiv lås, så Klient 2 må vente på Klient 1. Når Klient 1 har committet, gjennomfører Klient 2 sine oppdateringer og overskriver verdiene.


## Oppgave 2b
Her oppdaterer Klient 2 i motsatt rekkefølge:
- først `kontonr=2`
- senere `kontonr=1`

-> Begge starter transaksjon.

### Hva blir resultatet?
Her oppstår det fare for deadlock:
```
Klient 1 låser kontonr=1
Klient 2 låser kontonr=2
Klient 1 prøver så å låse kontonr=2 og må vente
Klient 2 prøver så å låse kontonr=1 og må vente
```

Da har vi sirkulær venting, altså deadlock. I slike tilfeller vil MySQL normalt oppdage deadlock og rulle tilbake én av transaksjonene.

### Forskjell fra oppgave a
- I oppgave a tok begge klientene radene i samme rekkefølge. Da blir det venting, men ikke deadlock.
- I oppgave b tar de radene i ulik rekkefølge, og da kan deadlock oppstå.

### Vil det ha noe å si om man endrer isolasjonsnivå?
Ikke nødvendigvis for deadlock i denne situasjonen. Deadlock skyldes først og fremst rekkefølgen på låsing av rader, ikke lesenivået. Isolasjonsnivå kan påvirke andre typer konflikter, men her er det skriveoperasjonene og låserekkefølgen som er avgjørende.

### Svar
I oppgave b kan det oppstå deadlock fordi klientene låser hver sin rad først og deretter prøver å låse den andre raden. Dette er forskjellen fra a, der begge tok radene i samme rekkefølge. Endring av isolasjonsnivå vil normalt ikke fjerne dette problemet, fordi det skyldes konkurrerende skrivelåser (race conditions).