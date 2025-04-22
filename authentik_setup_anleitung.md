# Authentik Setup Anleitung

Diese Anleitung führt Sie durch den Prozess der Einrichtung und Anmeldung bei Authentik nach dem Zurücksetzen der Datenbank.

## Voraussetzungen

- Authentik wurde mit dem `reset_authentik.sh`-Skript zurückgesetzt und neu gestartet
- Alle Dienste sind vollständig hochgefahren (warten Sie etwa 1-2 Minuten nach dem Neustart)

## Schritt 1: Anmeldung bei Authentik

Öffnen Sie einen Webbrowser und navigieren Sie zu:

- `https://auth.dasilvafelix.de`

Melden Sie sich mit den folgenden Anmeldedaten an:

- Benutzername: `admin` (oder der in der `.env`-Datei konfigurierte Wert für `AUTHENTIK_BOOTSTRAP_USERNAME`)
- Passwort: `Admin123456` (oder der in der `.env`-Datei konfigurierte Wert für `AUTHENTIK_BOOTSTRAP_PASSWORD`)

## Alternative: Manuelle Ersteinrichtung

Falls die automatische Anmeldung nicht funktioniert, können Sie die Ersteinrichtung manuell durchführen:

1. Öffnen Sie einen Webbrowser und navigieren Sie zu einer der folgenden URLs:
   - `http://192.168.200.84:9001/if/flow/initial-setup/`
   - `https://auth.dasilvafelix.de/if/flow/initial-setup/`

2. **WICHTIG**: Achten Sie darauf, dass die URL mit einem Schrägstrich (/) endet, sonst erhalten Sie einen "Not Found"-Fehler.

3. Auf der Ersteinrichtungsseite werden Sie aufgefordert, einen Admin-Benutzer zu erstellen:
   - Geben Sie einen Benutzernamen ein (z.B. `admin`)
   - Geben Sie eine E-Mail-Adresse ein (z.B. `admin@dasilvafelix.de`)
   - Setzen Sie ein sicheres Passwort
   - Bestätigen Sie das Passwort
   - Klicken Sie auf "Erstellen"

## Schritt 2: Konfiguration von Authentik

Nach der erfolgreichen Anmeldung können Sie Authentik nach Ihren Bedürfnissen konfigurieren:

1. Ändern Sie das Passwort des Admin-Benutzers (empfohlen)
2. Erstellen Sie weitere Benutzer
3. Konfigurieren Sie Anwendungen
4. Richten Sie Authentifizierungsquellen ein
5. Passen Sie Flows und Stages an

## Fehlerbehebung

Wenn Sie Probleme bei der Ersteinrichtung haben:

1. Stellen Sie sicher, dass die URL mit einem Schrägstrich (/) endet
2. Überprüfen Sie, ob alle Dienste ordnungsgemäß laufen: `docker-compose ps`
3. Überprüfen Sie die Logs auf Fehler: `docker-compose logs authentik`
4. Stellen Sie sicher, dass die Datenbank ordnungsgemäß initialisiert wurde: `docker-compose logs db`

### Spezifische Probleme

#### "Not Found"-Fehler

Wenn Sie einen "Not Found"-Fehler erhalten, stellen Sie sicher, dass die URL mit einem Schrägstrich (/) endet:
- Korrekt: `https://auth.dasilvafelix.de/if/flow/initial-setup/`
- Falsch: `https://auth.dasilvafelix.de/if/flow/initial-setup`

#### Dienste starten nicht

Wenn die Dienste nicht starten oder Fehler auftreten:

1. Überprüfen Sie die Logs: `docker-compose logs`
2. Stellen Sie sicher, dass alle erforderlichen Umgebungsvariablen in der `.env`-Datei korrekt gesetzt sind
3. Überprüfen Sie, ob die Ports nicht bereits von anderen Diensten verwendet werden

#### Datenbank-Fehler

Wenn Datenbankfehler auftreten:

1. Stellen Sie sicher, dass die Datenbank-Anmeldedaten in der `.env`-Datei korrekt sind
2. Überprüfen Sie, ob das Datenbank-Volume korrekt erstellt wurde
3. Versuchen Sie, das Datenbank-Volume zu löschen und den Stack neu zu starten

Bei anhaltenden Problemen können Sie das Zurücksetzen erneut durchführen und den Prozess wiederholen.
