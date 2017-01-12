# Design document
## Klassen 
Aangezien een groot deel van de applicatie geen klassen nodig heeft, worden deze ook achterwege gelaten. Om het overzichtelijk te houden, is het makkelijk om voor elk scherm de bijbehorende code te voegen in plaats van dit op een aparte plek te houden. Aangezien er niet veel schermen zijn, zou dit overzichtelijk moeten blijven. Als er tijdens het proces tegen problemen aangelopen wordt die opgelost kunnen worden door het wel apart van elkaar te plaatsen of met behulp van klassen, zal hier zeker over nagedacht worden. Zo zouden bijvoorbeeld voor de gebruikersgegevens een klasse kunnen worden gebruikt, maar is dit niet nodig naar mijn idee, dus wordt dit met de huidige kennis achterwege gelaten. 
## Schetsen
Hier een overzicht van hoe de applicatie in zijn werk gaat en hoe de verschillende schermen met elkaar verbonden zijn.<br> 
![Het overzicht van alle schermen]
(/doc/Schermafbeelding 2017-01-10 om 13.56.02.png)
## API’s, Frameworks en plugins
Deze applicatie maakt geen gebruik van API’s, omdat er geen data gehaald dient te worden van een externe bron. Voor het gebruik van een timer om de leertijd te laten lopen hoeft in principe geen extern framework of plugin gebruikt te worden. Daarentegen is het wel interessant om de applicatie een professionele lay-out te geven, hier zijn misschien wel frameworks of plugins voor nodig.
## Externe databronnen
Er wordt geen gebruik gemaakt van externe databronnen zoals datasets en dergelijke. De gebruiker geeft zelf input in de vorm van de gewenste hoeveelheid leertijd en hoe hij of zij deze wil verdelen in leerrondes en pauzes.
## Databasegebruik
Binnen de database (Firebase) worden een aantal dingen opgeslagen. Denk hierbij aan de gebruikersgegevens zoals de naam, emailadres en wachtwoord. Daarnaast is het mogelijk om vrienden toe te voegen en dus worden deze per gebruiker opgeslagen. In het klassement is te zien hoeveel tijd de gebruiker en zijn vrienden geleerd hebben en worden ze gerangschikt naar het aantal geleerde minuten. De minuten moeten dus ook worden opgeslagen per gebruiker. 
