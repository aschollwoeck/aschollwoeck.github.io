---
title: "JPP Boosted"
subtitle: "Konzept zur Darstellung von Informationen modifizierter Kraftfahrzeuge von JP-Performance"
date: 2019-06-12
draft: false
tags: ["programming", "go", "hobby"]
showToc: true
autonumbering: true // https://codingnconcepts.com/hugo/auto-number-headings-hugo/
---

## Versionsverwaltung
| Versionsnr. | Grund der Änderung | Geändert am |
| ------------- | ------------- | ----- | ----- | ----- |
| 1 | Initiale Erstellung | 2019-06-12 |

<small></small>

## Einleitung
In diesem Abschnitt werden die Umstände und Motivation des Projektes dargestellt.

### Ausgangssituation
Der Tuner Jean-Pierre Kraemer betreibt die Tuningwerkstatt „JP Performance“ und modifiziert dort hauptsächlich Autos. Neben der Werkstatt besitzt er den größten Automobil-YouTube-Kanal in Deutschland. Die Videos stellen Kundenfahrzeuge und Projektfahrzeuge dar, welche modifiziert und gemessen werden.

{{< figure title="JP-Performance-Logo" >}}
![JP-Performance-Logo](/assets/images/projects/jppboosted/jp_performance_logo.jpg)
{{< / figure >}}

Neben standardmäßigen Tuning wie Felgen und Fahrwerk werden auch Umbauten von klein, wie veränderte Luftfilter, bis hin zu großen, wie Motorentausch, vorgenommen und selbst durchgeführt. Den Zuschauern werden diese Projekte nach jeder Modifizierung dargestellt und somit kann jederzeit nachvollzogen werden, welches Tuning welche Veränderungen hervorgebracht haben.
Neben Zeitenmessungen, wie 0-100 km/h oder 100-200 km/h steht ein Prüfstand zur Verfügung und eine Teststrecke „LaSiSe“ bei der die Fahrzeuge getestet werden können.
Die Fahrzeuge werden bisher ausschließlich via YouTube dokumentieren. D.h. um Informationen zu den Fahrzeugen zu erhalten, müssen die Videos gesehen werden und unter Umständen, wenn keine Playlist für das Auto vorhanden ist, die Videos zusammengesucht werden.

### Ziele
Die Zieldefinition lautet wie folgt:
Informationen zu den Fahrzeugen, von Modifizierungen bis hin zu Messungen, einfach zur Verfügung stellen.

### Nutzen
Pro Fahrzeug kann somit nachvollzogen werden, welche Umbauten vorgenommen wurden mit den zusätzlichen entsprechenden Daten der Messungen, ohne zeitaufwändig auf YouTube Videos zu durchsuchen.

## Fachliche Anforderungen
In diesem Kapitel werden die Anforderungen beschrieben, welche umgesetzt werden sollen. Hierbei wird nicht auf die Technik eingegangen, sondern lediglich alle Fälle geschildert und gesammelt, welche zum definierten Ziel führen.
###	Funktionsbeschreibung
Es wird ein Werkzeug benötigt um Daten, welche z.B. aus den Videos enstehen, erfassen zu können. Diese erfassten Daten können anschließend in einer strukturierten Weise dargestellt oder durchsucht werden. Es findet somit eine strikte Trennung der Daten und der Darstellung statt.
Alle Merkmale hängen an einem bestimmten Fahrzeug, welches umgebaut und gemessen wird. Es gibt zum einen unterschiedliche Umbauten, z.B. die verwendeten Teile unterscheiden sich bei allen Projekten, und zum anderen unterschiedliche Messarten, z.B. Messungen auf dem Prüfstand oder Zeitenmessungen. Jeder Zustand, z.B. jede Veränderung, eines Fahrzeugs erzeugt bspw. unterschiedliche Messungen.

### Grundlage: YouTube
Alle Informationen stammen aus den zur Verfügung gestellten YouTube-Videos. Das bedeutet auch, dass jedes Video gesehen werden muss um daraus Daten zu gewinnen. Es gibt kein festes Format wie diese hinterlegt sind (z.B. in Abschnitten, etc.), sondern pro Video ist es eine zufällige Reihenfolge und es besteht keine Garantie, dass überhaupt notwendige Informationen enthalten sind. So kann bspw. ein komplettes Video nur ein „Frage-Antwort“-Video sein, ohne Inhalt zu Fahrzeugen.
Ein Video an sich enthält allerdings immer bestimmte Metdaten, welche zugeordnet werden können.

{{< figure title="YouTube-Video" >}}
| Merkmal | Beschreibung | Beispiel |
| --------- | ------------- | ----- |
| Titel | Titel des Videos | BMW M3 Nachbau |
| Ort (Land u. Stadt) | Wo das Video (hauptsächlich) gedreht wurde | Deutschland u. Dortmund oder Japan u. Nagoya |
| Url | Url des Videos |https://www.youtube.com/watch?=... |
{{< / figure >}}


### Basisdaten
Die Basisdaten an sich sind die Fahrzeugdaten. Diese können sehr detailiert sein, siehe z.B. ADAC-Fahrzeugkatalog, und grob gehalten werden. Es sollten die wichtigsten Basisdaten zu einem Fahrzeug erfasst werden und für weitere Informationen kann auf andere Seiten mit mehr Informationen weiterverlinkt werden. Wichtige Informationen die unter Umständen aufeinander aufbauen sind wie folgt:

{{< figure title="Fahrzeug-Basis" >}}
| Merkmal | Beschreibung | Beispiel |
| --------- | ------------- | ----- |
| Titel | Titel des Projektes/Umbaus | BMW M3 Nachbau |
| Hersteller | Hersteller des Fahrzeugs | BMW |
| Herstellermodell-bezeichnung | Interne Bezeichnung des Herstellers für die Fahrzeugreihe (Code-Name) | F30 |
| Herstellerbezeichnung | Die offizielle Baureihe des Herstellers, wie es vermarktet wird | 3er |
| Modell | Die genaue Modellbezeichnung | 320d |
| Kraftstoff | Mit was das Fahrzeug fortbewegt wird	| Diesel |
| Baujahr | Produktionsdatum des Fahrzeugs | 2017 |
| Anschaffungsdatum | Kaufdatum des Fahrzeugs | 2019-03-16 |
{{< / figure >}}

Die so eingetragenen Fahrzeuge müssen eindeutig sein, d.h. dass diese unter Umständen mehrfach vorkommen können, aber mit unterschiedlichen Modifizierungen.

### Modifizierungen
Die Modifizierungen sind gekoppelt an ein spezifisches, zuvor eingetragenes, Fahrzeug. Ein Fahrzeug kann mehrere Modifizierungen besitzen. Eine Modifizierung an sich kann vieles bedeuten, darunter der Einbau eines neuen Luftfilters, eine Abgasanlage, ein neues Fahrwerk oder auch ein Motorswap.
Da es eine Vielzahl an Möglichkeiten gibt, wird es relativ generisch gehalten in Betracht auf die Modifizierung selbst. Allerdings kann jede Modifizierung eine oder mehrere Messungen beinhalten, die Messungen sollte aber nach festen Kriterien eingetragen werden, da diese Daten quantifiziert sind und damit für evtl. spätere Darstellung interessant werden können.
Mögliche Daten für eine Modifizierung sind:

{{< figure title="Fahrzeugmodifizierungen" >}}
| Merkmal | Beschreibung | Beispiel |
| --------- | ------------- | ----- |
| Beschreibung | Kurze Beschreibung der Modifizierung | Stage 1 |
| Fahrzeuggewicht | Gewicht des Fahrzeugs in KG nach der Modifizierung | 1540 KG |
| YouTube-Url | Video in welchem die Modifizierung gezeigt wird | http://youtube.de/w=..... |
| Modifizierungsdatum | Datum wann das Video erschienen ist | 2019-04-05 |
{{< / figure >}}

Eine Modifizierung kann keine oder mehrere Teile beinhalten. Diese Teile sind generisch gehalten und sollten frei wählbar sein um jederzeit neue Teile und Hersteller aufnehmen zu können:

{{< figure title="Fahrzeugteile" >}}
| Merkmal | Beschreibung | Beispiel |
| --------- | ------------- | ----- |
| Teilekategorie | Produktkategorie des verbauten Teils | Luftfilter |
| Teilebezeichnung | Names des verbauten Produkts des Herstellers | K&N High-Flow Air Filter |
| Teile-Url | Link zur Teileseite | http://K&N.de/luftfilter/123 |
| Hersteller | Hersteller des Teils | K&N |
| Hersteller-Url | Link zur Herstellerseite | http://K&N.de |
| Gewicht | Gewicht in KG des Teils | 14,3 KG |
| Gewichtseinsparung | Einsparung in KG zu vorherigem Teil | 5,6 KG |
{{< / figure >}}

### Messungen
Wie bereits geschildert, werden unter Umständen pro Modifizierung mehrere Messungen durchgeführt. Die aktuellen Messmöglichkeiten sind die Zeitenmessung:

{{< figure title="Zeitenmessung" >}}
| Merkmal | Beschreibung | Beispiel |
| --------- | ------------- | ----- |
| Geschwindigkeitsbereich | Von-Bis-Zeit welche auf Zeit gemessen wird | 0-100 km/h |
| Dauer | Gemessene Zeit in Sekunden | 3.4 Sek. |
| Performancebox | Typ der Messuhr | Racelogic oder GStarz |
| Personen | Anzahl der Personen im Fahrzeug | 2 |
| YouTube-Url | Video in welcher die Messung durchgeführt wurde | http://youtube.de/w=..... |
{{< / figure >}}

Die Prüfstandsmessung:

{{< figure title="Prüfstandsmessung" >}}
| Merkmal | Beschreibung | Beispiel |
| --------- | ------------- | ----- |
| PS | | 400 PS |
| NM | | 564 NM |
| Besitzer | Besitzer des Prüfstands | JP Performance |
| YouTube-Url | Video in welcher die Messung durchgeführt wurde | http://youtube.de/w=..... |
{{< / figure >}}

Und die Messung auf einer Teststrecke:

{{< figure title="Teststrecke" >}}
| Merkmal | Beschreibung | Beispiel |
| --------- | ------------- | ----- |
| Teststrecke | Name der Teststrecke | LaSiSe |
| Dauer | Rundenzeit | 01:02:23 |
| Höchstgeschwindigkeit | Die höchste Geschwindigkeit, welche auf der Strecke erreicht wurde | 214 km/h |
| YouTube-Url | Video in welcher die Messung durchgeführt wurde | http://youtube.de/w=..... |
{{< / figure >}}

Eine Teststrecke besteht aus mehreren Streckenabschnitten. Jeder Streckenabschnitt kann individuell gemessen und somit auch verglichen werden.

{{< figure title="Teststreckendetails" >}}
| Merkmal | Beschreibung | Beispiel |
| --------- | ------------- | ----- |
| Streckenabschnitt | Name der Abschnitts | Fuchsröhre |
| Dauer | Rundenzeit | 00:12:33 |
| Höchstgeschwindigkeit | Die höchste Geschwindigkeit, welche auf dem Streckenabschnitt erreicht wurde | 214 km/h |
{{< / figure >}}

### Datenmodell
Die in den vorangegangenen Kapiteln ermittelten Daten stehen in Zusammenhang zueinander und besitzen Abhängigkeiten. Diese Abhängigkeiten werden in folgender Darstellung abgebildet:

{{< figure title="Datenmodell" >}}
![Datenmodell](/assets/images/projects/jppboosted/data_model.png)  
{{< / figure >}}

### Benutzergruppen und Berechtigungen
Da die Plattform eine Informationsseite mit speziellen Funktionen ist, sollen die Informationen auch für alle Besucher ohne Einschränkungen sichtbar und einsehbar sein.
Zum reinen Anzeigen der Informationen wird kein Account oder ähnliches benötigt, sondern nur, wenn Daten hinzugefügt oder bearbeitet werden sollen. In diesem Fall werden spezielle Berechtigungen benötigt, welche an einem Account identifizierbar sein sollen.

{{< figure title="Rollen und Berechtigungen" >}}
| Benutzergruppe | <div style="text-align: center;">Account notwendig</div> | <div style="text-align: center;">Berechtigung notwendig</div> |
| --------- | ------------- | ----- |
| Lesen | | |
| Schreiben | <div style="text-align: center;">X</div> | <div style="text-align: center;">X</div> |
| Admin | <div style="text-align: center;">X</div> | <div style="text-align: center;">X</div> |
{{< / figure >}}

Um Schreibberechtigungen zu erlangen, müssen diese zuvor von einem Administrator freigegeben werden.
### Prozesse / Workflows / User Stories
Die folgenden User Stories zeigen auf, welche Schritte möglich sein müssen.
#### Benutzer
In diesem Abschnitt werden Aktionen definiert, welche Benutzerbezogen sind. D.h. alles was auf einen Account Einfluss hat. Accounts sind nur notwendig, um bestimmte Aktionen auszuführen, welche Berechtigungen benötigen.
##### Account anlegen
Damit ein Nutzer identifiziert werden kann wird ein Account benötigt. Dafür muss sich der Nutzer registrieren können und Daten hinterlegen.
Als Nutzer möchte ich einen Account anlegen, um Zugang zu administrativen Aktionen zu erhalten.
##### Einloggen
Als Nutzer möchte ich mich in meinen Account einloggen, um mich zu identifizieren.
##### Schreibberechtigung beantragen
Als registrierter Nutzer möchte ich Schreibberechtigungen, um Daten für die Webseite einpflegen zu können.
#### Fahrzeug
Aktionen welche Fahrzeugbezogen sind werden in folgendem Abschnitt erläutert. Dieser Abschnitt dient dem Hauptzweck dieses Projekts.
##### Fahrzeug anlegen
Als registrierter Nutzer möchte ich ein neues Fahrzeug anlegen, um ein neues Projekt- oder Kundenfahrzeug von JPP darzustellen.
##### Zustand hinzufügen
Als registrierter Nutzer möchte ich zu einem Fahrzeug einen neuen Zustand hinzufügen, um den Fortschritt eines Fahrzeugs zu dokumentieren.
##### Messung hinzufügen
###### Zeit
###### Prüfstand
###### Teststrecke
##### Fahrzeug suchen
 
{{< figure title="Landing Page" >}}
![Landing Page](/assets/images/projects/jppboosted/landing_page.png)  
{{< / figure >}}

##### Detailierte Fahrzeugsuche

{{< figure title="Fahrzeugsuche" >}}
![Fahrzeugsuche](/assets/images/projects/jppboosted/fahrzeugsuche.png)  
{{< / figure >}}

##### Projektübersicht

{{< figure title="Fahrzeugübersicht" >}} 
![Fahrzeugübersicht](/assets/images/projects/jppboosted/fahrzeuguebersicht.png)  
{{< / figure >}}

##### Rundenzeitenübersicht

{{< figure title="Rundenzeitenübersicht" >}}  
![Rundenzeitenübersicht](/assets/images/projects/jppboosted/rundenzeituebersicht.png)  
{{< / figure >}}

##### Prüfstandsmessungenübersicht

{{< figure title="Prüfstandsmessungsübersicht" >}}  
![Prüfstandsmessungsübersicht](/assets/images/projects/jppboosted/pruefstandmessunguebersicht.png)  
{{< / figure >}}

##### Zeitenmessungsübersicht
 
{{< figure title="Zeitenmessungsübersicht" >}}  
![Zeitenmessungsübersicht](/assets/images/projects/jppboosted/zeitenmessunguebersicht.png)  
{{< / figure >}}

#### Weltkarte von Videos

{{< figure title="Weltkarte der Videos" >}}   
![Weltkarte der Videos](/assets/images/projects/jppboosted/weltkarte_videos.png)  
{{< / figure >}}

### Anforderungen an Oberfläche

## Technische Anforderungen
### Zugriffsmöglichkeiten