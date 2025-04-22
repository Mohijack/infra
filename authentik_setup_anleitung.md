# Authentik Initial Setup Anleitung

Diese Anleitung führt Sie durch den Prozess der Ersteinrichtung von Authentik nach dem Zurücksetzen der Datenbank.

## Voraussetzungen

- Authentik wurde mit dem `reset_authentik.sh`-Skript zurückgesetzt und neu gestartet
- Alle Dienste sind vollständig hochgefahren (warten Sie etwa 1-2 Minuten nach dem Neustart)

## Schritt 1: Zugriff auf die Ersteinrichtungs-URL

Öffnen Sie einen Webbrowser und navigieren Sie zu einer der folgenden URLs:

- `http://192.168.200.84:9001/if/flow/initial-setup/`
- `https://auth.dasilvafelix.de/if/flow/initial-setup/`

**WICHTIG**: Achten Sie darauf, dass die URL mit einem Schrägstrich (/) endet, sonst erhalten Sie einen "Not Found"-Fehler.

## Schritt 2: Erstellen eines Admin-Benutzers

Auf der Ersteinrichtungsseite werden Sie aufgefordert, einen Admin-Benutzer zu erstellen:

1. Geben Sie einen Benutzernamen ein (standardmäßig `akadmin`, Sie können diesen aber ändern)
2. Geben Sie eine E-Mail-Adresse ein (z.B. `admin@dasilvafelix.de`)
3. Setzen Sie ein sicheres Passwort (verwenden Sie ein starkes Passwort, das Sie sich merken können)
4. Bestätigen Sie das Passwort
5. Klicken Sie auf "Erstellen"

## Schritt 3: Anmeldung

Nach der Erstellung des Admin-Benutzers werden Sie automatisch zur Anmeldeseite weitergeleitet:

1. Geben Sie den Benutzernamen ein, den Sie gerade erstellt haben
2. Geben Sie das Passwort ein, das Sie gerade festgelegt haben
3. Klicken Sie auf "Anmelden"

## Schritt 4: Konfiguration von Authentik

Nach der erfolgreichen Anmeldung können Sie Authentik nach Ihren Bedürfnissen konfigurieren:

1. Erstellen Sie weitere Benutzer
2. Konfigurieren Sie Anwendungen
3. Richten Sie Authentifizierungsquellen ein
4. Passen Sie Flows und Stages an

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
