+++
title = "Taken aanmaken via QR Codes"
date = "2013-07-11"
aliases = ["/posts/taken-aanmaken-via-qr-codes/"]

[taxonomies]
tags = ["OmniFocus", "Getting Things Done"]

[extra]
lang = "nl"
+++

Vaak zorgen dingen die jij in de 'echte' wereld tegenkomt voor nieuwe taken, die je dan natuurlijk in je digitale (cloud gesynchroniseerde) takenlijstje wilt noteren. En in veel van die gevallen gaat het nog om terugkerende dingen ook. Denk bijvoorbeeld aan: Lege batterijen, of een rommelige kledingkast.

Je merkt in je bakje met batterijen dat je batterijen op zijn, dus je moet nieuwe gaan kopen. De taak van nieuwe batterijen kopen zet jij netjes op je takenlijstje, en dan komt alles goed. Of: Eens in de zoveel tijd merk je dat je kledingkast wel eens opgeruimd mag worden, want die is op mysterieuze wijze 'ineens' een rotzooi geworden, ook dat noteer je netjes als een project op jouw takenlijstje zodat je er later mee aan de slag kunt.

Best handig toch die digitale lijstjes? Noteren op je telefoon, en dan hoef je het niet meer te onthouden. En dat lijstje synchroniseerd netjes, dus is nog eens overal vandaan te benaderen ook.

Zeker handig. Als je zover bent heb je al een prima basis gelegd voor jouw 'Geest als Water'. Maar! Met behulp van wat Lifehacken kunnen we het versimpelen.

Het is namelijk zo dat veel van die takenlijstjes apps een zogenaamd 'URL Scheme' hebben (op iOS. Geen idee hoe dat op Android zit, maar kan me niet voorstellen dat die achterblijven). Via zo'n 'URL Scheme' kunnen apps aangeven dat ze gebruik willen maken van functionaliteiten die in een andere app zitten, bijvoorbeeld voor het aanmaken van een taak.

Via dat 'URL Scheme' kan je bijvoorbeeld in Instapaper direct nieuwe items je OmniFocus inbox ingooien. Of een RSS artikel vanuit Reeder direct opslaan in Evernote. Merk jij niets van, heeft de ontwikkelaar al zo voor je gemaakt.

En van die functionaliteit gaan we gebruik maken om het proces van taken uit de 'echte wereld' noteren te versimpelen.

Wat je kunt doen is het volgende:

```
omnifocus:///add?name=TAAKNAAM&note=EXTRAINFO
```

Waarbij je `TAAKNAAM`, en `EXTRAINFO`, natuurlijk wilt vervangen met wat er in je OmniFocus terecht zou moeten komen. Zoiets dus:

```
omnifocus:///add?name=AA Batterijen Kopen&note=Duracel Procell Alkaline 10 stuks
```

Maar dan ben je er nog niet. Spaties mogen niet, dus die moet je nog eventjes vervangen met %20. Dan krijg je dit:

```
omnifocus:///add?name=AA%20Batterijen%20Kopen&note=Duracel%20Procell%20Alkaline%2010%20stuks
```

Als je die URL opent in Safari wordt je direct doorverwezen naar OmniFocus, en OmniFocus maakt een nieuwe taak voor je aan.

En nu denk je "Mijn god Niels, dit is toch veel meer werk om in safari te typen dan dat ik de daadwerkelijke taak in mijn OmniFocus zou typen?" Klopt helemaal. Maar we zijn pas halverwege met het versimpelen 😉

Wat je vervolgens moet doen is deze URL om laten zetten naar een QR code. Gewoon door het even te plakken in een [QR-Code generator](https://www.websiteplanet.com/nl/webtools/free-qr-code-generator/)

Dan krijg je dit:

![QRcode voor het aanmaken van een taak in OmniFocus](/qrcode-omnifocus.png)

Deze blokjes code kan je scannen met je telefoon, en dan vertaalt je telefoon die blokjes naar de URL. Vervolgens probeert hij die URL te openen, herkent dat het gaat om een 'URL Scheme' die bij OmniFocus hoort, en geeft het dus netjes door aan OmniFocus. OmniFocus herkent de gegevens, en maakt een nieuwe taak aan met de naam zoals jij die hebt gegeven, en de zet de extra info in de notitie.

Nu hoef je dus niets meer te typen, alleen maar eventjes de blokjes te scannen. Een beetje zoals dat kassameisje het ook met je boodschappen doet met de streepjes codes.

Het enige wat je nu nog hoeft te doen is die QR Code uit te printen en opplakken in je batterijen bakje. Als je bakje dan leeg genoeg is om de QR code te zien scan je hem even, en klaar. Stuk makkelijker, sneller, en stiekem ook gewoon stoerder.

Dus.. Voor welke taken ga jij QR Codes printen? 😄
