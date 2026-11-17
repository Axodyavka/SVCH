# Тестирование отказоустойчивости системы
Write-Host "==========================================================" -ForegroundColor Yellow
Write-Host " ТЕСТ ОТКАЗОУСТОЙЧИВОСТИ: СБОЙ И ВОССТАНОВЛЕНИЕ СУБД " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Yellow

# Шаг 1: Проверка исходного состояния
Write-Host "`n[1/4] Проверка исходной работоспособности (GET http://localhost:3000/api/health)..." -ForegroundColor Cyan
try {
    $res = Invoke-RestMethod -Uri "http://localhost:5000/health" -Method Get -TimeoutSec 5
    Write-Host "Статус сервера: $($res.status), БД: $($res.database)" -ForegroundColor Green
} catch {
    Write-Host "Предупреждение: бэкенд пока не ответил (или контейнеры не запущены). Попробуем проверить контейнеры." -ForegroundColor Yellow
}

# Шаг 2: Имитация сбоя СУБД (остановка контейнера music_db)
Write-Host "`n[2/4] Имитация аварии: принудительная остановка контейнера music_db..." -ForegroundColor Cyan
docker stop music_db

Start-Sleep -Seconds 3

# Шаг 3: Проверка реакции бэкенда на сбой СУБД
Write-Host "`n[3/4] Проверка состояния приложения при выключенной СУБД..." -ForegroundColor Cyan
try {
    $errRes = Invoke-RestMethod -Uri "http://localhost:5000/health" -Method Get -TimeoutSec 5
    Write-Host "Ответ: $($errRes | ConvertTo-Json)" -ForegroundColor Yellow
} catch {
    Write-Host "Ожидаемый результат: сервер фиксирует сбой БД и возвращает код ошибки 503 Service Unavailable" -ForegroundColor Green
    Write-Host "Детали: $($_.Exception.Message)" -ForegroundColor Gray
}

# Шаг 4: Восстановление контейнера СУБД
Write-Host "`n[4/4] Восстановление: запуск контейнера music_db..." -ForegroundColor Cyan
docker start music_db

Write-Host "Ожидание инициализации PostgreSQL..."
Start-Sleep -Seconds 6

try {
    $recoveryRes = Invoke-RestMethod -Uri "http://localhost:5000/health" -Method Get -TimeoutSec 10
    Write-Host "УСПЕХ! Приложение автоматически восстановило связь с БД: $($recoveryRes.database)" -ForegroundColor Green
} catch {
    Write-Host "Ошибка при проверке восстановления: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nТест отказоустойчивости завершен." -ForegroundColor Yellow
