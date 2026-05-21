# Oppgave a)

*Primærnøkler (pk) er ikke tegnet inn i ER-diagrammet. Foreslå en primærnøkkel for hver entitetstype i diagrammet. Du kan utvide databasen med nye attributter for å lage primærnøkler hvis du synes dette er hensiktsmessig. Begrunn kort forslagene dine med tekst*


### Begrunnelse
- **`STILLING`**: Vi antar at stillingsnummeret gitt til oss er unikt. Om ikke, ville en egen `stillingsID` erstattet denne.
- **`UTLYSNING`**: Vi bruker stillingsNr som PK, slik at vi kan håndheve 0..1, og 1..1 relasjonen, ettersom at databasen vil gi oss duplicate PK error dersom vi forsøker å opprette flere utlysninger til samme stilling.
- **`SØKER`**: Vi definerer en egen søker id, slik at alle søkere er unike.
- **`ANSATT`**: Vi definerer en egen ansatt id, slik at alle ansatte er unike.
- **`INTERVJU`**: Vi definerer en egen surrogatnøkkel som primærnøkkel. Alternativet er å bruke en kompositt primærnøkkel, ettersom at det kun kan være én ansatt, som holer ett intervju for én stilling, sammen med én søker, men dette fungerer ikke dersom et intervju har flere runder (runde 1, runde 2, etc.).
- **`SØKER_STILLING_KOBLINGSTABELL`**: For å ikke få en mange-til-mange kobling mellom søker og stilling, lager vi en koblingstabell, hvor primærnøklen er en kompsitt nøkkel bestående av både søkeren og stillingen sin primærnøkkel.



# Oppgave b)

*Oversett ER-diagrammet, inkludert primærnøkler fra Oppgave a), til tabeller (relasjoner) ved å skrive tabellene på relasjonell form (slik som tabellene er satt opp i Oppgave 2) og understrek primærnøkler (primary keys) og marker fremmednøkler (foreign keys) med tegnet \*. Om du ikke får til understreking i Inspera, bruk strek foran og bak ordet, slik: \_persNr\_. Du skal ikke skrive `CREATE TABLE` -setninger i SQL eller foreslå datatyper til attributtene*

### Schema

```SQL
STILLING(_stillingsNr_, fagområde, utlysningstekst, *ansattID)
UTLYSNING(_*stillingsNr_, utlysningsdato, søknadsfrist)
SØKER(_søkerID_, navn, addresse, epost, kompetanse)
ANSATT(_ansattID_, navn, epost)
INTERVJU(_intervjuID_, *ansattID,  *stillingsNr, *søkerID, tidspunkt, notat)

SØKER_STILLING_KOBLINGSTABELL(_*søkerID_, _*stillingsNr_)
```



# Oppgave c)

*Foreslå en eller flere SQL-setninger (spørringer) for å legge inn en ny stilling i løsningen din i Oppgave b). Foreslå noen fiktive (ikke veldig omfattende) attributtverdier. Forklar kort hvilke forutsetninger (antagelser) du har satt.*

### SQL-setninger

```SQL
CREATE TABLE stilling (
    stillingsNr INT PRIMARY KEY,
    fagområde VARCHAR(255), 
    
)

