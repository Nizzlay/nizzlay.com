+++
title = "Welke Gitlab boards ik gebruik als productmanager"
date = "2021-06-26"
aliases = ["/posts/gitlab-boards/"]

[taxonomies]
tags = ["Product Management", "Software Development", "SaaS", "Processes", "Business"]

[extra]
lang = "nl"
+++

Product management in mijn werk doe ik voornamelijk via Gitlab. Op basis van wat boards, en een flow, die ik zelf heb bedacht. Grotendeels agile/scrum, met wat lessen uit mijn GTD verleden. Volledig transparant voor het gehele team.

In principe gebruik ik 3 losse boards om het overzichtelijk te houden, maar het is één overkoepelend proces wat ik eventueel ook op 1 enkel kanban board zou kunnen plaatsen (maar dan moet je zoveel scrollen). Het geheel maakt vooral gebruik van [scoped labels](https://docs.gitlab.com/ee/user/project/labels.html#scoped-labels), om ervoor te zorgen dat een issue zicht altijd maar in één stap binnen het proces kan bevinden.

Issues zijn als zaadjes die je plant, en water geeft zodat ze groeien. Stapje voor stapje komen de issues verder in het proces. Met als doel dat je uiteindelijk een mooi product ontwikkelt.

## Backlog Refinement

Te beginnen met het board wat ik Backlog refinement heb genoemd. Het doel van dit board is om overzicht te hebben in *alle* issues, en in welke fase deze zich momenteel bevinden. Per issue kan ik zien of het verder uitgewerkt moet worden, besproken moet worden met stakeholders, een plan voor gemaakt moet worden met de developers, of klaar is om ingepland te worden in een sprint.

{{< image src="/backlog-refinement.png" alt="Screenshot van het Gitlab board dat ik gebruik voor 'Backlog Refinement'" />}}

### Status: Draft

Een issue begint als draft. Soortgelijk als de GTD inbox. Soms moet je even snel iets noteren zodat je het niet vergeet, maar deze issues zijn nog verre van bruikbaar. Vaak alleen een titel, maar nog geen details. Veel te beknopt om überhaupt met het team te kunnen bespreken. Dit is dus de bak met issues die ik verder uit moet werken.

### Priority: Someday/Maybe

Aangezien we nog niet live zijn (enkel aan het testen met een aantal beta gebruikers) kan ik met hele simpele prioriteit stelling uit de voeten. Prioriteit is daarom vooral iets om de volgordelijkheid aan te geven van welke functionaliteiten ik binnen het product eerst wil ontsluiten. Aangezien we het dan hebben over honderden punten die gebouwd moeten worden, wilde ik een manier om hier in te filteren. Hiervoor heb ik een lesje vanuit GTD geimplementeerd. Alles wat voorlopig nog niet aan de beurt is blijft als Someday/Maybe staan, en dat review ik regelmatig.

### Priority: Next

Next is de volgende stap. Dit zijn de functionaliteiten die binnenkort aan de beurt zijn om gebouwd te worden. De eerstvolgende zaken die uitgewerkt, en besproken moeten worden.

### Status: To be validated

Hier rusten alle issues die uitgewerkt zijn. Op het moment dat iets uitgewerkt is, en ik denk dat het goed is, moet het besproken worden. Besproken met de stakeholders, en met het team.

### Status: Approved Business

Allereerst de discussie met de stakeholders. Zij moeten tenslotte ook aftekenen op de ontwikkelkosten. Op het moment dat ik een meeting heb met belanghebbenden, dan kan ik alle issues uit de vorige stap bespreken. Alles waar we het over eens zijn, en goedgekeurd word komt in deze bak terecht. Nog niet akkoord? Dan gaat het een stapje terug in het proces.

Deze punten zijn enkel *inhoudelijk* door de business goedgekeurd. Over de timing hebben we het nog niet, daar is de sprint planning voor.

### Status: Approved Tech

Dan volgt de discussie met het tech team. Is dit überhaupt wel te bouwen? Is alles duidelijk? Hebben we nog eventuele afhankelijkheden? Hier komt vaak ook naar voren of het uitgewerkte issue misschien niet beter meerdere issues (of zelfs een epic) had moeten zijn.

Ook hier zou het kunnen dat het issue terug gaat in het proces. Bijvoorbeeld omdat er technische beperkingen zijn, en de oplossing zoals omschreven niet kan. Of juist dat er meer mogelijk is dan gedacht, en we het uitgebreider aan kunnen pakken. Dan moeten we het dus opnieuw aanscherpen in de uitwerking, en nogmaals met de business kant bespreken om te checken of we nog in de juiste richting zitten.

### Status: Weigh in

Alles helder, iedereen akkoord. Maar hoeveel werk is het dan eigenlijk? Deze lijst zijn alle punten waar we over moeten pokeren. Wij werken volledig remote, dus voor ons geen kaartjes, maar een Zoom call en een online tool. Belangrijk hier is dat ieder uit het team de ruimte krijgt om zijn eigen inschatting te geven. Om ervoor te zorgen dat het niet op beloftes lijkt (en het zelfvertrouwen van het team te vergroten) gebruiken wij 3-point estimates. Voor elk issue, geeft elk teamlid, 3 punt waarderingen. Positief, realistisch, en negatief. Uiteindelijk pak ik het gemiddelde van iedereen, en dat is het aantal punten wat ik als weight in Gitlab invoer.

### Status: Ready to Build

Nadat weight is ingevuld weten we (ongeveer) hoeveel werk het is. Dan zijn issues klaar om ingepland te worden. Dit is de verzamelbak waar alles blijft staan totdat het ingepland is.

## Planning

Epic boards gebruik ik zelden. Epics worden automatisch in de roadmap correct weergegeven zodra de issues ingepland staan in een sprint.

Voor de planning gebruik ik een board wat vooral alle sprints laat zien, zodat ik issues snel naar de juiste sprint kan slepen om zaken in te plannen.

{{< image src="/gitlab-planning-board.png" alt="Screenshot van het Gitlab board dat ik gebruik om issues in te plannen" />}}

### Status: Ready to Build

Dit board begint in principe met de laatste stap van het vorige board. Daar waren we tot het punt gekomen dat de issues klaar waren om in te plannen, dus de verzamelpak met planbare punten is waar we hier beginnen. In dit board sleep ik deze issues naar de gewenste milestone.

### Milestone: x

Vervolgens heb ik een lijst met alle aankomende milestones (sprints). Dit onderdeel van het board vereist wat onderhoud. Bij aanvang van een nieuwe sprint zorg ik ervoor dat ik oude milestones uit dit board verwijder, en nieuwe toevoeg. Doordat deze allemaal naast elkaar staan kan ik in no time issues inplannen, en eventueel besluiten om issues tussen sprints te verplaatsen.

## Development

Tot slot het board waar de dagelijkse gang van zaken te volgen is. Dit board heeft een filter `Milestone = %#started`, hierdoor toont het alleen issues uit de actieve milestone (sprint). Dit is het board waar we dagelijks naar kijken in de standup.

{{< image src="/gitlab-development-board.png" alt="Screenshot van het Gitlab board met de issues waar deze sprint aan gewerkt wordt" />}}

### To Do

De verzamelbak van issues welke zijn ingepland voor de huidige sprint, maar waar tot nu toe nog niets mee gedaan is. Zodra een teamlid klaar is met zijn huidige taak zal hij één van deze issues oppakken. Op dat moment zal hij zichzelf assignen, en het issue verslepen naar de volgende kolom.

In theorie kun je deze issues in een volgorde zetten, maar dat is een niveau micro managen waar ik niet aan wil beginnen. De teamleden bepalen zelf wie aan welk issue werkt, en welk issue zij als eerstvolgende oppakken. Als productmanager is het voor mij genoeg om te weten dat het in principe deze sprint klaar is.

### Doing

Alle issues waar op dit moment actief aan gewerkt wordt door de teamleden. In principe hanteren wij de regel dat iedereen slechts aan één ding tegelijk werkt, en dit afmaakt voordat iets nieuws opgepakt mag worden. Meestal is dit hierdoor de kortste lijst.

### Code Review

De code voor issue wordt ontwikkeld in een aparte eigen branch. Vanaf het moment dat de eerste letter code is geschreven, en de eerste commit is gedaan, wordt een draft merge request geopend. Zodat het hele team ten alle tijde kunnen zien wat iedereen aan het bouwen is, en geautomatiseerde tests continue kunnen lopen.

Op het moment dat alle benodigde code geschreven is, aan alle acceptatie criteria is voldaan, en (unit) tests zijn toegevoegd.. Dan gaat het issue door naar de code review. Dit is het moment dat de merge request van status draft wordt afgehaald, en dat de andere teamleden actief wordt gevraagd om kritisch naar de code te kijken. Om het voor de teamleden te versimpelen hebben we hiervoor ook [sonarcloud](https://sonarcloud.io/) geimplementeerd, zodat code review deels geautomatiseerd is en teamleden zich kunnen focussen op de diepgaandere review.

### QA

Nadat de developers het eens zijn over de opgeleverde code is het tijd dat testers zich er mee gaan bemoeien. In de quality assurance fase wordt de oplossing uitvoerig gecheckt. De testers controleren of de oplossing daadwerkelijk aan alle acceptatie criteria voldoet, testen of er door de implementatie niet toevallig iets anders stuk is gegaan, en proberen het product stuk te maken door de oplossing op onverwachtte manieren te gebruiken.

Goed of niet goed? De tester voegt altijd haar bevindingen toe aan het issue.

Mochten er punten boven water komen waardoor de kwaliteit in twijfel kan worden getrokken, gaat het issue terug in het proces. Was alles perfect, dan word het issue nu gesloten.
