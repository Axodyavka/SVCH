# Тестирование сетевой изоляции и межконтейнерного взаимодействия
Write-Host "==========================================================" -ForegroundColor Yellow
Write-Host " ТЕСТ СЕТЕВОГО ВЗАИМОДЕЙСТВИЯ И ИЗОЛЯЦИИ " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Yellow

# Проверка 1: Доступность порта 5432 с хост-машины (должен быть закрыт)
Write-Host "`n[1/2] Проверка изоляции СУБД с хост-машины (порт 5432)..." -ForegroundColor Cyan
$tcpClient = New-Object System.Net.Sockets.TcpClient
$asyncResult = $tcpClient.BeginConnect("127.0.0.1", 5432, $null, $null)
$success = $asyncResult.AsyncWaitHandle.WaitOne(2000, $false)

if ($success -and $tcpClient.Connected) {
    $tcpClient.EndConnect($asyncResult)
    $tcpClient.Close()
    Write-Host "ВНИМАНИЕ: Порт 5432 доступен с хоста. Изоляция не абсолютна." -ForegroundColor Red
} else {
    Write-Host "УСПЕХ: Порт 5432 НЕДОСТУПЕН с хост-машины (прямой доступ заблокирован, порт не проброшен)." -ForegroundColor Green
}

# Проверка 2: Внутреннее сетевое взаимодействие между контейнерами
Write-Host "`n[2/2] Проверка внутреннего DNS и связи backend -> db внутри bridge-сети..." -ForegroundColor Cyan
$dockerExecResult = docker compose exec backend ping -c 2 db 2>&1
if ($LASTEXITCODE -eq 0 -or $dockerExecResult -match "bytes from") {
    Write-Host "УСПЕХ: Контейнер backend успешно видит контейнер db по DNS-имени сервиса 'db'." -ForegroundColor Green
} else {
    # Попробуем через nc/curl/node проверку
    $dbCheck = docker compose exec backend node -e "
    const net = require('net');
    const s = net.createConnection({host: 'db', port: 5432}, () => {
        console.log('CONNECTED_TO_DB_SUCCESS');
        process.exit(0);
    });
    s.on('error', (e) => { console.error(e); process.exit(1); });
    " 2>&1
    if ($dbCheck -match "CONNECTED_TO_DB_SUCCESS") {
        Write-Host "УСПЕХ: Контейнер backend успешно подключился к db:5432 внутри Docker-сети." -ForegroundColor Green
    } else {
        Write-Host "Вывод: $dbCheck" -ForegroundColor Gray
    }
}

Write-Host "`nТест сетевой изоляции завершен." -ForegroundColor Yellow
