# Process Book
## Week 1
### Day 1
De eerste dag van het project stond in teken van het op papier zetten van het idee in de vorm van het README bestand. Toen de eerste schetsen en ideeën op papier kwamen, werd het duidelijk dat er hoogstwaarschijnlijk nog veel gaat veranderen ten opzichte van het eindproduct.
### Day 2
Nadat de eerste grove lijnen waren uitgezet, werd het tijd om er wat gedetailleerder op in te gaan. Wat hierin beschreven is, is terug te lezen in het DESIGN bestand.
### Day 3
De eerste teambesprekingen vonden plaats. Helaas ben ik ziek wakker geworden waardoor ik deze dag er niet bij kon zijn. Wel zijn er vorderingen gemaakt in het DESIGN bestand en is deze ook afgemaakt. Tevens is de start van de applicatie zelf ook gemaakt.
### Day 4
Ik voelde me iets beter dus besloot om naar de universiteit te gaan. Ik ben vroegtijdig weer naar huis gegaan. Niet veel vooruitgang is geboekt.
### Day 5
Helaas voel ik mij alleen maar slechter, wat ook geen positieve invloed heeft op de vorderingen van het project.

## Week 2
### Day 1
Omdat ik niet veel gedaan heb toen ik ziek was, moest er nu een inhaalslag worden gemaakt. De basis voor de registratie- en de inlogmogelijkheid is gelegd. Hier gaat het emailadres opgeslagen worden, de naam en wachtwoord. Deze worden opgeslagen in Firebase onder de naam users.

### Day 2 
De timer was nog niet helemaal werkend en de registratie- en de inlogmogelijkheid is nog verder uitgewerkt. De timer werkt alsvolgt, als de tijd wordt ingesteld door de gebruiker en volgt er een timer voor dit aantal minuten. Dan heeft de gebruiker een pauze van vijf minuten en volgt er weer een leersessie enzovoort. Door middel van functies die elkaar aanroepen, blijft de timer lopen tot er op stop wordt gedrukt of de viewcontroller wordt verlaten.

### Day 3
De registratie- en de inlogmogelijkheid werken beiden. Dit heeft best wat tijd gekost, maar ik ben erg tevreden dat het gelukt is. 

### Day 4
Layout is bijgewerkt, er is verder gegaan met de timer. Deze functies zitten in elkaar verwerkt en zijn dus best lastig, vooral bij het testen. Ik heb audio erin verwerkt zodat je hoort als de timer voorbij is. Misschien is het verstandig dit te vervangen door een notificatie met geluid.

### Day 5
Vandaag zijn presentaties. Aangezien ik gemerkt heb dat ik achterloop vanwege het feit dat ik ziek was, moet het volgende weken allemaal net wat sneller. Een aantal goede tips zijn verkregen en worden over gedacht tijdens het weekend.

## Week 3
### Day 1
De viewcontroller waar de users in worden geladen werkt en follow en unfollow werken. In Firebase heeft elke gebruiker een lijst met followers en following door middel van het ID dat Firebase meegeeft aan de gebruiker. Een aantal bugs zijn opgelost. In de ranking moeten de gevolgde gebruikers zichtbaar zijn op volgorde van het aantal geleerde minuten. Dit wil nog niet helemaal lukken. 

### Day 2
In de view waar de users worden ingeladen, ga je op zoek naar je vrienden en hiervoor wil ik een searchbar gebruiken. Dit werkt met een array waarin de data uit Firebase opgehaald wordt en een waarin de gefilterde users in komen, gefilterd op de zoekopdracht van de gebruiker. Hier ben ik vandaag mee begonnen. Tevens is veel error-handling is opgezet vandaag zodat dat niet later nog vergeten kan worden. Een belangrijke bug wat betreft de navigation controller is opgelost.

### Day 3
Punten zijn handmatig toegevoegd aan Firebase om te kijken of het ordenen van de followers in de ranking werkt en dat doet het. Ik heb hiervoor een functie geschreven die checkt het aantal punten van de gebruiker hoger is dan die van de anderen. Op deze manier worden de gebruikers gesorteerd in een array. Nu moeten de punten nog automatisch worden geüpdate. Dit komt erbij in de Help Me Study viewcontroller.

### Day 4
Notificaties zijn toegevoegd, maar aangezien de applicatie niet op de achtergrond doorloopt is het nodig om de applicatie aan te laten om het goed te laten functioneren. De punten worden automatisch geüpdate bij elke minuut die word geteld en de layout is weer bijgwerkt.

### Day 5
Bij de presenaties is vooral gelet op de codekwaliteit met behulp van Bettercodehub. Een aantal tips die gegeven werden zijn handig en ga ik proberen toe te passen.

## Week 4
### Day 1
Aangezien de searchbar niet werkte zoals ik wilde, besloot ik een andere aanpak te gebruiken. Dit kost weliswaar tijd, maar dit vind ik een belangrijke functie binnen mijn applicatie.

### Day 2
Nog steeds zit er een fout in mijn search bar, alhoewel deze al wel is verbeterd. Zelfs met hulp van Julian, is het niet gelukt. Blijkt dat ik de structuur van Firebase daarvoor moet aanpassen en dat is voor nu te kortdag. Nog wat layout is gedaan vandaag. Er is tevens een begin gemaakt aan het verslag.

### Day 3
Vandaag zijn de laatste wijzigingen aangebracht aan de applicatie. Alles is gebruiksvriendelijk gemaakt, de code is opgeschoond wat betreft gecommente code, printstatements en dergelijke. Ook is er een melding ingebouwd met instructies de eerste keer dat de applicatie geopend wordt, deze instructies zijn terug te lezen in de Info viewcontroller. Omdat het laten runnen van de applicatie op de achtergrond te veel werk is voor nu en omdat het volgens Julian ook erg lastig schijnt te zijn, laat ik het gaan. Daarom heb ik een melding ingebouwd telkens als de applicatie verlaten wordt, dat de timer niet doorloopt als herinnering voor de gebruiker. Tevens is er een melding ingebouwd als de gebruiker stopt met studeren.
