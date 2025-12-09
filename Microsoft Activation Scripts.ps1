# Задаване на UTF-8 кодировка за PowerShell
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

$url = "https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/master/MAS/All-In-One-Version/MAS_AIO.cmd"
$tempFile = "$env:TEMP\MAS_AIO.cmd"

Invoke-WebRequest -Uri $url -OutFile $tempFile -UseBasicParsing

# Стартиране с правилна кодировка
$processInfo = New-Object System.Diagnostics.ProcessStartInfo
$processInfo.FileName = "cmd.exe"
$processInfo.Arguments = "/c chcp 65001 && `"$tempFile`""
$processInfo.UseShellExecute = $false
[System.Diagnostics.Process]::Start($processInfo)
