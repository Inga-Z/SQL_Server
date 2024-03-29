IF OBJECT_ID('[dbo].[DatabaseBackup]') IS NOT NULL DROP PROCEDURE [dbo].[DatabaseBackup]
IF OBJECT_ID('[dbo].[DatabaseIntegrityCheck]') IS NOT NULL DROP PROCEDURE [dbo].[DatabaseIntegrityCheck]
IF OBJECT_ID('[dbo].[IndexOptimize]') IS NOT NULL DROP PROCEDURE [dbo].[IndexOptimize]
IF OBJECT_ID('[dbo].[CommandExecute]') IS NOT NULL DROP PROCEDURE [dbo].[CommandExecute]
IF OBJECT_ID('[dbo].[DatabaseSelect]') IS NOT NULL DROP FUNCTION [dbo].[DatabaseSelect]
IF OBJECT_ID('[dbo].[CommandLog]') IS NOT NULL DROP TABLE [dbo].[CommandLog]

IF EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = 'CommandLog Cleanup') EXECUTE msdb.dbo.sp_delete_job @job_name = 'CommandLog Cleanup'
IF EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = 'DatabaseBackup - SYSTEM_DATABASES - FULL') EXECUTE msdb.dbo.sp_delete_job @job_name = 'DatabaseBackup - SYSTEM_DATABASES - FULL'
IF EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = 'DatabaseBackup - USER_DATABASES - DIFF') EXECUTE msdb.dbo.sp_delete_job @job_name = 'DatabaseBackup - USER_DATABASES - DIFF'
IF EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = 'DatabaseBackup - USER_DATABASES - FULL') EXECUTE msdb.dbo.sp_delete_job @job_name = 'DatabaseBackup - USER_DATABASES - FULL'
IF EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = 'DatabaseBackup - USER_DATABASES - LOG') EXECUTE msdb.dbo.sp_delete_job @job_name = 'DatabaseBackup - USER_DATABASES - LOG'
IF EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = 'DatabaseIntegrityCheck - SYSTEM_DATABASES') EXECUTE msdb.dbo.sp_delete_job @job_name = 'DatabaseIntegrityCheck - SYSTEM_DATABASES'
IF EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = 'DatabaseIntegrityCheck - USER_DATABASES') EXECUTE msdb.dbo.sp_delete_job @job_name = 'DatabaseIntegrityCheck - USER_DATABASES'
IF EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = 'IndexOptimize - USER_DATABASES') EXECUTE msdb.dbo.sp_delete_job @job_name = 'IndexOptimize - USER_DATABASES'
IF EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = 'Output File Cleanup') EXECUTE msdb.dbo.sp_delete_job @job_name = 'Output File Cleanup'
IF EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = 'sp_delete_backuphistory') EXECUTE msdb.dbo.sp_delete_job @job_name = 'sp_delete_backuphistory'
IF EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = 'sp_purge_jobhistory') EXECUTE msdb.dbo.sp_delete_job @job_name = 'sp_purge_jobhistory'
