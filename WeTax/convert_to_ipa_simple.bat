@echo off
chcp 65001 >nul
echo ========================================
echo Простая конвертация .xcarchive в IPA
echo ========================================
echo.

REM Если файл/папка перетащена на bat, используем его путь
if "%~1"=="" (
    set "ARCHIVE_PATH=%~dp0WeTax.xcarchive"
) else (
    set "ARCHIVE_PATH=%~1"
)

REM Убираем кавычки если есть
set "ARCHIVE_PATH=%ARCHIVE_PATH:"=%"

REM Проверяем существование (может быть папка или файл)
if not exist "%ARCHIVE_PATH%" (
    echo Ошибка: Файл/папка не найдена!
    echo Ожидается: %ARCHIVE_PATH%
    echo.
    echo Перетащите .xcarchive папку на этот bat-файл
    echo или поместите WeTax.xcarchive в ту же папку
    echo.
    pause
    exit /b 1
)

set "EXPORT_PATH=%~dp0export"
set "APP_PATH="

REM Проверяем, это папка или файл
if exist "%ARCHIVE_PATH%\Products\Applications\WeTax.app" (
    REM Это уже распакованная папка .xcarchive
    set "APP_PATH=%ARCHIVE_PATH%\Products\Applications\WeTax.app"
    echo Найден .xcarchive папка, используем напрямую...
) else if exist "%ARCHIVE_PATH%\WeTax.app" (
    REM Это уже .app файл
    set "APP_PATH=%ARCHIVE_PATH%\WeTax.app"
    echo Найден .app файл...
) else (
    REM Пробуем распаковать как ZIP
    echo Попытка распаковки как ZIP...
    set "TEMP_PATH=%~dp0temp"
    if exist "%TEMP_PATH%" rmdir /s /q "%TEMP_PATH%"
    mkdir "%TEMP_PATH%"
    
    powershell -Command "try { Expand-Archive -Path '%ARCHIVE_PATH%' -DestinationPath '%TEMP_PATH%' -Force } catch { Write-Host 'Ошибка распаковки' }"
    
    if exist "%TEMP_PATH%\Products\Applications\WeTax.app" (
        set "APP_PATH=%TEMP_PATH%\Products\Applications\WeTax.app"
    ) else if exist "%TEMP_PATH%\WeTax.xcarchive\Products\Applications\WeTax.app" (
        set "APP_PATH=%TEMP_PATH%\WeTax.xcarchive\Products\Applications\WeTax.app"
    ) else (
        echo Ошибка: Не найден WeTax.app в архиве
        echo Проверьте структуру: должен быть Products\Applications\WeTax.app
        if exist "%TEMP_PATH%" rmdir /s /q "%TEMP_PATH%"
        pause
        exit /b 1
    )
)

REM Проверяем что .app найден
if not exist "%APP_PATH%" (
    echo Ошибка: WeTax.app не найден по пути: %APP_PATH%
    pause
    exit /b 1
)

echo Создание IPA...
if exist "%EXPORT_PATH%" rmdir /s /q "%EXPORT_PATH%"
mkdir "%EXPORT_PATH%\Payload"

echo Копирование WeTax.app в Payload...
xcopy /E /I /Y "%APP_PATH%" "%EXPORT_PATH%\Payload\WeTax.app\" >nul

if not exist "%EXPORT_PATH%\Payload\WeTax.app" (
    echo Ошибка: Не удалось скопировать .app файл
    pause
    exit /b 1
)

echo Архивирование в IPA...
cd /d "%EXPORT_PATH%"
powershell -Command "Compress-Archive -Path 'Payload' -DestinationPath 'WeTax.zip' -Force"
if exist "WeTax.zip" (
    ren "WeTax.zip" "WeTax.ipa"
)

cd /d "%~dp0"
if exist "%TEMP_PATH%" rmdir /s /q "%TEMP_PATH%"

if exist "%EXPORT_PATH%\WeTax.ipa" (
    echo.
    echo ========================================
    echo ✅ IPA успешно создан!
    echo ========================================
    echo.
    echo Файл: %EXPORT_PATH%\WeTax.ipa
    echo.
    echo Теперь используйте Sideloadly или AltStore для установки!
    echo.
) else (
    echo.
    echo ❌ Ошибка: IPA не был создан
    echo.
)

pause

