# Скрипт восстановления базы данных PostgreSQL из резервной копии
param (
    [string]$FilePath
)

$BackupDir = Join-Path $PSScriptRoot "..\backups"

if (-not $FilePath) {
    # Берем последний бэкап
    $LatestBackup = Get-ChildItem -Path $BackupDir -Filter "*.sql" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if (-not $LatestBackup) {
        # Если в папке backups пусто, проверяем наличие root dump файла
        $RootDump = Join-Path $PSScriptRoot "..\music_platform_dump.sql"
        if (Test-Path $RootDump) {
            $FilePath = $RootDump
        } else {
            Write-Host "==> Файлы резервных копий не найдены!" -ForegroundColor Red
            exit 1
        }
    } else {
        $FilePath = $LatestBackup.FullName
    }
}

Write-Host "==> Восстановление базы данных из файла:" -ForegroundColor Cyan
Write-Host "    $FilePath"

Get-Content $FilePath -Raw | docker compose exec -T db psql -U postgres -d music_platform

if ($LASTEXITCODE -eq 0) {
    Write-Host "==> База данных успешно восстановлена!" -ForegroundColor Green
} else {
    Write-Host "==> Ошибка восстановления базы данных!" -ForegroundColor Red
}
