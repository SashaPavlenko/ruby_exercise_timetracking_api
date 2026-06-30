# Probeaufgabe Zeiterfassungs-API

## Aufgabe

Für deine Probeaufgabe sollst du eine Rails-API-Anwendung entwickeln. Diese soll später als Backend für eine mobile App dienen, mit der Mitarbeiter ihre Arbeitszeiten erfassen können.

Eine korrekte Authentifizierung gegenüber dem Backend soll hier vernachlässigt werden - stattdessen kann in den Requests beispielsweise über einen Header oder einen Query-Parameter die ID des eingeloggten Mitarbeiters mitgesendet werden.

Zeiteinträge müssen immer auf Projekte gebucht werden. Ein Projekt besteht im einfachsten Fall nur aus einem Namen wie bspw. "Photovoltaikanlage Stefan Herzko". Mitarbeiter haben zumindest einen Namen und einen Stundenlohn.

Der Mitarbeiter soll über die API neue Zeiteinträge anlegen können. Außerdem soll es einen Endpunkt geben, mit dem man sich Informationen über ein bestimmtes Projekt holen kann. Diese sollten die bisherigen Gesamtkosten des Projekts beinhalten, welche sich aus den Zeiteinträgen ermitteln.

## Hinweise

- Die Aufgabe ist bewusst recht frei gestaltet, über die Details darfst du selber entscheiden.
- Der `rails new`-Befehl bietet die Option, eine reine API-Anwendung zu erstellen.
- Der Code sollte auf englisch sein.
- Kommentare sollten nur dann verwendet werden, wenn Besonderheiten erklärt werden müssen, die beim Lesen des Codes ansonsten übersehen werden könnten.
- Dokumentiere gerne deine Entscheidungen und Abwägungen, so wie Vereinfachungen, die du vielleicht aufgrund des geringen Zeitumfangs getroffen hast, in der README.
- Am besten arbeitest du in einem Branch und erstellst auf Github einen Pull Request.

Wir möchten, dass du maximal ein paar Stunden in diese Probeaufgabe investierst. Du darfst den Umfang der Aufgabe auch anpassen, so dass sie in den zeitlichen Rahmen passt. Bei Fragen oder Problemen meld dich gerne. Du kannst bspw. am PR @timmitry verwenden, das bekomme ich auf jeden Fall mit.
