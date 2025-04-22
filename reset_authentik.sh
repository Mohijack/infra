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

echo "Fertig! Authentik wurde zurückgesetzt und neu gestartet."
echo "Navigieren Sie zur Ersteinrichtungs-URL, um den akadmin-Benutzer zu konfigurieren:"
echo "http://192.168.200.84:9001/if/flow/initial-setup/"
echo "oder"
echo "https://auth.dasilvafelix.de/if/flow/initial-setup/"
