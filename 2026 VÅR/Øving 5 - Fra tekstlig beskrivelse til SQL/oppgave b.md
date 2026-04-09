## Nøkler
*Primærnøkler understrekes her med navn.*
*Fremmednøkler markeres med `*`.*

```
KANDIDAT(__kandidatnr__, fornavn, etternavn, telefon, epost)
BEDRIFT(__orgnr__, navn, telefon, epost)
KVALIFIKASJON(__kvalifikasjonsnr__, beskrivelse)
KANDIDAT_KVALIFIKASJON(__*kandidatnr__, __*kvalifikasjonsnr__)
OPPDRAG(__oppdragsnr__, startdato_plan, sluttdato_plan, *orgnr, *kvalifikasjonsnr)
TILDELING(__*oppdragsnr__, *kandidatnr, virkelig_startdato, virkelig_sluttdato, timer_arbeidet)
SLUTTATTEST(__attestnr__, tekstmal, *oppdragsnr, *kandidatnr)
```

## `NULL` i fremmednøkler
Ja, det er rimelig at noen fremmednøkler kan være `NULL`, avhengig av hvordan du modellerer.

I denne modellen over er det mest naturlig at:
- `OPPDRAG.orgnr` ikke skal være `NULL` fordi hvert oppdrag må komme fra en bedrift.
- `OPPDRAG.kvalifikasjonsnr` ikke skal være `NULL` fordi oppgaven sier at hvert oppdrag krever eksakt én spesifikk kvalifikasjon. Hvis oppdraget ikke krever noen reell kvalifikasjon, kan man heller lage en rad i `KVALIFIKASJON` med for eksempel `beskrivelse = 'Ingen'`.
- I `TILDELING` kan virkelig_startdato, virkelig_sluttdato og timer_arbeidet godt være `NULL` før oppdraget er utført. Det betyr at kandidaten er tildelt, men oppdraget er ikke ferdigstilt ennå.
- I `SLUTTATTEST` bør fremmednøklene normalt ikke være `NULL`, siden attesten må høre til et konkret oppdrag og en konkret kandidat.