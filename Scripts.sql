--db name, owner
select db.name, db.database_id, l.name as Owner_Login, db.state_desc as Current_State, is_read_only
from sys.databases db
	left join master.sys.syslogins l on db.owner_sid = l.sid
	
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
--where a.database_id > 4
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

--First query shows the account (credential identity) linked to the proxy Second Query shows what Job and Step is using a Proxy
-- Search Credentials (shows account for Name)
use msdb
go
select *
from sys.credentials
	
--Search Jobs where there is a 'Run As' proxy and get the name of that proxy
use msdb
GO
select  sysjobsteps.job_id
, sysjobs.name as 'JobName'
, sysjobsteps.step_id
, sysjobsteps.step_name
, sysjobsteps.subsystem
, sysjobsteps.last_run_date
, sysjobsteps.proxy_id
--, sysjobsteps.step_uid
, sysproxies.name as 'ProxyName'
from sysjobsteps
    left join dbo.sysproxies on sysjobsteps.proxy_id = sysproxies.proxy_id
    left join dbo.sysjobs on sysjobsteps.job_id = sysjobs.job_id
where sysjobsteps.proxy_id > 0

--линкованный сервер
SELECT ss.server_id 
          ,ss.name 
          ,'Server ' = Case ss.Server_id 
                            when 0 then 'Current Server' 
                            else 'Remote Server' 
                            end 
          ,ss.product 
          ,ss.provider 
          ,ss.catalog 
          ,'Local Login ' = case sl.uses_self_credential 
                            when 1 then 'Uses Self Credentials' 
                            else ssp.name 
                            end 
           ,'Remote Login Name' = sl.remote_name 
           ,'RPC Out Enabled'    = case ss.is_rpc_out_enabled 
                                   when 1 then 'True' 
                                   else 'False' 
                                   end 
           ,'Data Access Enabled' = case ss.is_data_access_enabled 
                                    when 1 then 'True' 
                                    else 'False' 
                                    end 
           ,ss.modify_date 
      FROM sys.Servers ss 
 LEFT JOIN sys.linked_logins sl 
        ON ss.server_id = sl.server_id 
 LEFT JOIN sys.server_principals ssp 
        ON ssp.principal_id = sl.local_principal_id

SELECT  
    c.session_id, c.net_transport, c.encrypt_option,  
    c.auth_scheme, s.host_name, s.program_name,  
    s.client_interface_name, s.login_name, s.nt_domain,  
    s.nt_user_name, s.original_login_name, c.connect_time,  
    s.login_time,
    t.text
FROM sys.dm_exec_connections AS c
JOIN sys.dm_exec_sessions AS s
    ON c.session_id = s.session_id
CROSS APPLY sys.dm_exec_sql_text(c.most_recent_sql_handle) AS t
WHERE s.host_name like N'%MI0673P%'
