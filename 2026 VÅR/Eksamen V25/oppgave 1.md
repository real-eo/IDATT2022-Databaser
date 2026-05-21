## *Oppgave 1*

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
ANSATT(_ansattID_, navn, epost)
STILLING(_stillingsNr_, fagområde, utlysningstekst, *ansattID)
UTLYSNING(_*stillingsNr_, utlysningsdato, søknadsfrist)
SØKER(_søkerID_, navn, addresse, epost, kompetanse)
INTERVJU(_intervjuID_, *ansattID,  *stillingsNr, *søkerID, tidspunkt, notat)

SØKER_STILLING_KOBLINGSTABELL(_*søkerID_, _*stillingsNr_)
```



# Oppgave c)

*Foreslå en eller flere SQL-setninger (spørringer) for å legge inn en ny stilling i løsningen din i Oppgave b). Foreslå noen fiktive (ikke veldig omfattende) attributtverdier. Forklar kort hvilke forutsetninger (antagelser) du har satt.*


### Queries
```SQL
INSERT INTO stilling (fagområde, utlysningstekst, ansattID)
VALUES (
    "Management", 
    "Dette er en rolle som krever en god gruppeleder og lagspiller, som hjelper avdelingen med å nå målene sine", 
    (SELECT ansattID FROM ansatt ORDER BY RANDOM() LIMIT 1)                             -- Kan også utføres med f.eks Java, eller med en spesifikk ansatt
);
```

### Forutsetninger
Jeg har valgt å anta at stillingsNr er en gyldig primærnøkkel og satt som AUTO_INCREMENT, og at det allerede finnes ansatte i databasen.


#### Oops, leste oppgaven feil...
> ### SQL-setninger
> 
> ```SQL
> -- ANSATT(_ansattID_, navn, epost)
> CREATE TABLE ansatt (
>     ansattID    INT PRIMARY KEY AUTO_INCREMENT,
>     navn        VARCHAR(255),
>     epost       VARCHAR(255)
> );
> 
> -- STILLING(_stillingsNr_, fagområde, utlysningstekst, *ansattID)
> CREATE TABLE stilling (
>     stillingsNr     INT PRIMARY KEY AUTO_INCREMENT,
>     fagområde       VARCHAR(255), 
>     utlysningstest  TEXT,
>     ansattID        INT,
>     FOREIGN KEY (ansattID) REFERENCES ansatt(ansattID)
> );
> 
> -- UTLYSNING(_*stillingsNr_, utlysningsdato, søknadsfrist)
> CREATE TABLE utlysning (
>     stillingsNr     INT PRIMARY KEY,
>     utlysningsdato  DATETIME,
>     søknadsfrist    DATETIME,
>     FOREIGN KEY (stillingsNr) REFERENCES stilling(stillingsNr)
> );
> 
> -- SØKER(_søkerID_, navn, addresse, epost, kompetanse)
> CREATE TABLE søker (
>     søkerID     BIGINT PRIMARY KEY AUTO_INCREMENT,
>     navn        VARCHAR(255),
>     addresse    VARCHAR(255),
>     epost       VARCHAR(255),
>     kompetanse  TEXT
> );
> 
> -- INTERVJU(_intervjuID_, *ansattID,  *stillingsNr, *søkerID, tidspunkt, notat)
> CREATE TABLE intervju (
>     intervjuID  BIGINT PRIMARY KEY AUTO_INCREMENT,
>     ansattID    INT,
>     stillingsNr INT,
>     søkerID     BIGINT,
>     tidspunkt   DATETIME,
>     notat       TEXT,
>     FOREIGN KEY (ansattID) REFERENCES ansatt(ansattID),
>     FOREIGN KEY (stillingsNr) REFERENCES stilling(stillingsNr),
>     FOREIGN KEY (søkerID) REFERENCES søker(søkerID)
> );
> 
> -- SØKER_STILLING_KOBLINGSTABELL(_*søkerID_, _*stillingsNr_)
> CREATE TABLE søker_stilling_koblingstabell (
>     søkerID     BIGINT,
>     stillingsNr INT,
>     PRIMARY KEY (søkerID, stillingsNr),
>     FOREIGN KEY (stillingsNr) REFERENCES stilling(stillingsNr),
>     FOREIGN KEY (søkerID) REFERENCES søker(søkerID)
> );



# Oppgave d)

*Gitt at vi i tillegg til det som kommer frem i ER-diagrammet ønsker å lagre hvilke søker (hvis noen) som faktisk ble ansatt i en gitt stilling. Anta her at kun en søker kan bli ansatt i en gitt stilling. I tillegg: Hvis ingen søkere blir ansatt i en stilling kan det være aktuelt å utlyse samme stilling på nytt. Foreslå med tekst en utvidelse av databasen slik at disse kravene kan registreres i databasen, og vis hvilke endringer i løsningen din fra Oppgave b) dette medfører. Du skal ikke tegne et nytt ER-diagram*


### Utvidelse
For å sørge for at en stilling kan bli lagt ut flere ganger, så hadde jeg implementert en surrogatnøkkel som primærnøkkel, også sørget for at det er stillingen som ivaretar referansen til utlysningen i form av en fremmednøkkel. I tillegg, så er det viktig å merkere fremmednøkkelen som `UNIQE`, slik at `0..1` forholdet håndheves. Dermed sørger vi for at relasjonene ivaretas, og at nye utlysninger kan bli lagt ut.

Vidre, for å lagre søker som ble ansatt, utvider jeg `SØKER_STILLING_KOBLINGSTABELL` til å også lagre om de fikk jobben som en boolsk attributt; eventuelt en fremmednøkkel til en rad fra en tabell over alle ansatte (her velger jeg med vilje å se bort ifra den nåværende `ansatt` tabellen, ettersom at den kanskje heller bør hete `intervjuer` slik jeg har tolket oppgaven).

