SELECT 
SERVERPROPERTY('servername') as server_name,
SERVERPROPERTY('MachineName') AS machinename,
SERVERPROPERTY ('InstanceName') as instance_names,
SERVERPROPERTY ('Collation') as Collation,
SERVERPROPERTY ('productlevel') as levels, 
SERVERPROPERTY ('ProductUpdateLevel') as CU,
SERVERPROPERTY('ProductVersion') AS Product_Version,
SERVERPROPERTY('IsClustered') as IsClustered,
	case (CAST(SERVERPROPERTY('IsClustered') AS int))
	when '1' then 'cluster'
	when '0' then 'no cluster'
	ELSE 'Ahother' END AS IsClustered_text,
SERVERPROPERTY('IsHadrEnabled') as AlwaysOn,
	case (CAST(SERVERPROPERTY('IsHadrEnabled') AS int))
	when '1' then 'AlwaysOn_enable'
	when '0' then 'AlwaysOn_not_enable'
	ELSE 'Ahother' END AS AlwaysOn_text,
SERVERPROPERTY ('edition') as editions,
SERVERPROPERTY ('EngineEdition') as db_engine,
	case (CAST(SERVERPROPERTY('EngineEdition') AS int))
	when '1' then 'Personal or Desktop' --1 - Personal or Desktop Engine (Not available in SQL Server 2005 (9.x) and later versions.)
	when '2' then 'Standard' --2 - Standard (This is returned for Standard, Web, and Business Intelligence.)
	when '3' then 'Enterprise' --3 - Enterprise (This is returned for Evaluation, Developer, and Enterprise editions.)
	when '4' then 'Express' -- 4 - Express (This is returned for Express, Express with Tools, and Express with Advanced Services)
	when '5' then 'SQL Database' --5 - SQL Database
	when '6' then 'Microsoft Azure Synapse Analytics' -- 6 - Microsoft Azure Synapse Analytics (formerly SQL Data Warehouse)
	when '8' then 'Azure SQL Managed Instance' -- 8 - Azure SQL Managed Instance
	when '9' then 'Azure SQL Edge' -- 9 - Azure SQL Edge (this is returned for both editions of Azure SQL Edge)
	ELSE 'Ahother' END AS db_engine_text,
@@VERSION as SQLServerVersion

--Retrieve Free Space of Hard Disk
EXEC master..xp_fixeddrives

--port
USE MASTER
GO
xp_readerrorlog 0, 1, N'Server is listening on'
GO
