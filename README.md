# Infrastruktur-Stack mit Traefik, Authentik und DNS

Diese Konfiguration ermöglicht die Bereitstellung einer kompletten Infrastruktur mit Traefik als Reverse Proxy, Authentik für die Authentifizierung und dnsmasq für lokale DNS-Auflösung in einer Portainer-Umgebung auf Proxmox.

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

Passen Sie die DNS-Konfiguration in der `dnsmasq.conf`-Datei an:

```
# Statische DNS-Einträge für lokale Dienste
address=/traefik.dasilvafelix.de/192.168.120.84
address=/auth.dasilvafelix.de/192.168.120.84
address=/dns.dasilvafelix.de/192.168.120.84
```

### 3. Starten des Stacks in Portainer

1. Laden Sie die Dateien in Ihr Portainer-Verzeichnis hoch:
   - docker-compose.yml
   - .env
   - dnsmasq.conf

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
