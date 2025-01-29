## Шаги по миграции с сервера А на сервер В

1. Опеределить список компонентов и необходимость их переноса на новый сервер
    * SQL Server Integration Services (SSIS) 
    * SQL Server Analysis Services
2. Определить список баз данных и их размер, которые будут перенесены на новый сервер
3. Опеределить список логинов, которые будут перенесены на новый сервер
4. Опередлить список заданий, которые будут пернесены на новый сервер
5. Проверить наличие линкованных серверов

### Определить список баз данных и их размер

Запрос для получения списка пользовательских баз данных и размер в MB

```sql
SELECT 
database_name = DB_NAME(database_id)
, log_size_mb = CAST(SUM(CASE WHEN type_desc = 'LOG' THEN size END) * 8. / 1024 AS DECIMAL(10,2))
, row_size_mb = CAST(SUM(CASE WHEN type_desc = 'ROWS' THEN size END) * 8. / 1024 AS DECIMAL(10,2))
, total_size_mb = CAST(SUM(size) * 8. / 1024 AS DECIMAL(10,2))
FROM sys.master_files WITH(NOWAIT)
WHERE database_id > 4 --database_id = DB_ID('db_name') -- for db 
GROUP BY database_id;
```

### Опеределить список логинов

Шаги переноса логинов:
1. запустить на сервер A скрипт [код](https://github.com/Inga-Z/SQL_Server/blob/main/procedure/sp_help_revlogin.sql), который создаст хранимую процедуру 'sp_help_revlogin'
2. запустить хранимую процедуру 'sp_help_revlogin' для формирования списка логинов
```sql
EXEC sp_help_revlogin;
```
3. скопировать результат выполнения хранимой процедуры и выполнить на сервере B 

### Проверить наличие линкованных серверов

Скрипт получения списка линкованных серверов

```sql
SELECT  @@SERVERNAME AS Server ,
    Server_Id AS  LinkedServerID ,
    name AS LinkedServer ,
    Product ,
    Provider ,
    Data_Source ,
    Modify_Date
FROM sys.servers
ORDER BY name;
```
