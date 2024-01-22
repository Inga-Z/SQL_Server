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
