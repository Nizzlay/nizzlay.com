+++
title = "Referentie items automatisch toevoegen aan je OmniFocus inbox"
date = "2013-09-01"
aliases = ["/posts/referentie-items-automatisch-toevoegen-aan-je-omnifocus-inbox/"]

[taxonomies]
tags = ["OmniFocus", "Getting Things Done"]

[extra]
lang = "nl"
+++

Heb je dat ook wel eens? Je hebt een bestand waarvan je weet dat het referentie is voor een taak in je GTD systeem. Dus je verplaatst netjes het bestand naar een mapje 'Referentie', en vergeet het vervolgens. Vervolgens kom je er pas bij je volgende Weekly Review achter dat je natuurlijk ook wel even een taak had moeten aanmaken, en in de notitie van die taak had moeten verwijzen naar dat bestand.

Of andersom. Je ziet een bestand, weet dat er een taak bij hoort en het bestand referentie is. Snel gooi je die taak je OmniFocus inbox in, en vergeet het verder. Later begin je aan de daadwerkelijke taak, maar kan je het bestand nergens meer vinden.

Gaten in je GTD systeem, in beide gevallen.

Gelukkig herken ikzelf dat probleem ook, en ben ik een Lifehacker, dus gaan we dat oplossen. Oplossen met Hazel, en een stukje AppleScript. Zie het als een soort vervolg op het artikel van Jos, hij schreef over "[GTD ticklers direct scannen naar Omnifocus (Mac only)](https://lifehacking.nl/algemeen/workflow-tip-gtd-ticklers-direct-scannen-naar-omnifocus-mac-only/)"

In Hazel heb ik een regel aangemaakt dat alles wat ik in Finder het label 'Paars' geef, wordt verplaatst naar mijn 'Referentie' mapje:

{{< image src="/Referentie-voor-OmniFocus.png" alt="Referentie voor OmniFocus" />}}

Vervolgens maak je in je 'Referentie' mapje ook een regel met Hazel. Deze keer wil je alles wat nog paars is, toevoegen aan OmniFocus met behulp van een AppleScriptje, en vervolgens ontdoen van kleur:

{{< image src="/hazel-omnifocus-referentie.png" alt="Screenshot van Hazel bij het aanmaken van de regel" />}}

De code van het AppleScript wat ik hiervoor heb gebruikt is als volgt:

```applescript
tell application "Finder" to set fileNaam to (name of theFile)

set TaakNaam to "Nieuw item in referentie: " & fileNaam
set Notitie to "Toegevoegd op " & (current date) & "

."

tell application "OmniFocus"
 tell front document
  set NewTask to make new inbox task with properties {name:TaakNaam, note:Notitie}
  tell the note of NewTask
   make new file attachment with properties {file name:theFile, embedded:false}
  end tell
 end tell
end tell
```

Vervolgens hoef je nu alleen nog maar bestanden paars te markeren, en dan komt alles goed. Het bestand wordt verplaatst naar je Referentie map, en er komt een nieuw item in je OmniFocus inbox. Compleet met naam, datum, en bestand in de bijlage. Zoiets dus:

![Nieuw referentie item in OmniFocus inbox](/Nieuw-Referentie-item-in-OmniFocus-inbox.png)
