# OTR - Online-TV-Recorder Tools
## Decode, Cut, Convert otrkey files to h264 für Playstation, iPhone, iPad, MacOS, Android

[English Version](README.md)

Docker Image mit allen Komponenten um otrkey Dateien von http://onlinetvrecorder.com zu bearbeiten.
  Ziel ist eine möglichst automatische Bearbeitung.

Components:
	
* Easydekoder
* multicut_light (customized)
* ffmpeg
* avidemux 2.5.6
* Debian Wheezy Archived

### Usage

#### Batch - Decode, Cut, Convert to h264, Cleanup

	docker run -e "otrEmail=bla@fasel.de" -e "otrPassword=geheim" -e "cutlistAtUrl=http://cutlist.at/user/h52hm126h" -v ~/Downloads:/otr develcab/otr

* Man benötigt Docker: https://www.docker.com/products/docker-toolbox#/resources
* Man muss dem Programm einige Angaben mitgeben
  * __email__: Die E-Mail Adresse die man bei onlinetvrecorder.com zum Einloggen nutzt
  * __password__: Das Passwort zum Einloggen bei onlinetvrecorder.com
  * __cutlistAtUrl__: Die "Persönliche Server-URL" von http://cutlist.at (Nach Registrierung oben rechts im Menü)
  * Das Verzeichnis in dem sich die .otrkey Dateien befinden (hier: _~/Downloads_)
    * Das Script bearbeitet alle otrkey Dateien in diesem Verzeichnis, und legt auch hier temporäre Dateien ab
  * (optional) __renameFile=true__: Ändert den Namen des Files zu dem von der Cutlist
  * (optional) __skipConvert=true__: Es wird nur dekodiert und geschnitten, aber nicht nach m4v konvertiert
  * (optional) __skipDecode=true__: Nicht dekodieren, nur nachfolgende Schritte ausführen
  * (optional) __skipCut=true__: Nicht schneiden
  * (optional) __skipCleanup=true__: Temporäre Dateien nicht löschen


#### Manuell

Man kann das Image auch manuell benutzen wenn man zB garnicht umwandeln möchte.
Hierbei muss man nur den Ordner spezifizieren in dem man arbeiten möchte (hier _~/Downloads_)
	
	docker run -ti -v ~/Downloads:/otr develcab/otr bash
	
Man kann _otrdecoder_, _multicut.sh_, _avidemux_ und _ffmpeg_ auf der Kommandozeile nutzen.
Nano, curl und wget sind auch installiert.
	
Ganz wichtig: Änderungen die man in einem laufenden Container vornimmt (also Software installieren, Einstellungen
im System vornehmen usw.) werden nicht dauerhaft gespeichert.
Wenn man den Container stoppt und wieder startet sind Änderungen weg.

Weitere Scripte:

* ffall.sh - Kodiert alle Dateien im momentanen Ordner nach h264 m4v.
* mcall.sh - Schneidet alle avi Dateien im momentanen Ordner mit multicut
	

### HowTo build the project

* Required: Docker Engine / Desktop https://www.docker.com/products/docker-engine

	docker build -t develcab/otr .


### Customize
	
* .multicut_light.rc - hier sind die Einstellungen für Multicut hinterlegt.
  * Wenn man zB lieber gefragt werden will wie das File nach dem Schneiden heißen soll, 
  kann man meine Änderungen überschreiben und den Multicut Originalzustand erhalten indem man eine Zeile ergänzt:

	avidemuxOptions="--force-smart"
  
* auto.sh
  * Dieses Skript wird im Automatischen Modus ausgeführt
  * Hier findet sich in der obersten convert function die Einstellungen für ffmpeg
  * Unten kann man die einzelnen Blöcke des Ablaufs erkennen
  * Man kann zB die Zeilen unter _# cleanup_ ändern wenn man die Dateien eines Zwischenschrittes behalten möchte
* Dockerfile
  * Mit dem Dockerfile wird das Image gebaut, und das Betriebssystem und die Tools installiert.
  * Wenn man zB lieber ein anderes Schnitt-Script nutzen will könnte man hier den Download ergänzen
