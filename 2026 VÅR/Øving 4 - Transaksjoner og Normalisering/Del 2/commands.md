## Hvordan starte og avslutte en transaksjon

I MySQL brukes typisk:
```sql
START TRANSACTION;
COMMIT;
ROLLBACK;
```
Eventuelt:

```sql
BEGIN;
```

### Commit test
```sql
START TRANSACTION;
UPDATE konto SET saldo = saldo + 100 WHERE kontonr = 1;
COMMIT;
```

*Endingen blir permanent lagret*


### Rollback test
```sql
START TRANSACTION;
UPDATE konto SET saldo = saldo + 100 WHERE kontonr = 1;
ROLLBACK;
```

*Endringen blir angret*