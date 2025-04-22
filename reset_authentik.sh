#!/bin/bash
# Shell-Skript zum Zurücksetzen von Authentik

# Stack-Name (passen Sie diesen an Ihre Konfiguration an)
STACK_NAME="infra_full_stack"

# Stoppen Sie den Stack
echo "Stoppe den Stack $STACK_NAME..."
docker-compose down

# Löschen Sie alle Authentik-bezogenen Volumes
echo "Lösche die Authentik-Volumes..."
docker volume rm ${STACK_NAME}_db_data
docker volume rm ${STACK_NAME}_authentik_media
docker volume rm ${STACK_NAME}_authentik_custom_templates

# Starten Sie den Stack neu
echo "Starte den Stack neu..."
docker-compose up -d

# Lese Umgebungsvariablen aus der .env-Datei
source .env

echo "Fertig! Authentik wurde zurückgesetzt und neu gestartet."
echo ""
echo "WICHTIG: Warten Sie etwa 1-2 Minuten, bis alle Dienste vollständig gestartet sind."
echo ""
echo "Anmeldedaten für Authentik:"
echo "URL: https://auth.${DOMAIN}"
echo "Benutzername: ${AUTHENTIK_BOOTSTRAP_USERNAME}"
echo "Passwort: ${AUTHENTIK_BOOTSTRAP_PASSWORD}"
echo ""
echo "Falls die automatische Anmeldung nicht funktioniert, navigieren Sie zur Ersteinrichtungs-URL:"
echo "http://192.168.200.84:9001/if/flow/initial-setup/"
echo "oder"
echo "https://auth.${DOMAIN}/if/flow/initial-setup/"
echo ""
echo "HINWEIS: Achten Sie darauf, dass die URL mit einem Schrägstrich (/) endet,"
echo "         sonst erhalten Sie einen 'Not Found'-Fehler."
