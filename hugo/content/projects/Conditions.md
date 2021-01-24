---
title: "Konditionsverwaltung"
subtitle: "Verwaltung von Konditionen im SAP-Umfeld"
date: 2020-12-20
draft: false
tags: ["programming", ".net core", "work"]
showToc: true
autonumbering: true // https://codingnconcepts.com/hugo/auto-number-headings-hugo/
diagrams: true
---

## Versionsverwaltung
| Versionsnr. | Grund der Änderung | Geändert am |
| ------------- | ------------- | ----- | ----- | ----- |
| 1 | Initiale Erstellung | 2021-01-10 |

<small></small>

## Einleitung
Im folgenden werden die Ziele und der Nutzen auf Basis einer Situtation beschrieben.

### Ausgangssituation
Vertriebskonditionen treten in unterschiedlichen Formen auf. Diese sind unter Umständen teil von Verträgen und müssen dementsprechend verwaltet werden, so dass verhandelte Konditionen zu den richtigen Zeitpunkten zur Verfügung stehen.
Beispielsweise müssen in der Angebotsphase verhandelte Rabatte oder Preise verwendet werden.

Konditionen werden bisher nach bestem Wissen und Gewissen gepfelgt.

Eine Verifikation der Konditionen gibt es bis dato nicht, es beruht alles auf Expertenwissen und dem Vertrauen, dass dieses komplett und 100% richtig ist.

Da Konditionen nicht formal definiert werden, ist es auch nicht möglich eine formale Verifikation durchzuführen und deshalb werden nur die **wichtigsten** Geschäftsfälle in 100% manueller Arbeit getestet.

Durch diese Vorgehensweise ist **nie** sichergestellt, dass die wirkliche Intention (Z.B. Verträge) korrekt im System abgebildet ist.

Des Weiteren werden "Abkürzungen" bzw. "Bequemlichkeiten" eingeführt, da der entstehende **manuelle Aufwand** die Intentionen in Konditionen darzustellen zu hoch wird (bspw. werden weitere Zugriffsfolgen verwendet um andere Konditionen zu "deaktivieren"). Dadurch werden weitere Komplexitätsstufen erzeugt, welche von Anfang an, mit einer formalen Definition, nicht nötig gewesen wären und **weitere Fehlerquellen darstellen !**.

### Ziele
Zum einen soll die Verwaltung der Konditionen vom System so unterstützt werden um manuelle  Eingriffe und damit erhöhten manuellen Aufwand zu reduzieren.
Des Weiteren sollen Aktionen auf einzelnen Konditionssätzen verringert bzw. vereinfacht werden.

Darauf aufbauend sollen Intentionen (Verträge bzgl. Preise, Rabatte, etc.) formal definiert werden können um notwendige Konditionen ableiten bzw. errechnen zu lassen.

Sobald eine Verwaltung ermöglicht wurde, soll es möglich sein Simulationen durch zu führen. Die Simulationen sollen dabei die gesamte Konditionstechnik abbilden (Konditionen und Kalkulation).

### Nutzen
Durch formale Definitionen können ein leichtes Updates und Konditionen ermittelt werden. Dadurch bleiben Konditionen aktuell, auch wenn Ausprägungen / Parameter, also Rahmenbedingungen, verändert werden.

Des Weiteren soll es möglich sein Simulationen über diverse Geschäftsmöglichkeiten zu erstellen und dadurch die tatsächlichen Auswirkungen der Konditionen zu prüfen und zu vergleichen. Um die Simulationen durch zu führen muss es möglich sein Parameter zu definieren, welche Geschäftsfälle definieren und mittels definierbaren Kalkulationsschemen Konditionen zu ermitteln und Ergebnisse zu berechnen. Daraus können Vergleiche her- und dargestellt werden und somit Unterschiede einfach identifiziert werden.

Die Simulation(en) soll nicht nur bei neu definierten Konditionen verfügbar sein, sondern auch separat aufgerufen werden können und Konditionen, Konditionsarten, Zugriffsfolgen und Kalkulationsschemen verändern können. "Verändern" bedeutet, dass diese Objekte **innerhalb** der Simulation neu definiert, verändert, als auch gelöscht/deaktiviert werden können.

Mit Hilfe der Simulationen von Konditionen können Eingriffe in die Konditionstechnik im vorhinein geprüft und mit dem aktuellen bzw. anderen Zuständen verglichen werden.
Dadurch wird es möglich sein geplante Veränderungen im vorhinein für alle Geschäftsfälle zu simulieren, ob die gewünschten Ergebnisse erzielt werden.

## Grundlagen
In diesem Bereich werden Basiselemente beschrieben und definiert, welche für den späteren Verlauf notwendig sind.

### Konditionen
Als Definition für eine Kondition wird die Beschreibung von SAP verwendet. Eine Kondition ist ein Wert, welcher an eine Bedingung geknüpft ist. Um Preise zu ermitteln werden diese Bedingungen in einer Kalkulation verwendet. Bedingungen können unterschiedlichste Faktoren sein, welche sich aus Rahmenbedingungen (z.B. Angebotsdatum, Kunde) und produktspezifischen Bedinungen (z.B. das Produkt, die Bestellmenge) ableiten.

Eine Kalkulation ist eine Art Rechenvorschrift, welche Arten von Werten verwendet werden und wie diese miteinander verrechnet werden sollen. In eine Angebotskalkulation gibt es bspw. die Arten
- Preis
- Abschlag / Rabatt / Mark down
- Aufschlag / Mark up.

Pro Art wird eine Konditions**art** definiert und für jede Art werden Bedingungen für Konditionen definiert. Pro Konditionsart und Kombination aus Bedingungen kann es genau 0 oder 1 Ergebnis geben.

Eine Kondition besitzt die Eigenschaften:
{{< figure title="Kondition-Modell" >}}
| Merkmal | Beschreibung | Beispiel |
| --------- | ------------- | ----- |
| Nummer | Eindeutiges Kennzeichen | 10384872, ... |
| Betrag | Der Wert der Kondition | 5, 1539,99, ... |
| Einheit | Die Einheit der Kondition | %, EUR, ... |
| Vorzeichen | Gibt an ob positiv oder negativ | - oder + |
| Berechnungsregel | Gibt an wie der Wert verrechnet werden muss |  |
| Ausschschluss | Ein Zusatzkennzeichen |  |
| Verkaufsaktion | Gibt an ob Kondition verknüpft ist |  |
{{< / figure >}}

Das Modell für eine Bedingung pro Kondition:
{{< figure title="Konditionsbedingung-Modell" >}}
| Merkmal | Beschreibung | Beispiel |
| --------- | ------------- | ----- |
| KondNummer | Eindeutiger Verweis auf Kondition | 10384872, ... |
| Art | Das Kennzeichen der Konditionsart | AB00, PR00, ... |
| Bedingung #1 | Es muss mindestens 1 Feld definiert werden | Kdnr=1234, Matnr=9684, ... |
| Bedingung #n..m | Es sind beliebig weitere Felder möglich | Kdnr=1234, Matnr=9684, ... |
| Gültig von | Ab wann die Kondition gültig ist | 01.01.2020 |
| Gültig bis | Bis wann die Kondition gültig ist | 31.12.2020  |
| Gelöscht | Das Löschkennzeichen | "", X |
{{< / figure >}}

Da es pro Konditionsart unterschiedliche Bedingungen geben kann muss diesen eine Gewichtung verliehen werden. Ansonsten könnte nicht unterschieden werden, wenn für eine Anzahl an Parametern mehrere Bedingungen erfüllt werden würde, welche Kondition verwendet werden soll. Deshalb wird den Bedingungen eine Zugriffsreihenfolge verliehen, d.h. welche Bedingungen vor anderen geprüft werden sollen.

Ein Beispiel von Zugriffsfolgen für eine Konditionsart "PR00 - Listenpreis" könnte sein:
{{< figure title="Zugriffsfolgen-Beispiel" >}}
| Feld #1 | Feld #2 | Feld(n) |
| --------- | ------------- | ----- |
| Matnr | Kdnr |  |
| Matnr |  |  |
{{< / figure >}}

[Konditionen und Preisfindung](https://help.sap.com/viewer/14ad85ff93b342afb770eb468a9fd898/6.00.31/de-DE/5e49b753128eb44ce10000000a174cb4.html)


## Fachliche Anforderungen
Die Anforderungen trennen sich in einen Verwaltungs- und einen Simulationsteil. Die Grundlagen werden für beide Teile benötigt und ein Austausch der Anteile untereinander soll ebenfalls möglich sein.

### Konditionsverwaltung
Wie eingangs angesprochen wird eine formale Definition von Konditionen bzw. den Bedingungen gefordert. Diese formalen Definitionen - und damit auch die daraus hervorgehenden Konditionssätze - müssen allerdings auch verwaltet werden. Es muss also erst ein Verwaltungssystem erstellt werden, mit dessen Hilfe formale Beschreibungen möglich bzw. Bestandteil sind.

#### Definition
Klassische Fälle von formalen Beschreibungen sind bspw. Auf- und Abschläge, welche den gleichen Wert für mehrere Bedingungen definieren. Als Beispiel dient ein Rabatt, welcher allen Landesgesellschaften in gleicher Höher für eine bestimmte Produktgruppe gewährt werden soll. Dafür werden alle Gesellschaften ausgewählt, die Produktgruppenmerkmale und einmalig der Wert festgelegt.
Durch die Definition "Alle Gesellschaften" und "einem Wert" können die Rabattsätze automatisch ermittelt werden. Durch die automatische Ermittlung lässt sich auch bei Ergänzung einer neuen Gesellschaft einfach der Rabatt erweitern.

{{< figure title="Formale Definition Beispiel" >}}
| Parameter | Wert | Beschreibung |
| --------- | ------------- | ----- |
| Konditionsart | Interner Rabatt (ZR01) |  |
| Bedingung #1 | Landesgesellschaft = Europa |  |
| Bedingung #2 | Produktgruppe = ABC |  |
| Wert | 15% |  |
{{< / figure >}}

Das Ergebnis sind die einzelnen berechneten Konditionssätze, welche in diesem Fall das Kreuzprodukt der Bedingungen ist:

{{< figure title="Ermittelte Konditionssätze (Formale Definition) Beispiel" >}}
| Kondart | Bedingung #1 | Bedingung #2 | Wert |
| --------- | ------------- | ----- | ----- |
| ZR01 | VKB = 100 | Prd.grp. = ABC | 15% |
| ZR01 | VKB = 200 | Prd.grp. = ABC | 15% |
| ZR01 | VKB = 300 | Prd.grp. = ABC | 15% |
| ZR01 | VKB = 400 | Prd.grp. = ABC | 15% |
| ... | ... | ... | ... |
{{< / figure >}}

In vielen Fällen ist eine formale Definition wie eine einzelne Definition, da die formale Definition so spezifisch ist, dass im Prinzip einzelne Konditionssätze definiert werden. In diesen Fällen ist es nicht sinnvoll eine formale Definition zu erstellen, sondern den Nutzer so zu unterstützen, dass die Konditionen mit einfachen Mitteln und so viel Unterstützung wie möglich erstellt werden können.

#### Status
Wird eine neue Defintion angelegt durchläuft diese einige Stati. Mit dessen Hilfe kann die Dateneingabe unterteilt und weitere Aktionen deterministisch gestartet werden.

{{<mermaid title="Definition: Zustandsdiagramm">}}

stateDiagram-v2

    [*] --> Definition

    state Definition {
        [*] --> New
        New --> Editing : edit
        Editing --> Released : release
        Released --> [*]
    }
    
{{</mermaid>}}

In jedem Zustand sind Aktionen des Nutzers oder Systems notwendig:
- New:
Fragebaum wird befüllt.
- Editing:
Kondition werden befüllt.
- Released:
Kondition werden eingefroren.


##### Aktion: Neue Konditionen (Formale Definition)
##### Aktion: Neue Konditionen ()
##### Aktion: Approval-Workflow
##### Aktion: Erinnerungs-Workflow

Einzelne Konditionssätze sollen nicht manuell gepflegt werden. 

#### Fragebaum
Die erste Unterstützung für die Nutzer ist ein Fragebaum, der sie zum einen in die richtige Richtung der Konditionsarten schickt und zum anderen die Bedingungen abfrägt.

{{< figure title="Felder für Fragebaum" >}}
| Kategorie | Feld | Frage | Werte |
| ---- | ---- | --------- | ------------- |
| Art | Art | Art der Kondition(en)? | Preis, Aufschlag, Abschlag, Provision |
| Art | <div>Anwendungsgebiet</div> | Anwendungsgebiet? | Zentral, Lokal |
| Art | Verwendung | Verwendung für? | Kunde, Intern |
| Art | Berechnung | Rechenart? | Standard, FinSal |
| Bed. | VKORG | Geber | Alle, 1000, 5000, ... |
| Bed. | VKB | Empfänger | Alle, 600, 701, ... |
| Bed. | Positionsfelder | Positionsdaten | MG, Familie, Material, ... |
{{< / figure >}}

Aufgrund der Antworten des Fragebaums können Zustände errechnet werden. Die Diagramme zur Errechnungen sind wie folgt:

{{<mermaid title="Fragebaum: Konditionsartenfindung Preis">}}
graph LR;
    
        P[Preis]-->PR00;
    
{{</mermaid>}}

{{<mermaid title="Fragebaum: Konditionsartenfindung Aufschlag">}}
graph LR;
    
        Auf[Aufschlag];
            Auf-->AufZ[Zentral];
                AufZ-->AufZK[Kunde];
                    AufZK-->ZRM0;
                AufZ-->AufZI[Intern];
                    AufZI-->ZRM1;
            Auf-->AufL[Lokal];
                AufL-->AufLK[Kunde];
                    AufLK-->YRM0;
                AufL-->AufLI[Intern];
                    AufLI-->YRM1;
                    
{{</mermaid>}}


{{<mermaid title="Fragebaum: Konditionsartenfindung Abschlag">}}
graph LR;

        Ab[Abschlag];
            Ab-->AbZ[Zentral];
                AbZ-->AbZK[Kunde];
                    AbZK-->ZR00;
                AbZ-->AbZI[Intern];
                    AbZI-->AbZIS[Standard];
                        AbZIS-->ZR01;
                    AbZI-->AbZIFinSal[FinSal];
                        AbZIFinSal-->ZR11;
            Ab-->AbL[Lokal];
                AbL-->AbLK[Kunde];
                    AbLK-->YR00;
                AbL-->AbLI[Intern];
                    AbLI-->YR01;

{{</mermaid>}}


{{<mermaid title="Fragebaum: Konditionsartenfindung Provision">}}
graph LR;
    
        Prov[Provision];
            Prov-->ProvZ[Zentral];
                ProvZ-->ZP01;
            Prov-->ProvD[Dezentral];
                ProvD-->ZP02;
            Prov-->ProvU[Umlage];
                ProvU-->ProvUS[Standard];
                    ProvUS-->ZP03;
                ProvU-->ProvUFinSal[FinSal];
                    ProvUFinSal-->ZP13;

{{</mermaid>}}

Wurden die Konditionsarten ermittelt, können auch die möglichen Schlüsselkombinationen ermittelt werden. Das Kreuzprodukt der im Fragebaum angegebenen Bedingungen ergibt die notwendige Schlüsselkombination (also die Kombination aller Bedingungen).

Wurde keine Schlüsselkombination gefunden soll eine entsprechende Meldung ausgegeben werden. Das eine neue Schlüsselkombination angelegt werden muss oder andere Bedingungen verwendet werden müssen.


#### Expertenmodus
Nicht immer ist ein Fragebaum gewünscht oder auch notwendig. In diesen Fällen wird die Annahme getroffen, dass sich der Nutzer mit der Konditionstechnik sehr gut auskennt und Erfahrung hat. Anstatt dem Fragebaum soll direkt die Konditionsart und die gewünschte Schlüsselfolge ausgewählt werden. Das Ergebnis ist somit das selbe wie, wenn der Fragebaum gewählt worden wäre und es können die selben weiter notwendigen Aktionen durchgeführt werden.


#### Berechnung / Ermittlung
Wurde die Konditionsart und Schlüsselfolge ermittelt müssen im weiteren Verlauf noch die notwendigen Konditionswerte eingetragen werden. Dazu sollen einige Hilfsmittel zur Verfügung gestellt werden, welche das Leben etwas erleichtern.

##### Konditionen errechnen
Wurde die Definition der Konditionen via Fragebaum vorgenommen können mittels der eingetragenen Bedingungen die notwendigen Bedingungskombinationen errechnet werden. Dadurch müssen diese nicht vom Nutzer selbst ermittelt werden. In einigen Fällen kann in diesem Schritt auch der Wert vorgegeben werden, wenn dieser in allen Kombinationen der selbe sein soll.

In folgendem Beispiel werden aus den Werten des Fragebaums und der ausgewählten Schlüsselkombination die notwendigen Konditionen mit Bedingungskombinationen errechnet.

Der Fragebaum wurde mit folgenden Werten beantwortet:

{{< figure title="Fragebaum: Beispiel" >}}
| Kategorie | Feld | Frage | Werte |
| ---- | ---- | --------- | ------------- |
| Art | Art | Art der Kondition(en)? | Abschlag |
| Art | <div>Anwendungsgebiet</div> | Anwendungsgebiet? | Zentral |
| Art | Verwendung | Verwendung für? | Kunde |
| Art | Berechnung | Rechenart? | Standard |
| Bed. | VKORG | Geber | 1000, 7100 |
| Bed. | Kopffelder | Kopfdaten | KGRP = 40 |
| Bed. | Positionsfelder | Positionsdaten | MG = 01 |
{{< / figure >}}


Die die daraus abgeleitete Konditionsart und Schlüsselkombination wird vorgeschlagen/vorausgewählt:
{{< figure title="Ermittelte Konditionsart und Schlüsselkombinationen: Beispiel" >}}
| Kondart | Schlüsselkombination | Ausgewählt |
| --------- | ------------- | ----- |
| ZR00 | VKORG, KGRP, MG | X |
| ZR00 | KGRP, MG | |
| ZR00 | VKORG, MG | |
| ZR00 | MG | |
{{< / figure >}}

Aufgrund der Informationen können nun die notwendigen Konditionen mit Bedingungen errechnet werden: 
{{< figure title="Berechnete Konditionen: Beispiel" >}}
| Kondart | Bedingung #1 | Bedingung #2 | Bedingung #3 | Wert |
| --------- | ------------- | ----- | ----- | ----- |
| ZR00 | VKORG = 1000 | KGRP = 40 | MG = 01 |  |
| ZR00 | VKORG = 7100 | KGRP = 40 | MG = 01 |  |
{{< / figure >}}

Im Anschluss müssen die Werte eingetragen werden.

##### Konditionen/-swerte einfügen (Copy & Paste)

#### Datenmodell

{{<mermaid title="Definition: Datenmodell">}}
erDiagram
    
    DEFINITION }o--o{ TAG : has    
    DEFINITION {
        string name
        string version
        string beschreibung
        fragebaum baum
    }

    TAG {
        string name
    }

    DEFINITION ||--o{ CONDITION : has
    CONDITION {
        decimal betrag
        string einheit
        string vorzeichen
        string ausschluss
        string verkaufsaktion
        string kondnummer
        string art
        date gueltigvon
        date gueltigbis
        bool geloescht
    }

    CONDITION ||--|| BEDINGUNG : has
    BEDINGUNG {
        string key
        string value
    }

{{</mermaid>}}

#### Aktionen
Im folgenden werden Aktionen definiert die möglich sein müssen. Die Aktionen beziehen sich auf grundsätzliche Dinge wie bspw. neue Definitionen anlegen als auch spezifische Aktionen, welche in einer Definition ausgeführt werden sollen können.

##### Neue Definition
Der Startpunkt ist das Erstellen einer neuen Definition. Die Definition beinhaltet einen Namen und sprechende Schlagworte (Tags) um im Nachhinein die Suche zu vereinfachen. Des Weiteren wird entweder ein Fragebaum beantwortet oder im Expertenmodus direkt die Konditionsart und die Schlüsselkombination befüllt.

Eine neue Version identifiziert sich über einen Namen und eine Versionssnummer. Da Konditionen nicht für immer fix sind muss es möglich sein diese in Zukunft auch zu ändern. Dazu wird die selbe Defintion verwendet, allerdings mit einer neue Version.

Die nächsten möglichen Schritte sind: Löschen oder Konditionen bearbeiten

##### Definition bearbeiten


##### Update Definition
Ein Update ist das selbe wie eine neue Version. Das heißt, dass eine bestehende Definition verwendet wird und dazu alle oder bestimmte Kondititionen aktualisiert / verändert werden.

Mit einem Vergleich der vorhergehenden Defintion und der neuen Definition können Unterschiede ermittelt werden.
{{<figure title="test">}}
{{<inlinesvg path="/content/projects/conditions.drawio.svg">}}
{{</figure>}}


##### Discontinue Definition

### Konditionssimulation

#### Geschäftsfälle

#### Veränderung von Konditionen

#### Berechnung (Kalkulation)

#### Vergleiche

### Funktionsbeschreibung

## Technische Anforderungen

### Zugriffsmöglichkeiten