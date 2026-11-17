#!/bin/bash
# Скрипт создания резервной копии базы данных PostgreSQL
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/../backups"
mkdir -p "$BACKUP_DIR"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/backup_${TIMESTAMP}.sql"

echo "==> Создание резервной копии БД music_platform..."
docker compose exec -T db pg_dump -U postgres -d music_platform --clean --if-exists > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "==> Резервная копия успешно создана: $BACKUP_FILE"
else
    echo "==> Ошибка создания резервной копии!"
fi
