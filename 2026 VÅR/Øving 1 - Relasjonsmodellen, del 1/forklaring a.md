## a) Tabeller på relasjonell form med begrunnelse for primærnøkler

```
borettslag(borettslag_id, navn, adresse, antall_enheter, etableringsaar)

bygning(bygning_id, borettslag_id*, adresse, antall_etasjer, antall_leiligheter)

leilighet(leilighet_id, bygning_id*, leilighetsnummer, antall_rom, antall_kvm, etasje, andelseier_id*)

andelseier(andelseier_id, fornavn, etternavn, telefon, epost, fodselsdato)
```

**Begrunnelse for primærnøkler:**

- **borettslag_id**: Navn kan være like for forskjellige borettslag, og adresse kan endres. En unik ID er derfor nødvendig.
- **bygning_id**: Adresse alene er ikke nok, da flere bygninger kan ha lignende adresser i forskjellige borettslag. En unik ID sikrer entydig identifikasjon.
- **leilighet_id**: Leilighetsnummer kan repeteres i forskjellige bygninger/borettslag. En unik ID er mest robust.
- **andelseier_id**: Kombinasjoner av navn kan være like, og telefon/epost kan endres. En syntetisk nøkkel sikrer entydig identifikasjon.

