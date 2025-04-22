# Automatische Zertifikatsverwaltung mit Traefik und Bind9

Diese Konfiguration ermöglicht die automatische Erstellung und Verwaltung von TLS-Zertifikaten für lokale Domains mit Traefik und Bind9 in einer Portainer-Umgebung auf Proxmox.

## Voraussetzungen

- Portainer auf Proxmox (IP: 192.168.120.84)
- Docker und Docker Compose

## Einrichtung

### 1. Anpassen der Konfiguration

Passen Sie die Konfiguration in der `.env`-Datei an:

```
# Bind9-Konfiguration für lokale Zertifikate
BIND_KEY_NAME=bind-key
BIND_KEY_SECRET=your-key-secret
```

Stellen Sie sicher, dass Sie ein sicheres Geheimnis für `BIND_KEY_SECRET` verwenden.

### 2. Starten des Stacks in Portainer

1. Laden Sie die Dateien in Ihr Portainer-Verzeichnis hoch:
   - docker-compose.yml
   - .env

2. Starten Sie den Stack in Portainer:
   - Gehen Sie zu "Stacks" in Portainer
   - Klicken Sie auf "Add stack"
   - Wählen Sie "Upload" und laden Sie die docker-compose.yml hoch
   - Klicken Sie auf "Deploy the stack"

## Verwendung

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
