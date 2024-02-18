/*
1 - Personal or Desktop Engine (Not available in SQL Server 2005 (9.x) and later versions.)
2 - Standard (This is returned for Standard, Web, and Business Intelligence.)
3 - Enterprise (This is returned for Evaluation, Developer, and Enterprise editions.)
4 - Express (This is returned for Express, Express with Tools, and Express with Advanced Services)
5 - SQL Database
6 - Microsoft Azure Synapse Analytics (formerly SQL Data Warehouse)
8 - Azure SQL Managed Instance
9 - Azure SQL Edge (this is returned for both editions of Azure SQL Edge)
*/

SELECT 
SERVERPROPERTY('servername') as server_name,
SERVERPROPERTY('MachineName') AS machinename,
SERVERPROPERTY('productversion') as versions, 
SERVERPROPERTY ('productlevel') as levels, 
SERVERPROPERTY ('edition') as editions,
SERVERPROPERTY ('EngineEdition') as db_engine,
	case (CAST(SERVERPROPERTY('EngineEdition') AS int))
	when '1' then 'Personal or Desktop' 
	when '2' then 'Standard'
	when '3' then 'Enterprise'
	when '4' then 'Express'
	when '5' then 'SQL Database'
	when '6' then 'Microsoft Azure Synapse Analytics'
	when '8' then 'Azure SQL Managed Instance'
	when '9' then 'Azure SQL Edge'
	ELSE 'Ahother' END AS db_engine_text,
SERVERPROPERTY ('InstanceName') as instance_names
