#!/bin/bash
# Скрипт восстановления базы данных PostgreSQL из резервной копии
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/../backups"

FILE_PATH="$1"

if [ -z "$FILE_PATH" ]; then
    FILE_PATH=$(ls -t "$BACKUP_DIR"/*.sql 2>/dev/null | head -n 1)
    if [ -z "$FILE_PATH" ]; then
        if [ -f "$SCRIPT_DIR/../music_platform_dump.sql" ]; then
            FILE_PATH="$SCRIPT_DIR/../music_platform_dump.sql"
        else
            echo "==> Резервные копии не найдены!"
            exit 1
        fi
    fi
fi

echo "==> Восстановление базы данных из: $FILE_PATH"
cat "$FILE_PATH" | docker compose exec -T db psql -U postgres -d music_platform

if [ $? -eq 0 ]; then
    echo "==> База данных успешно восстановлена!"
else
    echo "==> Ошибка восстановления базы данных!"
fi
