# Programmeerproject "Help me study!"
Nadav Israël Zecharja Baruch<br>
Student Science, Business and Innovation<br>
Studentnummer: 11427353<br>
Start van het project: 9-1-2017<br>
# Project proposal
## Korte samenvatting
De mobiele telefoon is erg handig, maar storend tijdens de studie. Deze applicatie bevordert efficiënt studeren door studieblokken bestaand uit studie- en pauzeblokken. De studieblokken zijn door de gebruiker zelf in te stellen. De competitie tussen vrienden zorgt voor extra studiemotivatie. 
## Het probleem
Veel studenten hebben moeite met het concentreren bij het leren. Alle apparaten die men tegenwoordig tot zijn beschikking heeft, maken het niet makkelijker om gefocust te blijven. Met name de mobiele telefoon zorgt voor veel afleiding bij studenten van verschillende leeftijden. Daarom wordt van een probleem een oplossing gemaakt!
## De oplossing
Deze applicatie zorgt ervoor dat de gebruiker zelf kan kiezen op welke manier hij of zij zijn tijd in wil delen. Bijvoorbeeld door te kiezen om in periodes van halve uren te studeren met telkens vaste pauzes van vijf minuten. Er zal dan een notificatie verzonden worden wanneer het halve uur voorbij is en wanneer de pauze voorbij is. Om de applicatie wat interessanter te maken dan alleen nuttig gebruik, kunnen scores vergeleken worden met vrienden. Zo kan de gebruiker zien wie er het hardst heeft geleerd.
## De visualisatie
Hieronder zijn schetsen te zien van de verschillende schermen die de applicatie bevat.<br>
De afbeeldingen staan in de volgende volgorde: Het registratiescherm, het inlogscherm, de usersview, de rankingview en het leerscherm.<br>
![Het registratiescherm]
(/doc/Register.png)
![Het inlogscherm]
(/doc/Login.png)
![Het keuzemenu]
(/doc/Menu.png)
![Het vriendenscherm]
(/doc/Users.png)
![Het klassementscherm]
(/doc/Rankings.png)
![Het leerscherm]
(/doc/Timer.png)
![De gestarte timer]
(/doc/TimerStarted.png)
## Data sets en data sources
Het betreft vooral voorgeprogrammeerde methoden, waar de gebruiker zelf details aan kan veranderen. Zo kan de gebruiker zelf zijn periodes van studie instellen. Daarnaast kan de gebruiker vrienden toevoegen en zichzelf vergelijken met deze vrienden.
## Delen van de applicatie
De applicatie bestaat uit verschillende onderdelen. Zo moet elke nieuwe gebruiker beginnen bij het registratie-/inlogscherm. Hierna volgt een menu waar de gebruiker naar verschillende schermen kan gaan. In dit menu zitten opties naar de volgende views op willekeurige volgorde: Users, Rankings, Info en Help Me Study. Bij Users is er een friendsTableView om de users te zien, te filteren op een zoekopdracht en extra vrienden te volgen en te ontvolgen. In Rankings is de rankingTableView er die laat zien je waar jij staat ten opzichte van je vrienden wat betreft het aantal geleerde minuten. Het Infoscherm geeft een instructie van hoe de applicatie in zijn werk gaat. Als laatste is daar Help Me Study, hetgeen de applicatie om draait. Hier kan de gebruiker instellen hoe lang een studieblok zal duren. Zo zal er een timer komen te staan met een notificatie die verzonden wordt als de leertijd voorbij is en als de leertijd weer begint.
## Externe componenten
Er dient voor deze applicatie data opgeslagen te worden, dit wordt gedaan door middel van Firebase. Hierin gaan alle gebruikersgegevens worden opgeslagen zoals, userID's, emailadressen, wachtwoorden, scores, volgers en gevolgden per user en profielfoto's.
## Verwante applicaties
Er zijn applicaties die enigszins dezelfde insteek hebben als deze applicatie. Deze applicaties visualiseren de timer op een mooie manier, geven grafieken van de hoeveelheid tijd die je gestudeerd hebt en wanneer. Hiermee zou je dus kunnen kijken op welk moment van de dag de gebruiker het vaakst studeert. 
## Copyright Statement
This project has an Apache License,Version 2.0. This code is public so enjoy the code, but please don't hold me liable. For more info check the LICENSE file.
## Gebruikte bronnen
* Help me study viewcontroller
  * https://github.com/kenechilearnscode/UserNotificationsTutorial
  * http://stackoverflow.com/questions/25511945/swift-alert-view-ios8-with-ok-and-cancel-button-which-button-tapped
<br>
* MenuViewController
  * https://www.hackingwithswift.com/example-code/system/how-to-detect-when-your-app-moves-to-the-background
<br>
* FriendsViewController
  * https://www.youtube.com/watch?v=js3gHOuPb28
  * https://github.com/codepath/ios_guides/wiki/Search-Bar-Guide
<br>
* RankingsViewController
  * http://stackoverflow.com/questions/24130026/swift-how-to-sort-array-of-custom-objects-by-property-value
<br>
* StartViewController
  * http://stackoverflow.com/questions/30635160/how-to-check-if-the-ios-app-is-running-for-the-first-time-using-swift
  * http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
  * https://www.youtube.com/watch?v=AsSZulMc7sk
