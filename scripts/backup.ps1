# Скрипт создания резервной копии базы данных PostgreSQL
$BackupDir = Join-Path $PSScriptRoot "..\backups"
if (-not (Test-Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir | Out-Null
}

$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$BackupFile = Join-Path $BackupDir "backup_$Timestamp.sql"

Write-Host "==> Создание резервной копии БД music_platform..." -ForegroundColor Cyan

docker compose exec -T db pg_dump -U postgres -d music_platform --clean --if-exists > $BackupFile

if ($LASTEXITCODE -eq 0) {
    Write-Host "==> Резервная копия успешно создана:" -ForegroundColor Green
    Write-Host "    $BackupFile"
} else {
    Write-Host "==> Ошибка создания резервной копии!" -ForegroundColor Red
}
