+++
title = "Automatisch ScanSnap software starten met Keyboard Maestro"
date = "2013-10-25"
aliases = ["/posts/automatisch-scansnap-software-starten-keyboard-maestro/"]

[taxonomies]
tags = ["Lifehacking", "Automation"]

[extra]
lang = "nl"
+++

Bij Lifehacking hebben we het al vaker gehad over de [ScanSnap scanner](https://lifehacking.nl/spullen/kan-een-scanner-ook-een-lifehack-zijn-hintals-het-zoveel-tijd-bespaart-als-deze-zeker/). Een geweldig ding, volgens ons. Met één nadeel: De software moet aanstaan voor hij überhaupt iets wil scannen.

Verstrooid als ik ben heb ik al een paar keer iets geprobeerd te scannen zonder dat die software aanstond. Dan kan je lang wachten, want de scanner doet namelijk helemaal niets.

Tijd dus om dat te hacken, met behulp van [Keyboard Maestro](http://www.keyboardmaestro.com/main/).

Bij Keyboard Maestro kan je zelf macro's maken, en die activeren met een sneltoets. Althans, zo is het ooit begonnen geloof ik, inmiddels kan je veel meer.

Je kan applicaties starten, op basis van bepaalde criteria. Bijvoorbeeld als er een USB apparaat wordt aangesloten.

Perfect voor deze situatie. Keyboard Maestro kan het dus regelen. Zodra de scanner wordt aangesloten, start dan de applicatie. En zodra de scanner niet meer aangesloten is, sluit dan ook de software af.

Dat ziet er ongeveer zo uit:

![ScanSnap / Connect](/scansnap-connect.png)

En andersom, de software weer afsluiten als de ScanSnap niet meer aangesloten is, werkt zo:

![ScanSnap / Disconnect](/scansnap-disconnect.png)

Het mooiste is dat dit ook werkt als je de USB kabel van jouw ScanSnap altijd aangesloten laat. Keyboard Maestro snapt namelijk pas écht dat hij aangesloten is zodra je de ScanSnap open doet, en hij aan gaat. Op dat moment is hij "Attached" en zal Keyboard Maestro de software opstarten voor je. Zodra je het klepje weer dicht doet, en de scanner uit gaat, ziet Keyboard Maestro dit als "Detatched" en zal hij de software weer afsluiten voor je.

Als je niet kan wachten om dit zelf ook te hebben, heb ik mijn Macro's geexporteerd voor je

- [Download ScanSnap Connect Macro](/downloads/ScanSnap-Start.kmmacros)
- [Download ScanSnap Disconnect Macro](/downloads/ScanSnap-Stop.kmmacros)
