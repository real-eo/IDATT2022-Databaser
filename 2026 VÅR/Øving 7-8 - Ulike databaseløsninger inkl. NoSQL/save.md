Nedenfor får du et komplett forslag som dekker hele caset (registrering av pakke, sporing/hendelser, og fortolling der tollhendelser kan ha “behandlingssted” som er ulik fysisk lokasjon). Jeg bruker MySQL-syntaks og viser både relasjonsmodell, joins, JSON-bruk og en MongoDB-dokumentmodell.

---

## 1.1 Relasjonsdatabase (SQL) – forslag til datamodell

### Grunntanke / hva må modellen støtte?
- **Pakke** med unikt sporingsnummer, vekt, avsender, mottaker.
- **Hendelser** som bygges opp over tid: tidspunkt, status, lokasjon.
- **Tollhendelser** som er hendelser, men med *viktig detalj*: tollbehandlingssted kan være et annet sted enn hvor pakken fysisk er.
- Sporing: finne pakke på sporingsnummer og vise full historikk.

### Tabeller (minst 4) og relasjoner
Jeg foreslår 5 tabeller:

1) `party` (aktør: avsender/mottaker)  
2) `address` (adresse knyttet til en aktør)  
3) `package` (pakke + tracking number, vekt, kobling til avsender/mottaker)  
4) `location` (steder/terminaler/land/by)  
5) `package_event` (alle hendelser – både logistikk og toll)

**Hvorfor én hendelsestabell?**  
Det gjør historikk og sortering enkelt: én tidslinje per pakke. Toll vs ikke-toll løses med `event_type` og ekstra felt for toll.

---

### SQL (CREATE TABLE) – skisse
> Du *kan* levere bare skisse, men dette er “implementerbar” MySQL.

```sql
CREATE TABLE party (
  party_id      BIGINT PRIMARY KEY AUTO_INCREMENT,
  party_type    ENUM('PERSON','COMPANY') NOT NULL,
  name          VARCHAR(200) NOT NULL,
  phone         VARCHAR(50),
  email         VARCHAR(200)
);

CREATE TABLE address (
  address_id    BIGINT PRIMARY KEY AUTO_INCREMENT,
  party_id      BIGINT NOT NULL,
  line1         VARCHAR(200) NOT NULL,
  line2         VARCHAR(200),
  postal_code   VARCHAR(30),
  city          VARCHAR(100),
  country_code  CHAR(2) NOT NULL,
  FOREIGN KEY (party_id) REFERENCES party(party_id)
);

CREATE TABLE package (
  package_id         BIGINT PRIMARY KEY AUTO_INCREMENT,
  tracking_number    VARCHAR(50) NOT NULL UNIQUE,
  weight_kg          DECIMAL(8,3) NOT NULL,
  sender_party_id    BIGINT NOT NULL,
  receiver_party_id  BIGINT NOT NULL,
  created_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (sender_party_id) REFERENCES party(party_id),
  FOREIGN KEY (receiver_party_id) REFERENCES party(party_id)
);

CREATE TABLE location (
  location_id    BIGINT PRIMARY KEY AUTO_INCREMENT,
  name           VARCHAR(200) NOT NULL,   -- f.eks. "Oslo Terminal", "Hamburg Hub"
  city           VARCHAR(100),
  country_code   CHAR(2) NOT NULL
);

CREATE TABLE package_event (
  event_id                    BIGINT PRIMARY KEY AUTO_INCREMENT,
  package_id                  BIGINT NOT NULL,
  occurred_at                 DATETIME NOT NULL,
  status                      VARCHAR(80) NOT NULL,  -- "registrert", "under transport", ...
  event_type                  ENUM('LOGISTICS','CUSTOMS') NOT NULL,

  -- Fysisk lokasjon: hvor pakken faktisk er/ble skannet
  physical_location_id        BIGINT NULL,

  -- Behandlings-/administrativ lokasjon: spesielt relevant for toll
  processing_location_id      BIGINT NULL,

  description                 VARCHAR(500),

  FOREIGN KEY (package_id) REFERENCES package(package_id),
  FOREIGN KEY (physical_location_id) REFERENCES location(location_id),
  FOREIGN KEY (processing_location_id) REFERENCES location(location_id),

  INDEX (package_id, occurred_at)
);
```

**Viktig caset-detalj (toll vs fysisk sted):**
- For vanlige hendelser: `event_type='LOGISTICS'`, bruk typisk `physical_location_id`.
- For tollhendelser: `event_type='CUSTOMS'`, *kan* ha:
  - `processing_location_id = Oslo` (toll behandles digitalt i Norge)
  - `physical_location_id = Shanghai` (pakken er fortsatt i utlandet)

---

### Eksempeldata (kort)
```sql
-- Eksempel: pakke P123
-- package(tracking_number='P123', sender_party_id=1, receiver_party_id=2, weight_kg=2.400)

-- Hendelser:
-- 1) registrert (fysisk: Hamburg)
-- 2) tollklarering startet (processing: Oslo, fysisk: Hamburg)
-- 3) tollklarert (processing: Oslo, fysisk: Hamburg)
-- 4) under transport (fysisk: Oslo Terminal)
-- 5) levert (fysisk: Trondheim)
```

---

### Minst 3 SQL-spørringer med JOIN (mot minst to tabeller)

#### Spørring 1: Finn pakke på sporingsnummer + avsender og mottaker
```sql
SELECT
  p.tracking_number,
  p.weight_kg,
  s.name AS sender_name,
  r.name AS receiver_name,
  p.created_at
FROM package p
JOIN party s ON s.party_id = p.sender_party_id
JOIN party r ON r.party_id = p.receiver_party_id
WHERE p.tracking_number = 'P123';
```

#### Spørring 2: Full historikk/tidslinje (viser både fysisk og behandlingssted)
```sql
SELECT
  p.tracking_number,
  e.occurred_at,
  e.event_type,
  e.status,
  pl.name AS physical_location,
  prl.name AS processing_location,
  e.description
FROM package p
JOIN package_event e ON e.package_id = p.package_id
LEFT JOIN location pl  ON pl.location_id  = e.physical_location_id
LEFT JOIN location prl ON prl.location_id = e.processing_location_id
WHERE p.tracking_number = 'P123'
ORDER BY e.occurred_at;
```

#### Spørring 3: Finn alle pakker som “venter på dokumentasjon” i toll – men hvor fysisk lokasjon er i utlandet
```sql
SELECT
  p.tracking_number,
  e.occurred_at,
  e.status,
  phys.country_code AS physical_country,
  proc.name AS processing_location
FROM package_event e
JOIN package p ON p.package_id = e.package_id
LEFT JOIN location phys ON phys.location_id = e.physical_location_id
LEFT JOIN location proc ON proc.location_id = e.processing_location_id
WHERE e.event_type = 'CUSTOMS'
  AND e.status = 'Venter på dokumentasjon'
  AND phys.country_code <> 'NO'
ORDER BY e.occurred_at DESC;
```

---

### Kort oppsummering (erfaringer + videre arbeid)
- **Lett å spørre på historikk:** Én hendelsestabell (`package_event`) gjør tidslinje-spørringer veldig enkle.
- **Joinene er overkommelige:** Typisk 2–4 tabeller per spørring (pakke + hendelser + lokasjon + parter).
- **Videre arbeid (forbedringer):**
  - Normalisere `status` til egen tabell eller ENUM for konsistens (unngå skrivefeil i `"levert"` osv.).
  - Legge på “current_status/current_location” i `package` for raskere oppslag (denormalisering) + triggere/oppdateringslogikk.
  - Mer avansert adressemodell (historikk, flere adresser per aktør, validering).

---

## 1.2 Løsning med JSON i MySQL

### Hva kan egne seg som JSON i dette caset?
Typisk “varierende” data:
- Tollmetadata kan variere (dokumentkrav, referansenummer, varer, HS-koder).
- Ekstra skannedata/hendelsesmetadata (temperatur, signaturinfo, transportørkode, etc.)

Jeg foreslår å legge til et JSON-felt i `package_event` for fleksible detaljer.

```sql
ALTER TABLE package_event
ADD COLUMN details JSON NULL;
```

**Eksempel på JSON i en tollhendelse (`details`):**
```json
{
  "customsCaseId": "NO-2026-000991",
  "requiredDocuments": ["invoice", "id"],
  "missingDocuments": ["invoice"],
  "goods": [
    { "description": "Headphones", "hsCode": "8518.30", "value": 79.99, "currency": "USD" }
  ]
}
```

### SELECT-spørring som henter ut JSON-data
Eksempel: Finn tollhendelser for pakke P123 og hent ut `customsCaseId` + antall manglende dokumenter.

```sql
SELECT
  p.tracking_number,
  e.occurred_at,
  e.status,
  JSON_UNQUOTE(JSON_EXTRACT(e.details, '$.customsCaseId')) AS customs_case_id,
  JSON_LENGTH(JSON_EXTRACT(e.details, '$.missingDocuments')) AS missing_doc_count
FROM package p
JOIN package_event e ON e.package_id = p.package_id
WHERE p.tracking_number = 'P123'
  AND e.event_type = 'CUSTOMS'
ORDER BY e.occurred_at;
```

### Fordeler og ulemper med JSON her
**Fordeler**
- Fleksibelt for data som varierer mye mellom hendelser (spesielt toll).
- Mindre behov for mange “små-tabeller” for sjeldne felter.
- Rask å utvide med nye attributter uten migrering av mange tabeller.

**Ulemper**
- Vanskeligere å håndheve datakvalitet (f.eks. obligatoriske felter i JSON).
- Mer komplisert å indeksere og optimalisere spørringer (selv om MySQL støtter funksjonsindekser/JSON-indekser i noen scenarier).
- Mindre “relasjonell” spørring (JOIN på JSON-felt er typisk dårlig idé).

---

## 1.3 NoSQL-vurdering (generelt) + MongoDB egnethet

### Generelt om NoSQL som alternativ
**Passer bra hvis:**
- Du vil modellere en pakke som ett aggregat (“én pakke = ett dokument”) med innebygd hendelsesliste.
- Du oftest leser hele historikken for én pakke av gangen (typisk tracking-oppslag).
- Skjemaet kan variere (spesielt toll-data og forskjellige event-typer).

**Passer dårligere hvis:**
- Du trenger mye rapportering på tvers (f.eks. “alle pakker i region X med status Y siste 24 timer” med tunge joins/aggregater).
- Du trenger sterke referanse-integritetskrav (FK-regler) og normalisering.

### Hvor bra er MongoDB (dokumentdatabase) egnet?
**Veldig egnet** for “sporing per sporingsnummer”:
- Ett dokument per pakke med en `events[]`-array gir rask lesing av historikk.
- Toll-hendelser kan ha egne underfelt som varierer uten å endre skjema.

**Men:** Hvis du har mye *operasjonell analyse* på tvers av alle pakker (terminalbelastning, KPIer, komplekse rapporter), kan en relasjonsdatabase ofte være enklere/mer robust. (MongoDB kan gjøre det med aggregations, men kompleksiteten øker.)

---

## 1.4 MongoDB – ett dokument (JSON) for én spesifikk pakke

Under er et forslag til **ett** dokument som inneholder det samme som i relasjonsmodellen (pakke + avsender/mottaker + hendelser + både fysisk og behandlingssted + toll-detaljer).

```json
{
  "_id": "P123",
  "trackingNumber": "P123",
  "weightKg": 2.4,
  "createdAt": "2026-04-10T09:15:00Z",

  "sender": {
    "partyType": "PERSON",
    "name": "Ola Nordmann",
    "phone": "+47 90000000",
    "email": "ola@example.com",
    "address": {
      "line1": "Storgata 1",
      "postalCode": "0155",
      "city": "Oslo",
      "countryCode": "NO"
    }
  },

  "receiver": {
    "partyType": "PERSON",
    "name": "Kari Nordmann",
    "phone": "+47 91111111",
    "email": "kari@example.com",
    "address": {
      "line1": "Kongens gate 2",
      "postalCode": "7011",
      "city": "Trondheim",
      "countryCode": "NO"
    }
  },

  "events": [
    {
      "occurredAt": "2026-04-10T09:16:00Z",
      "eventType": "LOGISTICS",
      "status": "registrert",
      "physicalLocation": { "name": "Hamburg Hub", "city": "Hamburg", "countryCode": "DE" },
      "processingLocation": null,
      "description": "Package registered at origin hub"
    },
    {
      "occurredAt": "2026-04-10T12:00:00Z",
      "eventType": "CUSTOMS",
      "status": "Tollklarering startet",
      "physicalLocation": { "name": "Hamburg Hub", "city": "Hamburg", "countryCode": "DE" },
      "processingLocation": { "name": "Oslo Customs", "city": "Oslo", "countryCode": "NO" },
      "description": "Digital pre-clearance started",
      "details": {
        "customsCaseId": "NO-2026-000991",
        "requiredDocuments": ["invoice", "id"],
        "missingDocuments": ["invoice"],
        "goods": [
          { "description": "Headphones", "hsCode": "8518.30", "value": 79.99, "currency": "USD" }
        ]
      }
    },
    {
      "occurredAt": "2026-04-10T18:30:00Z",
      "eventType": "CUSTOMS",
      "status": "Venter på dokumentasjon",
      "physicalLocation": { "name": "Hamburg Hub", "city": "Hamburg", "countryCode": "DE" },
      "processingLocation": { "name": "Oslo Customs", "city": "Oslo", "countryCode": "NO" },
      "description": "Missing invoice"
    },
    {
      "occurredAt": "2026-04-11T08:00:00Z",
      "eventType": "CUSTOMS",
      "status": "Tollklarert",
      "physicalLocation": { "name": "Hamburg Hub", "city": "Hamburg", "countryCode": "DE" },
      "processingLocation": { "name": "Oslo Customs", "city": "Oslo", "countryCode": "NO" },
      "description": "Customs cleared"
    },
    {
      "occurredAt": "2026-04-11T14:10:00Z",
      "eventType": "LOGISTICS",
      "status": "ankommet terminal",
      "physicalLocation": { "name": "Oslo Terminal", "city": "Oslo", "countryCode": "NO" },
      "processingLocation": null,
      "description": "Arrived Norway"
    },
    {
      "occurredAt": "2026-04-12T11:45:00Z",
      "eventType": "LOGISTICS",
      "status": "levert",
      "physicalLocation": { "name": "Trondheim", "city": "Trondheim", "countryCode": "NO" },
      "processingLocation": null,
      "description": "Delivered to recipient"
    }
  ]
}
```

---

Hvis du vil, kan jeg også:
- forenkle teksten så den passer direkte inn i en innlevering (mer “rapport-format”),
- eller lage et lite ER-diagram i tekstform (crow’s foot-beskrivelse) basert på tabellene over.