# PowerShell-Skript zum Zurücksetzen von Authentik
# Dieses Skript muss auf dem Portainer-Host ausgeführt werden

# Stack-Name (passen Sie diesen an Ihre Konfiguration an)
$STACK_NAME = "infra_full_stack"

# Stoppen Sie den Stack
Write-Host "Stoppe den Stack $STACK_NAME..."
docker stack rm $STACK_NAME

# Warten Sie, bis der Stack vollständig gestoppt ist
Write-Host "Warte, bis der Stack vollständig gestoppt ist..."
Start-Sleep -Seconds 30

# Löschen Sie das Datenbank-Volume
Write-Host "Lösche das Datenbank-Volume..."
docker volume rm ${STACK_NAME}_db_data

# Starten Sie den Stack neu
Write-Host "Starte den Stack neu..."
cd /path/to/your/stack/directory  # Passen Sie diesen Pfad an
docker stack deploy -c docker-compose.yml $STACK_NAME

Write-Host "Fertig! Authentik wurde zurückgesetzt und neu gestartet."
Write-Host "Sie können sich jetzt mit den folgenden Anmeldedaten anmelden:"
Write-Host "URL: https://auth.dasilvafelix.de"
Write-Host "Benutzername: admin"
Write-Host "Passwort: Admin123456"
