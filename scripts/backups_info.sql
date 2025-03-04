-- all information about backup
SELECT bs.database_name, bm.physical_device_name, 
CASE bs.[type]
WHEN 'D' THEN 'Full'
WHEN 'I' THEN 'Diff'
WHEN 'L' THEN 'Log'
END 'type', bs.backup_size/1024/1024/1024 'size',
bs.backup_start_date, bs.backup_finish_date, bs.[user_name]
FROM msdb..backupset bs
	JOIN msdb..backupmediafamily bm ON bs.media_set_id = bm.media_set_id
--where bs.database_name = 'insert_db_name'
ORDER BY backup_start_date DESC
	
-- what tool to backup
SELECT bs.database_name, bm.physical_device_name,
CASE bs.[type]
	WHEN 'D' THEN 'Full'
	WHEN 'I' THEN 'Diff'
	WHEN 'L' THEN 'Log'
	END 'type', bs.backup_size/1024/1024/1024 'size',
	bs.backup_start_date, bs.backup_finish_date, bs.[user_name]
FROM msdb..backupset bs
JOIN msdb..backupmediafamily bm ON bs.media_set_id = bm.media_set_id
ORDER BY backup_start_date DESC

--последний бэкап
SELECT  @@Servername AS ServerName ,
        d.Name AS DBName ,
		b.type,
		CASE b.[type]
			WHEN 'D' THEN 'Full'
			WHEN 'I' THEN 'Diff'
			WHEN 'L' THEN 'Log'
		END 'type',
        MAX(b.backup_finish_date) AS LastBackupCompleted
FROM    sys.databases d
        LEFT OUTER JOIN msdb..backupset b ON b.database_name = d.name AND b.[type] in ('D', 'I', 'L')
GROUP BY d.Name, b.type
HAVING MAX(b.backup_finish_date) is not null
ORDER BY d.Name;

--сразу узнаете путь к файлу с последним бэкапом
SELECT  @@Servername AS ServerName ,
        d.Name AS DBName ,
        b.Backup_finish_date ,
        bmf.Physical_Device_name
FROM    sys.databases d
        INNER JOIN msdb..backupset b ON b.database_name = d.name AND b.[type] = 'D'
        INNER JOIN msdb.dbo.backupmediafamily bmf ON b.media_set_id = bmf.media_set_id
ORDER BY d.NAME , b.Backup_finish_date DESC

-- backup history
select
bs.database_name
,[backup_type] = case bs.type when 'D' then 'full' when 'I' then 'differential' when 'L' then 'log' end
,bs.name
,bs.user_name
,bs.backup_start_date
,bs.backup_finish_date
,bmf.physical_device_name
,bs.is_damaged
,bs.is_copy_only
,bs.server_name
,bs.machine_name
,cast(round(bs.backup_size/1048576,2) as decimal(10,0)) as 'backup_size_mb'
,cast(round(bs.compressed_backup_size/1048576,2) as decimal(10,0)) as 'compressed_backup_size_mb'
from msdb.dbo.backupset bs
left join msdb.dbo.backupmediafamily bmf on bmf.media_set_id=bs.media_set_id
where
bs.backup_finish_date > dateadd(dd,-1,getdate())
-- and bs.database_name in ('PADM')
-- and bs.database_name like 'Flex%'
--and bs.type = 'L' -- log backup
and bs.type = 'D' -- full backup
--or bs.type = 'D' -- full backup
and bs.type = 'I' -- diff backup
order by bs.backup_finish_date desc

SELECT sdb.Name AS DatabaseName,
MAX(bus.backup_finish_date) AS LastBackUpTime
FROM sys.sysdatabases sdb
LEFT OUTER JOIN msdb.dbo.backupset bus ON bus.database_name = sdb.name
GROUP BY sdb.Name

--сделать бэкап разбитый на файлы (актуально для большой БД)
BACKUP DATABASE [AdventureWorks2017] TO
DISK = N'D:\BACKUP\AdventureWorks2017_1.bak',
DISK = N'D:\BACKUP\AdventureWorks2017_2.bak',
DISK = N'D:\BACKUP\AdventureWorks2017_3.bak'
WITH  COPY_ONLY, NOFORMAT, NOINIT,  NAME = N'AdventureWorks2017-Full Database Backup', 
SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10, CHECKSUM
GO
declare @backupSetId as int
select @backupSetId = position from msdb..backupset 
	where database_name=N'AdventureWorks2017' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N'AdventureWorks2017' )
if @backupSetId is null begin raiserror(N'Verify failed. Backup information for database ''AdventureWorks2017'' not found.', 16, 1) end
RESTORE VERIFYONLY FROM  
DISK = N'D:\BACKUP\AdventureWorks2017_1.bak',
DISK = N'D:\BACKUP\AdventureWorks2017_2.bak',
DISK = N'D:\BACKUP\AdventureWorks2017_3.bak'
WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
GO
