+++
title = "Applicaties synchroniseren via Dropbox"
date = "2010-03-04"
aliases = ["/posts/applicaties-synchroniseren-via-dropbox/"]

[taxonomies]
tags = ["Lifehacking"]

[extra]
lang = "nl"
+++

Als je meerdere computers hebt is het vaak een gedoe om altijd de juiste bestanden beschikbaar te hebben, dit kan je oplossen door dingen als [Dropbox](http://lifehacking.nl/web20/dropbox-maakt-bestanden-delen-eenvoudig/) en [Evernote](http://lifehacking.nl/web20/evernote/) te gebruiken. Lastiger is het om de applicaties synchroon te houden, er zijn wel applicaties die het ondersteunen om via het web te synchroniseren maar helaas zijn dit lang niet alle applicaties.

Aangezien ik [TextExpander](http://www.smileonmymac.com/TextExpander/) en [Things](http://culturedcode.com/things/) allebei heel vaak gebruik wilde ik deze graag synchroon houden, zowel op mijn MacBook Pro als op mijn Mac Pro (en Things ook nog op iPhone). Eerste poging was bij Things om deze te syncen van mijn Mac Pro naar mijn iPhone, en dan daarna van iPhone naar MacBook Pro, allemaal handmatig. Dat werkte niet zo geweldig. Gelukkig heb ik een betere oplossing gevonden, en die werkt voor (bijna?) alle applicaties.

Op de Mac (en volgens mij op Linux ook) is het zo dat de meeste applicaties hun gebruikte data opslaan in een los mapje ergens in de home directory. Door die data te verplaatsen naar Dropbox en vervolgens met een symlink aan te geven dat de dropbox versie gebruikt moet worden kan je via dropbox synchroniseren.

Hoe moet dit? Ik zal het uitleggen met als voorbeeld TextExpander. 🙂

## Vooraf

1. Installeer [Dropbox](https://www.dropbox.com/referrals/NTI0MTA0OTI5) (referral link, gratis 250MB extra) op beide computers
2. Installeer de applicatie op beide computers
3. Zorg dat de applicaties dezelfde versie zijn (weet niet of dit verplicht is, maar is sowieso handig)

## Op Computer 1

1. Maak in de dropbox een nieuw mapje waar je deze databases in kwijt kan, mijn mapje heb ik "SyncLibrary" genoemd.
2. Sluit de System Preferences
3. Versleep (niet kopiëren!) de hele map met de data van de applicatie: `~/Library/Application Support/TextExpander`
4. Je hebt nu het mapje "TextExpander" in de Dropbox
5. Typ in de terminal: `ln -s ~/Dropbox/SyncLibrary/TextExpander ~/Library/Application\ Support/TextExpander`
6. Ga naar met Finder naar: `~/Library/Application Support`
7. Als het goed is zie je nu bij de map "TextExpander" het icoontje van de dropbox status staan

## Op Computer 2

1. Sluit de System Preferences
2. Verwijder het mapje TextExpander uit `~/Library/Application Support/`
3. Typ in de terminal: `ln -s ~/Dropbox/SyncLibrary/TextExpander ~/Library/Application\ Support/TextExpander`
4. Ga naar met Finder naar: `~/Library/Application Support`
5. Als het goed is zie je nu bij de map "TextExpander" het icoontje van de dropbox status staan

Nu zou het moeten werken! Op deze manier heb ik TextExpander en Things gesynchroniseerd tussen mijn Mac Pro en MacBook Pro, maar volgens mij moet dit werken voor nog veel meer applicaties, en zelfs ook nog met meer dan 2 computers.
