+++
title = "Automatisch Downloaden"
date = "2010-03-30"
aliases = ["/posts/automatisch-downloaden/", "/automatisch-downloaden-deel-2-torrents"]

[taxonomies]
tags = ["Lifehacking", "Automation"]

[extra]
lang = "nl"
+++

TV kijken gelijk staat aan zo’n [16 uur inefficiëntie per week](https://lifehacking.nl/televisie-16-uur-inefficientie-per-week/). “Maar sommige series zijn zo leuk!” Ok, daar ben ik het in sommige gevallen wel mee eens. Geen probleem dan zorgen we toch dat die afleveringen automatisch gedownload worden zodat je dat kan kijken, zonder reclame, wanneer het jou uitkomt. 😉

Over het algemeen zijn er onder de downloaders 2 richtingen: Nieuwsgroepen, ook wel usenet genoemd, waarbij je gebruik maakt van NZB’s. En Torrents. Ik heb het automatisch downloaden voor allebei de richtingen uitgezocht en zal deze post dus opsplitsen in deze 2 gedeeltes. Als je de ene niet gebruikt kan je de andere richting proberen. Als je het van allebei geen verstand hebt is het misschien handig als je dit eerst even uitzoekt voor je het gaat automatiseren.

## Automatisch downloaden, via Nieuwsgroepen

1. Om automatisch te downloaden via Nieuwsgroepen heb je het programma [SABnzbd+](http://sabnzbd.org/) nodig, dit programma is gratis en beschikbaar voor alle systemen.
2. Vervolgens heb je een RSS feed met NZB’s nodig. Deze moet je toevoegen in je SABnzbd+. Zoek bijvoorbeeld de serie die je wilt volgen bij [nzbindex.nl](https://nzbindex.nl), en pas zo veel mogelijk filters toe. Als voorbeeld neem ik The Big Bang Theory. Genereer vervolgens de RSS feed. Dan krijg je bijvoorbeeld dit: `https://nzbindex.nl/search/rss?q=The+Big+Bang+Theory&max=250&minage=0&maxage=1000&hidespam=1&hidepassword=1&sort=agedesc&minsize=0&maxsize=0&complete=1&hidecross=0&hasNFO=0&poster=&g[]=720`
3. Nu moet je een filter maken in SABnzbd+ zodat hij snapt dat je alleen specifieke nzb's wilt hebben.
   1. Kijk goed naar de naamgeving van de NZB’s, zoals je die kan zien bij de resultaten van stap 2.
   2. Houd je filter zo algemeen mogelijk, anders kan het zo zijn dat het volgende week niet werkt.
   3. In het voorbeeld zou je filter dus The.Big.Bang.Theory.\*.720p kunnen maken.
   4. Het sterretje \* is heel belangrijk in je filters, dit staat voor de wildcard en daar kan dus alles voorkomen, onder andere het afleveringsnummer.
4. Test je filter door op Force-Download te klikken, dan gaat SABnzbd+ de RSS feed bekijken op wat er gedownload moet worden, als je filter werkt zal je dit nu gelijk kunnen zien.
5. Herhaal voor alle series die jij wilt volgen.

Trouwens: Het is wel handig als je SABnzbd+ automatisch laat opstarten bij het starten van je computer, anders moet je alsnog wat zelf gaan doen.

## Automatisch downloaden, via Torrents

- Om automatisch te downloaden via Torrents heb je een torrent client nodig die RSS feeds ondersteund, zoals [µTorrent](https://www.utorrent.com/)
- Vervolgens moet je bij [EZRSS](http://ezrss.it/) zoeken welke serie je wilt volgen. (Als voorbeeld neem ik [The Big Bang Theory](http://ezrss.it/search/?show_name=The+Big+Bang+Theory&show_name_exact=true))
- Kopieer het link adres van de ‘Search-based RSS Feed’
- Voeg die URL toe als feed bij jou torrent client.
- Herhaal stap 2 t/m 4 zo vaak je wilt

Zorg er nu alleen nog even voor dat de torrent client automatisch opstart bij het starten van je computer, anders moet je alsnog wat zelf gaan doen.

Tot slot wil ik nog de tip geven dat je gewoon je feeds en filters laat staan, ook al denk je dat de serie is gestopt. Het zou zomaar kunnen dat een serie toch weer verder gaat zonder dat je dat wist, en je als verassing ineens een nieuwe aflevering in je downloads mapje terug kan vinden.
