# PowerShell-Skript zum Erstellen eines Admin-Benutzers in Authentik
# Dieses Skript muss auf dem Portainer-Host ausgeführt werden

# Stack-Name (passen Sie diesen an Ihre Konfiguration an)
$STACK_NAME = "infra_full_stack"

# Admin-Benutzer-Anmeldedaten
$ADMIN_USERNAME = "admin"
$ADMIN_PASSWORD = "password"
$ADMIN_EMAIL = "admin@dasilvafelix.de"

Write-Host "Erstelle Admin-Benutzer in Authentik..."

# Führen Sie den Befehl im Authentik-Container aus
docker exec -it authentik python -m authentik bootstrap --token supersecretkey --user $ADMIN_USERNAME --password $ADMIN_PASSWORD --email $ADMIN_EMAIL --name "Admin User" --superuser

Write-Host "Fertig! Der Admin-Benutzer wurde erstellt."
Write-Host "Sie können sich jetzt mit den folgenden Anmeldedaten anmelden:"
Write-Host "URL: https://auth.dasilvafelix.de"
Write-Host "Benutzername: $ADMIN_USERNAME"
Write-Host "Passwort: $ADMIN_PASSWORD"
