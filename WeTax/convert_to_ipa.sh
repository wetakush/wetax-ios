#!/bin/bash
# Скрипт для конвертации .xcarchive в IPA
# Использование: ./convert_to_ipa.sh path/to/WeTax.xcarchive

if [ -z "$1" ]; then
    echo "Использование: ./convert_to_ipa.sh path/to/WeTax.xcarchive"
    exit 1
fi

ARCHIVE_PATH="$1"
EXPORT_PATH="./export"
EXPORT_OPTIONS="./ExportOptions.plist"

# Проверяем наличие архива
if [ ! -d "$ARCHIVE_PATH" ]; then
    echo "Ошибка: Архив не найден: $ARCHIVE_PATH"
    exit 1
fi

# Создаем директорию для экспорта
mkdir -p "$EXPORT_PATH"

# Экспортируем IPA
echo "Экспортирую IPA из архива..."
xcodebuild -exportArchive \
    -archivePath "$ARCHIVE_PATH" \
    -exportPath "$EXPORT_PATH" \
    -exportOptionsPlist "$EXPORT_OPTIONS"

if [ $? -eq 0 ]; then
    echo "✅ IPA успешно создан в: $EXPORT_PATH/WeTax.ipa"
else
    echo "❌ Ошибка при экспорте IPA"
    exit 1
fi

