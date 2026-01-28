## d) NULL i fremmednøkler og primærnøkler

**Fremmednøkler:**

- **bygning.borettslag_id**: Bør **IKKE** være NULL. En bygning må alltid tilhøre et borettslag.
  
- **leilighet.bygning_id**: Bør **IKKE** være NULL. En leilighet må alltid tilhøre en bygning.

- **leilighet.andelseier_id**: Bør **tillate NULL**. I følge problemstillingen kan en leilighet være uten eier i perioder. Dette gjenspeiler virkeligheten der leiligheter kan stå tomme eller være under salg.

**Primærnøkler:**

Primærnøkler kan **ALDRI** være NULL. Dette er en grunnleggende regel i relasjonsdatabaser:
- En primærnøkkel må unikt identifisere hver rad
- NULL betyr "ukjent verdi", og kan derfor ikke brukes til unik identifikasjon
- MySQL vil automatisk sette PRIMARY KEY-kolonner til NOT NULL

