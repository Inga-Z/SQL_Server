-- общая информация о БД
sp_helpdb [db_name]

-- файлы БД с размером в Mb 
SELECT  
	@@SERVERNAME AS Server ,
    a.name AS DBName,
	mf.name AS [File Name],
	mf.type_desc,
	mf.physical_name,
        a.recovery_model_Desc AS RecoveryModel ,
        a.Compatibility_level AS CompatiblityLevel ,
        a.create_date ,
        a.state_desc,
	a.collation_name,
	mf.size/128 as 'Size_MB',
	mf.growth AS [Growth Value],
	CASE 
		WHEN mf.is_percent_growth = 1 THEN 'Percentage Growth' 
		ELSE 'MB Growth'
		END AS [Growth Type]
FROM    sys.databases a
	join sys.master_files mf on a.database_id = mf.database_id
where a.database_id > 4 --and a.name = 'db_name'
ORDER BY a.name;

-- информация о размере БД на инстансе
SELECT 
    database_name = DB_NAME(database_id)
    , log_size_mb = CAST(SUM(CASE WHEN type_desc = 'LOG' THEN size END) * 8. / 1024 AS DECIMAL(8,2))
    , row_size_mb = CAST(SUM(CASE WHEN type_desc = 'ROWS' THEN size END) * 8. / 1024 AS DECIMAL(8,2))
    , total_size_mb = CAST(SUM(size) * 8. / 1024 AS DECIMAL(8,2))
FROM sys.master_files WITH(NOWAIT)
WHERE database_id > 4 --database_id = DB_ID('db_name') -- for db 
GROUP BY database_id

SELECT 
    database_name = DB_NAME(database_id)
    , log_size_mb = CAST(SUM(CASE WHEN type_desc = 'LOG' THEN size END) * 8. / 1024 AS DECIMAL(10,2))
    , row_size_mb = CAST(SUM(CASE WHEN type_desc = 'ROWS' THEN size END) * 8. / 1024 AS DECIMAL(10,2))
    , total_size_mb = CAST(SUM(size) * 8. / 1024 AS DECIMAL(10,2))
FROM sys.master_files WITH(NOWAIT)
WHERE database_id > 4 --and database_id = DB_ID('')
GROUP BY database_id

--проверить % выполнение команд и сколько времени до завершения
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
