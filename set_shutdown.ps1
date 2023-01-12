# This has to run with administrator priviliges
# This code can be easily modified for other power states. For further info see: https://powershell.one/wmi/root/cimv2/win32_powermanagementevent

$config = Get-Content "settings.ini" | ConvertFrom-StringData

$query = "SELECT EventType FROM Win32_PowerManagementEvent"
$eventWatcher = New-Object System.Management.ManagementEventWatcher($query)

$__var = 1
while ($__var -ne 0) {
    $event = $eventWatcher.waitForNextEvent()
    
    # System goes to sleep
    if ($event."EventType" -eq 4) {
        $time = New-ScheduledTaskTrigger -Once -At ((Get-Date).AddMinutes($config.Delay))
        Set-ScheduledTask -TaskName $config.TaskName -Trigger $time
        Enable-ScheduledTask -TaskName $config.TaskName
    }

    # System wakes up
    elseif ($event."EventType" -eq 7) {
        Disable-ScheduledTask -TaskName $config.TaskName
    }
}
