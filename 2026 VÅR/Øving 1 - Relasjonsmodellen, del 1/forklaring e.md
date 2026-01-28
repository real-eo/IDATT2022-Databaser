## e) Vurdering av ON DELETE/UPDATE CASCADE

```sql
-- 1. bygning.borettslag_id
ALTER TABLE bygning 
ADD CONSTRAINT bygning_fk FOREIGN KEY (borettslag_id) 
    REFERENCES borettslag(borettslag_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;
```
**Begrunnelse**: 
- **ON DELETE RESTRICT**: Vi ønsker IKKE å slette bygninger automatisk når et borettslag slettes. Dette kan føre til tap av viktig historisk data. Borettslaget må først tømmes for bygninger.
- **ON UPDATE CASCADE**: Hvis borettslag_id endres (sjeldent, men mulig), bør endringen følge med til bygningene.

```sql
-- 2. leilighet.bygning_id
ALTER TABLE leilighet 
ADD CONSTRAINT leilighet_bygning_fk FOREIGN KEY (bygning_id) 
    REFERENCES bygning(bygning_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;
```
**Begrunnelse**:
- **ON DELETE RESTRICT**: Leiligheter bør ikke slettes automatisk når en bygning slettes. Dette kan være katastrofalt for eier-informasjon og historikk.
- **ON UPDATE CASCADE**: ID-endringer bør propagere.

```sql
-- 3. leilighet.andelseier_id
ALTER TABLE leilighet 
ADD CONSTRAINT leilighet_andelseier_fk FOREIGN KEY (andelseier_id) 
    REFERENCES andelseier(andelseier_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE;
```
**Begrunnelse**:
- **ON DELETE SET NULL**: Når en andelseier slettes (f.eks. ved flytting, salg eller død), bør leiligheten settes til å være uten eier (NULL) i stedet for å slette leiligheten. Dette bevarer leilighetsdata og reflekterer virkeligheten.
- **ON UPDATE CASCADE**: ID-endringer bør propagere.

**Oppsummering:**
- **CASCADE er farlig** for DELETE-operasjoner i de fleste tilfeller, da det kan føre til utilsiktet sletting av mye data
- **SET NULL** er et godt alternativ når det er logisk at barn-rader kan eksistere uten forelder (som leilighet uten eier)
- **RESTRICT** (eller NO ACTION) er tryggere når vi vil forhindre sletting av foreldre som har barn
- **CASCADE for UPDATE** er vanligvis trygt, da ID-endringer er sjeldne og bør propagere