SELECT CONCAT(fornavn, ' ', etternavn, ', ansiennitet: ', ansiennitet, ' år') AS liste
FROM andelseier
ORDER BY ansiennitet DESC;