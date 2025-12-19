@echo off
chcp 65001 >nul
echo ========================================
echo Конвертация .xcarchive в IPA для WeTax
echo ========================================
echo.

REM Проверяем наличие архива
if "%~1"=="" (
    echo Использование: convert_to_ipa.bat путь\к\WeTax.xcarchive
    echo.
    echo Или перетащите .xcarchive файл на этот bat-файл
    echo.
    pause
    exit /b 1
)

set "ARCHIVE_PATH=%~1"
set "EXPORT_PATH=%~dp0export"
set "TEMP_PATH=%~dp0temp_ipa"

REM Проверяем существование архива
if not exist "%ARCHIVE_PATH%" (
    echo Ошибка: Архив не найден: %ARCHIVE_PATH%
    pause
    exit /b 1
)

echo [1/5] Подготовка...
if exist "%EXPORT_PATH%" rmdir /s /q "%EXPORT_PATH%"
if exist "%TEMP_PATH%" rmdir /s /q "%TEMP_PATH%"
mkdir "%EXPORT_PATH%"
mkdir "%TEMP_PATH%"

echo [2/5] Распаковка .xcarchive...
REM .xcarchive это ZIP архив, распаковываем его
cd /d "%TEMP_PATH%"
powershell -Command "Expand-Archive -Path '%ARCHIVE_PATH%' -DestinationPath '%TEMP_PATH%\extracted' -Force"

if not exist "%TEMP_PATH%\extracted\Products\Applications\WeTax.app" (
    echo Ошибка: Не найден WeTax.app в архиве
    echo Проверьте структуру архива
    pause
    exit /b 1
)

echo [3/5] Создание структуры IPA...
REM Создаем папку Payload
mkdir "%TEMP_PATH%\Payload"

REM Копируем .app в Payload
xcopy /E /I /Y "%TEMP_PATH%\extracted\Products\Applications\WeTax.app" "%TEMP_PATH%\Payload\WeTax.app"

echo [4/5] Создание IPA файла...
REM Архивируем Payload в ZIP и переименовываем в IPA
cd /d "%TEMP_PATH%"
powershell -Command "Compress-Archive -Path 'Payload' -DestinationPath '%EXPORT_PATH%\WeTax.zip' -Force"
if exist "%EXPORT_PATH%\WeTax.zip" (
    ren "%EXPORT_PATH%\WeTax.zip" "WeTax.ipa"
)

echo [5/5] Очистка временных файлов...
cd /d "%~dp0"
rmdir /s /q "%TEMP_PATH%"

echo.
echo ========================================
echo ✅ Готово!
echo ========================================
echo.
echo IPA файл создан: %EXPORT_PATH%\WeTax.ipa
echo.
echo ⚠️  ВАЖНО: Этот IPA не подписан!
echo Для установки используйте:
echo   - Sideloadly (автоматически подпишет)
echo   - AltStore (автоматически подпишет)
echo   - Или подпишите вручную через Xcode
echo.
pause

