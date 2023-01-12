$config = Get-Content "settings.ini" | ConvertFrom-StringData

$script_path = Join-Path -Path $PSScriptRoot -ChildPath $config.PSScriptName

# Common attributes
$principal = $principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest

# Settings on default contain some unnecessary settings, which may be unwanted for some (make sure you check them yourself in task manager and edit them to fit your use case)

# Registration of sleep shutdown script
$script_action = New-ScheduledTaskAction -Execute "C:\Windows\System32\shutdown.exe" -Argument "/s"
$script_settings = New-ScheduledTaskSettingsSet -WakeToRun
Register-ScheduledTask -TaskName $config.TaskName -Action $script_action -Settings $script_settings -Principal $principal

# Registration of its daemon
$deamon_trigger = New-ScheduledTaskTrigger -AtStartup
$daemon_action = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -Argument "-File $script_path"
Register-ScheduledTask -TaskName ("{0}Daemon" -f $config.TaskName) -Trigger $deamon_trigger -Action $daemon_action -Principal $principal
