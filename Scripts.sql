-- Query to List All Jobs with Owners
SELECT s.name AS JobName, l.name AS JobOwner
FROM msdb..sysjobs s
LEFT JOIN master.sys.syslogins l ON s.owner_sid = l.sid
WHERE l.name IS NOT NULL
ORDER by l.name

-- You can use below query to return all job names with owners, even for those logins does not exists
SELECT NAME AS JobName, SUSER_SNAME(owner_sid) AS JobOwner
FROM msdb..sysjobs
ORDER BY NAME

-- файлы БД с размером в Mb 
SELECT  @@SERVERNAME AS Server ,
        a.name AS DBName ,
        a.recovery_model_Desc AS RecoveryModel ,
        a.Compatibility_level AS CompatiblityLevel ,
        a.create_date ,
        a.state_desc,
				mf.type_desc,
				a.collation_name,
				mf.size/128 as 'Size_MB' 
FROM    sys.databases a
	join sys.master_files mf on a.database_id = mf.database_id
where a.database_id > 4
ORDER BY a.name;

--linked servers
SELECT  @@SERVERNAME AS Server ,
        Server_Id AS  LinkedServerID ,
        name AS LinkedServer ,
        Product ,
        Provider ,
        Data_Source ,
        Modify_Date
FROM    sys.servers
ORDER BY name;

-- Вывести список баз данных, защищенных TDE, и получить имя сертификата
USE master 
GO 

SELECT db.name as [database_name], cer.name as [certificate_name] 
FROM sys.dm_database_encryption_keys dek 
LEFT JOIN sys.certificates cer ON dek.encryptor_thumbprint = cer.thumbprint 
INNER JOIN sys.databases db ON dek.database_id = db.database_id 
WHERE dek.encryption_state = 3
