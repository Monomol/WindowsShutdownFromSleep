# This has to run with administrator priviliges
# This code can be easily modified for other power states. For further info see: https://powershell.one/wmi/root/cimv2/win32_powermanagementevent

$query = "SELECT EventType FROM Win32_PowerManagementEvent"
$eventWatcher = New-Object System.Management.ManagementEventWatcher($query)

# Could be likely rewritten with Register-ObjectEvent
while ($true) {
    $PWevent = $eventWatcher.waitForNextEvent()

    # This ensures the newest version of config will be loaded. Make sure you don't change the TaskName in settings without clearing task scheduler and rerunning setup.ps1!
    $config = Get-Content (Join-Path -Path $PSScriptRoot -ChildPath "settings.ini") | Where-Object {$_ -notmatch ";"} | ConvertFrom-StringData

    # System goes to sleep
    if ($PWevent."EventType" -eq 4) {
        $time = New-ScheduledTaskTrigger -Once -At ((Get-Date).AddMinutes($config.Delay))
        Set-ScheduledTask -TaskName $config.TaskName -Trigger $time
        Enable-ScheduledTask -TaskName $config.TaskName
    }

    # System wakes up
    elseif ($PWevent."EventType" -eq 7) {
        Disable-ScheduledTask -TaskName $config.TaskName
    }
}
