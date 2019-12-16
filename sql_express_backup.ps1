### Script Notes ###
#
# ServerInstance = computername\servername
# Database = databasename
# BackupFile = location and filename
# BackupFile will save to sql_backup folder on drive root and add timestamp
#
# Bottom portion of code deletes all files in the sql_backup directory if they are older than 90 days.
#
### Task Scheduler ###
#
# Create Task Scheduler task and assign this powershell script to run
# If unable to authenticate use 'whoami' in powershell to see full username
# The 'Action' should execute 'Powershell.exe' and agruments need to be passed in (example shown below)
# Arguments: -ExecutionPolicy Bypass C:\full\path\to\script.ps1
# These arguments ignore the powershell execution policy and execute the file on the path
#
### RESTORING ###
#
# Restoring databases from backups can be done through the management console
# Right click on the DB you wish to restore > tasks > restore
# The server will need to be in single user mode, link to instructions below.
# https://www.sqlservergeeks.com/start-sql-server-in-single-user-mode-command-prompt/
# Additional info at link below
# https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/start-sql-server-in-single-user-mode?view=sql-server-2017
#
### END ###

$VarServerInstance = "PRINTER-SHARE\SQLEXPRESS"
$DBArray = @("master", "model", "msdb")
$FilePath = "C:\sql_backup\backups"
$Daysback = "-90"
$CurrentDate = Get-Date
$DatetoDelete = $CurrentDate.AddDays($Daysback)

foreach ($DBName in $DBArray) {
    Backup-SqlDatabase -ServerInstance $VarServerInstance -Database $DBName -BackupFile "$FilePath\$DBName--$(get-date -f MM-dd-yy).bak"
}

Get-ChildItem $FilePath | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item

