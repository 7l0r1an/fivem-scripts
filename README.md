# FiveM Scripts

Colecție de scripturi QBCore scrise de mine în timp ce învăț FiveM development.

## Scripturi

- **delivery-job** — job de livrări cu logică client-server, plăți prin QBCore, progress bars și animații (ox_lib)
- **armor-shop** — magazin de armură cu context menu, sistem de stoc pe server (callbacks) și comenzi admin
- **noclip** — tool de noclip pentru development creat de mine.
- **police-job** — job de poliție (QBCore) cu sistem de dispatch construit de la zero:
  - sistem de duty (on/off) cu verificare de job pe server
  - apeluri de urgență (/911): cetățenii declanșează apeluri care ajung
    la toți polițiștii de serviciu, filtrat pe job și duty
  - meniu de apeluri (ox_lib) cu preluare (claim): un apel preluat dispare
    pentru ceilalți, iar un ofițer nu poate lua un al doilea apel până nu-l
    rezolvă pe primul
  - blip + rută către locația apelului preluat

## Stack
QBCore · ox_lib · MySQL (oxmysql) · client-server events
