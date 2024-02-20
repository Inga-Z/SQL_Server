-- список сертификатов
select * from sys.certificates

-- список ключей
select * from sys.symmetric_keys

-- Вывести список баз данных, защищенных TDE, и получить имя сертификата
USE master 
GO 
SELECT db.name as [database_name], cer.name as [certificate_name] 
FROM sys.dm_database_encryption_keys dek 
  LEFT JOIN sys.certificates cer ON dek.encryptor_thumbprint = cer.thumbprint 
  INNER JOIN sys.databases db ON dek.database_id = db.database_id 
WHERE dek.encryption_state = 3

