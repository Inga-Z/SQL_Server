-- история ресторов
SELECT
    rh.destination_database_name AS [Database],
        CASE WHEN rh.restore_type = 'D' THEN 'Database'
            WHEN rh.restore_type = 'F' THEN 'File'
            WHEN rh.restore_type = 'I' THEN 'Differential'
            WHEN rh.restore_type = 'L' THEN 'Log'
        ELSE rh.restore_type 
        END AS [Restore Type],
    rh.restore_date AS [Restore Date],
    bmf.physical_device_name AS [Source], 
    rf.destination_phys_name AS [Restore File],
    rh.user_name AS [Restored By]
FROM msdb.dbo.restorehistory rh
    INNER JOIN msdb.dbo.backupset bs ON rh.backup_set_id = bs.backup_set_id
    INNER JOIN msdb.dbo.restorefile rf ON rh.restore_history_id = rf.restore_history_id
    INNER JOIN msdb.dbo.backupmediafamily bmf ON bmf.media_set_id = bs.media_set_id
-- where rh.destination_database_name = 'DEV_ERP_BEKETOBA'
ORDER BY rh.restore_history_id DESC
GO

--сколько до завешения рестора
select	r.session_id as SPID, 
		command, 
		a.text as query, 
		start_time, 
		percent_complete,
		dateadd(second, estimated_completion_time/1000, GETDATE()) as estimated_completion_time
from sys.dm_exec_requests r
cross apply sys.dm_exec_sql_text(r.sql_handle) a
where r.command in ('BACKUP DATABASE', 'RESTORE DATABASE', 'BACKUP LOG', 'RESTORE LOG',
					'ALTER INDEX', 'KILLED/ROLLBACK')
					or r.command like '%DBCC%' or r.command like 'RESTORE%'

-- кто делал рестор
SELECT  [restore_date]
        ,[destination_database_name]
        ,[user_name]
        ,[backup_set_id]
        ,[restore_type]
        ,[replace]
        ,[recovery]
        ,[restart]
FROM [msdb].[dbo].[restorehistory]
ORDER BY [restore_date] desc

-- скрипт рестора БД
USE [master]
alter database [db_name] set single_user with rollback immediate
GO
RESTORE DATABASE [db_name] 
FROM  DISK = N'\\BKPdb01\SQLBkp.Repo.Hot\backup\1CDBPR-01-MSK\buhleasing20\1CDBPR-01-MSK_buhleasing20_FULL_20241031_003004.bak' 
WITH  FILE = 1,  
MOVE N'MSFO' TO N'D:\DataDB\DEV_BP_1C_ERPGROUP_3.mdf',  
MOVE N'MSFO_log' TO N'D:\LogDB\DEV_BP_1C_ERPGROUP_3_log.ldf',  NOUNLOAD,  REPLACE,  STATS = 5
alter database [db_name] SET MULTI_USER
GO