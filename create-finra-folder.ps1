# PowerShell-Skript: create-infra-folders.ps1
# Erstellt die Ordnerstruktur & alle Konfigdateien für vollständigen Stack mit .env-Unterstützung

$root = "infra"

# Ordnerstruktur
$folders = @(
    "$root/bind9/config",
    "$root/bind9/zones",
    "$root/bind9/cache",
    "$root/traefik",
    "$root/volumes"
)

foreach ($folder in $folders) {
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
    }
}

# Datei: named.conf
@'
include "/etc/bind/named.conf.options";
include "/etc/bind/named.conf.local";
'@ | Set-Content "$root/bind9/config/named.conf"

# Datei: named.conf.options
@'
options {
    directory "/var/cache/bind";
    listen-on port 53 { any; };
    listen-on-v6 { none; };
    allow-query { any; };
    recursion yes;
    dnssec-validation auto;
    auth-nxdomain no;
    minimal-responses yes;
};
'@ | Set-Content "$root/bind9/config/named.conf.options"

# Datei: named.conf.local
@'
zone "internal" IN {
    type master;
    file "/var/lib/bind/db.internal";
};
'@ | Set-Content "$root/bind9/config/named.conf.local"

# Datei: db.internal
@'
$TTL 86400
@   IN  SOA ns.internal. admin.internal. (
        2025042101 ; Serial
        3600       ; Refresh
        1800       ; Retry
        604800     ; Expire
        86400 )    ; Minimum TTL

@       IN  NS      ns.internal.
ns      IN  A       127.0.0.1
www     IN  A       192.168.100.10
auth    IN  A       192.168.100.20
'@ | Set-Content "$root/bind9/zones/db.internal"

# Datei: acme.json mit korrekten Rechten (leere Datei, Traefik füllt selbst)
$acmePath = "$root/traefik/acme.json"
if (-not (Test-Path $acmePath)) {
    New-Item -ItemType File -Path $acmePath -Force | Out-Null
}
# Windows unterstützt chmod nicht direkt, aber Traefik kann schreiben, solange Volume stimmt

# docker-compose Datei mit ENV-Variablen
@'
version: "3.8"

services:
  bind9:
    image: internetsystemsconsortium/bind9:9.18
    container_name: bind9
    command: -g -c /etc/bind/named.conf
    volumes:
      - ./bind9/config:/etc/bind
      - ./bind9/zones:/var/lib/bind
      - ./bind9/cache:/var/cache/bind
    ports:
      - "1053:53/udp"
      - "1053:53/tcp"

  traefik:
    image: traefik:latest
    container_name: traefik
    command:
      - --api.dashboard=true
      - --entrypoints.web.address=:80
      - --entrypoints.websecure.address=:443
      - --providers.docker=true
      - --certificatesresolvers.cloudflare.acme.dnschallenge=true
      - --certificatesresolvers.cloudflare.acme.dnschallenge.provider=cloudflare
      - --certificatesresolvers.cloudflare.acme.email=${EMAIL}
      - --certificatesresolvers.cloudflare.acme.storage=/letsencrypt/acme.json
    environment:
      - CF_API_EMAIL=${CF_API_EMAIL}
      - CF_DNS_API_TOKEN=${CLOUDFLARE_API_TOKEN}
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./traefik/acme.json:/letsencrypt/acme.json
    networks:
      - internal

  db:
    image: postgres:15
    container_name: authentik-db
    restart: unless-stopped
    environment:
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: ${POSTGRES_DB}
    volumes:
      - db_data:/var/lib/postgresql/data
    networks:
      - internal

  authentik:
    image: ghcr.io/goauthentik/server:latest
    container_name: authentik
    depends_on:
      - db
    environment:
      AUTHENTIK_SECRET_KEY: ${AUTHENTIK_SECRET_KEY}
      DATABASE_URL: postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@db:5432/${POSTGRES_DB}
      AUTHENTIK_EMAIL__HOST: ${SMTP_HOST}
      AUTHENTIK_EMAIL__PORT: ${SMTP_PORT}
      AUTHENTIK_EMAIL__USERNAME: ${SMTP_USER}
      AUTHENTIK_EMAIL__PASSWORD: ${SMTP_PASSWORD}
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.authentik.rule=Host(`auth.${DOMAIN}`)"
      - "traefik.http.routers.authentik.entrypoints=websecure"
      - "traefik.http.routers.authentik.tls.certresolver=cloudflare"
    networks:
      - internal

  authentik-worker:
    image: ghcr.io/goauthentik/server:latest
    container_name: authentik-worker
    command: worker
    depends_on:
      - db
    environment:
      AUTHENTIK_SECRET_KEY: ${AUTHENTIK_SECRET_KEY}
      DATABASE_URL: postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@db:5432/${POSTGRES_DB}
    networks:
      - internal

networks:
  internal:
    driver: bridge

volumes:
  db_data:
'@ | Set-Content "$root/docker-compose.yml"

# Datei: .env.example
@'
EMAIL=your-email@example.com
CLOUDFLARE_API_TOKEN=your-cloudflare-api-token
CF_API_EMAIL=your-cloudflare-email

DOMAIN=example.com

POSTGRES_USER=authentik
POSTGRES_PASSWORD=authentikpass
POSTGRES_DB=authentik

AUTHENTIK_SECRET_KEY=supersecretkey
SMTP_HOST=smtp.example.com
SMTP_PORT=587
SMTP_USER=mail@example.com
SMTP_PASSWORD=mailpassword
'@ | Set-Content "$root/.env.example"

Write-Host "✅ Kompletter Infrastrukturstack inkl. .env-Unterstützung erstellt unter: $root" -ForegroundColor Green
