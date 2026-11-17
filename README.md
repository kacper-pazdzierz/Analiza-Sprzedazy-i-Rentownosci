# Analiza sprzedaży i rentowności (Superstore)

Analiza bazy zamówień (9 994 rekordy) mająca na celu sprawdzenie, na czym firma zarabia, a gdzie traci marżę przez politykę rabatową.

**Narzędzia:** MySQL (phpMyAdmin), Excel (Power Query)

### Pierwsze wnioski

**Próg opłacalności rabatów:** Zamówienia z rabatem do 20% są rentowne. Od progu 30% w górę każda kolejna grupa rabatowa generuje łączną stratę.

**Pułapka średniej w Binders:** Na poziomie całej podkategorii Binders wynik wygląda dobrze przy średnim rabacie ~37%. Po rozbiciu na progi widać jednak, że zysk pochodzi z transakcji 0–20%, natomiast wyprzedaże na poziomie 70–80% zjadają ponad połowę potencjalnego zysku tego działu.
