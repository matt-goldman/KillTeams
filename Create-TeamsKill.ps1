# Define the batch file content and path
$batchContent = @"
taskkill /IM Teams.exe /F
"@
$batchFilePath = "$env:APPDATA\close_app.bat"

# Create the batch file
Set-Content -Path $batchFilePath -Value $batchContent

# Create the scheduled task
$action = New-ScheduledTaskAction -Execute $batchFilePath
$trigger = New-ScheduledTaskTrigger -At 6PM -DaysOfWeek Monday, Tuesday, Wednesday, Thursday, Friday

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if ($isAdmin) {
    # Register the task with elevated privileges
    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "CloseAppTask" -Description "Closes example app every weekday at 9 PM"
} else {
    # Register the task without elevated privileges (user-specific)
    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "CloseAppTask" -Description "Closes example app every weekday at 9 PM" -User "$env:USERNAME" -LogonType Interactive
}
