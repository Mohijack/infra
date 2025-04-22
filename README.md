# Infrastruktur-Stack mit Traefik, Authentik und DNS

Diese Konfiguration ermöglicht die Bereitstellung einer kompletten Infrastruktur mit Traefik als Reverse Proxy, Authentik für die Authentifizierung und einem DNS-Server mit Weboberfläche für lokale DNS-Auflösung in einer Portainer-Umgebung auf Proxmox.

## Voraussetzungen

- Portainer auf Proxmox (IP: 192.168.120.84)
- Docker und Docker Compose
- Cloudflare-Konto für die Zertifikatsverwaltung

## Einrichtung

### 1. Anpassen der Konfiguration

Passen Sie die Konfiguration in der `.env`-Datei an:

```
# Cloudflare-Konfiguration
EMAIL=admin@dasilvafelix.de
CLOUDFLARE_API_TOKEN=your-cloudflare-api-token
CF_API_EMAIL=your-cloudflare-email

# Domain-Konfiguration
DOMAIN=dasilvafelix.de
SERVER_IP=192.168.120.84
```

### 2. Anpassen der DNS-Konfiguration

Die DNS-Konfiguration ist bereits in der Docker-Compose-Datei enthalten und verwendet die Umgebungsvariablen aus der `.env`-Datei. Sie können bei Bedarf weitere DNS-Einträge in der `DNSMASQ_OPTS`-Umgebungsvariable des DNS-Containers hinzufügen:

```yaml
environment:
  - TZ=Europe/Berlin
  - DNSMASQ_OPTS=--log-queries --log-facility=- --cache-size=1000 --server=8.8.8.8 --server=8.8.4.4 --address=/traefik.${DOMAIN}/${SERVER_IP} --address=/auth.${DOMAIN}/${SERVER_IP} --address=/dns.${DOMAIN}/${SERVER_IP}
  # Fügen Sie hier weitere Optionen hinzu
  # z.B. --address=/neuer-dienst.${DOMAIN}/${SERVER_IP}
```

Der DNS-Server bietet auch eine Weboberfläche, die unter `https://dns.dasilvafelix.de/` erreichbar ist und die Verwaltung der DNS-Einträge ermöglicht.

### 3. Starten des Stacks in Portainer

1. Laden Sie die Dateien in Ihr Portainer-Verzeichnis hoch:
   - docker-compose.yml
   - .env

2. Starten Sie den Stack in Portainer:
   - Gehen Sie zu "Stacks" in Portainer
   - Klicken Sie auf "Add stack"
   - Wählen Sie "Upload" und laden Sie die docker-compose.yml hoch
   - Klicken Sie auf "Deploy the stack"

## Verwendung

### Verfügbare Dienste

Nach dem erfolgreichen Deployment des Stacks stehen folgende Dienste zur Verfügung:

- **Traefik Dashboard**: `https://traefik.dasilvafelix.de/dashboard/`
  - Zeigt den Status aller Dienste und Routen an
  - Ermöglicht die Überwachung der Zertifikate

- **Authentik**: `https://auth.dasilvafelix.de/`
  - Zentraler Authentifizierungsdienst
  - Anmeldung mit den in der `.env`-Datei konfigurierten Anmeldedaten

- **DNS-Verwaltung**: `https://dns.dasilvafelix.de/`
  - Weboberfläche zur Verwaltung der DNS-Einträge
  - Zeigt die aktuellen DNS-Einträge und Logs an

### Zertifikate für neue Dienste

Um Zertifikate für neue Dienste zu erstellen, fügen Sie folgende Labels hinzu:

```yaml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.myservice.rule=Host(`myservice.dasilvafelix.de`)"
  - "traefik.http.routers.myservice.entrypoints=websecure"
  - "traefik.http.routers.myservice.tls=true"
  - "traefik.http.routers.myservice.tls.certresolver=local"
```

### Überprüfen der Zertifikate

Sie können den Status der Zertifikate im Traefik-Dashboard überprüfen:

```
https://traefik.dasilvafelix.de/dashboard/
```

## Fehlerbehebung

### DNS-Challenge schlägt fehl

Überprüfen Sie die Logs von Traefik:

```bash
docker logs traefik
```

Überprüfen Sie, ob der DNS-Eintrag korrekt erstellt wurde:

```bash
dig @192.168.120.121 _acme-challenge.myservice.dasilvafelix.de TXT
```

### Zertifikat wird nicht erstellt

Überprüfen Sie die Logs von cert-manager:

```bash
docker logs cert-manager
```

### Bind9-Konfiguration überprüfen

Überprüfen Sie, ob Bind9 korrekt konfiguriert ist:

```bash
ssh root@192.168.120.121 "named-checkconf"
```

Überprüfen Sie die Zonendatei:

```bash
ssh root@192.168.120.121 "named-checkzone dasilvafelix.de /etc/bind/zones/db.dasilvafelix.de"
```
