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

--последним бэкап
SELECT  @@Servername AS ServerName ,
        d.Name AS DBName ,
        MAX(b.backup_finish_date) AS LastBackupCompleted
FROM    sys.databases d
        LEFT OUTER JOIN msdb..backupset b ON b.database_name = d.name AND b.[type] = 'D'
GROUP BY d.Name
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
and bs.type = 'L' -- log backup
or bs.type = 'D' -- full backup
-- and bs.type = 'I' -- diff backup
order by bs.backup_finish_date desc

SELECT sdb.Name AS DatabaseName,
MAX(bus.backup_finish_date) AS LastBackUpTime
FROM sys.sysdatabases sdb
LEFT OUTER JOIN msdb.dbo.backupset bus ON bus.database_name = sdb.name
GROUP BY sdb.Name
