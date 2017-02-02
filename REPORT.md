# Report 
## Short description
De mobiele telefoon is erg handig, maar storend tijdens de studie. Deze applicatie bevordert efficiënt studeren door studieblokken bestaand uit studie- en pauzeblokken. De studieblokken zijn door de gebruiker zelf in te stellen. De competitie tussen vrienden zorgt voor extra studiemotivatie.<br>
![Screenshot van de Help Me Study View]
(/doc/timerscherm.png)

## Technical design
Als de applicatie voor het eerst wordt geopend komt de gebruiker in een registreer/inlogscherm. Hier moeten de gegevens ingevuld worden en dan wordt doorverwezen naar het menu. In het menu zijn er vier andere views waar naartoe genavigeerd kan worden. Users, Rankings, Info en Help Me Study. In de UsersViewController zijn alle gebruikers gepresenteerd. Hier kan de gebruiker zoeken naar gebruikers, ze volgen en ontvolgen. In de RankingsViewController worden de gevolgde gebruikers gesorteerd op volgorde van het aantal punten, dat wil zeggen het aantal geleerde minuten. De InfoViewController bevat een uitleg van de applicatie. Deze uitleg verschijnt ook in de vorm van een melding als de gebruiker de applicatie voor het eerst opent. In de Help Me Study ViewController zit een timer voor de studie. De gebruiker kan zelf het aantal minuten instellen voor de leersessie. 

Er wordt van een object gebruik gemaakt namelijk het object Friend. Dit is een object met de eigenschappen van een user. Dit bevat de userID, de naam, de imagePath en het aantal punten. Dit object wordt gebruikt in Users en Rankings voor de tableViews. Hier wordt een array aangemaakt van het object Friend. Daarnaast hebben deze twee tableViews, namelijk FriendsTableView en RankingTableView. Deze hebben allebei een eigen cel, namelijk FriendsCell en FriendRankingCell.

## Challenges and Changes
Uiteindelijk is wel gekozen om een object te gebruiken om data in op te slaan. Aanvankelijk was het idee het zonder objecten, klassen of structs te doen, maar na enige tijd bleek dat dit veel makkelijker was om wel te gebruiken en daarom is er voor deze verandering gekozen. Wel is aangehouden dat alle aparte Views worden bestuurd door een eigen ViewController. De gedachte dat het de applicatie overzichtelijk maakt, is ook zo gebleken en daarom is bij deze keuze gebleven. Van het registreer- en het inlogscherm is een scherm gemaakt om op deze manier de gebruiker een fijnere ervaring te geven. Daarnaast is gekozen om het aantal minuten van de pauze op vijf te stellen, om ervoor te zorgen dat de gebruiker wel gedisciplineerd bezig blijft. 

## Current vs. Other solutions
Omdat de applicatie niet op de achtergrond blijft runnen en de timer dus niet functioneert als de applicatie gesloten is, zijn er hiervoor een aantal tijdelijke oplossingen bedacht. Het op de achtergrond laten runnen van de applicatie was voor nu te tijdrovend en te ingewikkeld, maar indien meer tijd beschikbaar is, is dit de mooiste oplossing. Daarom heb ik gekozen om dit te laten varen en de gebruiker dit te melden. Dit doe ik bij het voor de eerste keer openen van de applicatie, in de InfoView en met een notificatie telkens als de applicatie op de achtergrond gaat.
