-- информация о размере БД на инстансе
SELECT 
      database_name = DB_NAME(database_id)
    , log_size_mb = CAST(SUM(CASE WHEN type_desc = 'LOG' THEN size END) * 8. / 1024 AS DECIMAL(8,2))
    , row_size_mb = CAST(SUM(CASE WHEN type_desc = 'ROWS' THEN size END) * 8. / 1024 AS DECIMAL(8,2))
    , total_size_mb = CAST(SUM(size) * 8. / 1024 AS DECIMAL(8,2))
FROM sys.master_files WITH(NOWAIT)
WHERE database_id > 4 --database_id = DB_ID('db_name') -- for db 
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
