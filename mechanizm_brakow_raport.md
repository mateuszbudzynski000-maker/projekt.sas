## 2. Mechanizm braków danych

### Zakres braków

Braki dotyczą wyłącznie zmiennej celu `Y_NEWDEPOSIT`: **1469 z 9992 obserwacji (14,7%)**. Pozostałe cechy są kompletne, w tym `AGE`. `EDUCATION` ma kategorię „unknown” (446 klientów), ale to wartość występująca w danych, a nie brak. Zbiór ma więc jeden wzorzec braków (brak tylko w Y).

### Cechy skokowe

Test χ² dla tabeli cecha × `R_Y` (`R_Y = 1` oznacza brak Y):

| Cecha | Odsetek braków Y w kategoriach | χ² (df) | p | V Craméra |
|---|---|---|---|---|
| CONTACT | 0: 20,0%; A: 10,9%; B: 30,0% | 261,2 (2) | <0,0001 | 0,162 |
| POUTCOME | failure: 10,3%; other: 15,8%; success: 44,0%; unknown: 14,1% | 248,8 (3) | <0,0001 | 0,158 |
| HOUSE_LOAN | no: 16,7%; yes: 13,1% | 24,9 (1) | <0,0001 | 0,050 |
| EDUCATION | primary: 14,6%; secondary: 14,6%; tertiary: 14,5%; unknown: 18,2% | 4,46 (3) | 0,216 | 0,021 |

Braki są wyraźnie nierówno rozłożone między kanałami: przy kanale B brakuje trzy razy więcej wartości niż przy A (30,0% wobec 10,9%). To ważne dla kontrastu A vs B, bo przy analizie tylko obserwacji kompletnych porównywałoby się grupy o bardzo różnej utracie danych. Największy odsetek braków (44%) mają klienci z poprzednim sukcesem (`POUTCOME = success`).

### AGE (cecha ciągła)

Wariancje w obu grupach różnią się (test F: p < 0,0001), więc stosuję test t Satterthwaite'a. Klienci z brakiem Y są średnio starsi (41,84 wobec 40,89 lat). Różnica to 0,95 roku (95% PU: 0,31–1,60), t = −2,90, p = 0,0037. Efekt jest istotny, ale praktycznie niewielki.

### Model logitowy dla R_Y

Model zawiera wszystkie cechy, w tym `EDUCATION`. Jest wyraźnie lepszy od modelu bez cech (test ilorazu wiarygodności 512,5, df = 10, p < 0,0001). Zdolność dyskryminacyjna jest umiarkowana (AUC = 0,678).

| Efekt (test Type 3) | χ² Walda | p | Iloraz szans braku (95% PU) |
|---|---|---|---|
| CONTACT | 304,4 | <0,0001 | A vs 0: 0,36 (0,31–0,41); B vs 0: 1,41 (1,15–1,73) |
| POUTCOME | 251,0 | <0,0001 | success vs unknown: 6,70 (5,28–8,51); other vs unknown: 1,71 (1,27–2,31); failure vs unknown: 1,08 (0,86–1,34) |
| HOUSE_LOAN | 30,1 | <0,0001 | no vs yes: 1,41 (1,25–1,60) |
| AGE | 0,35 | 0,557 | 0,998 (0,993–1,004) |
| EDUCATION | 4,91 | 0,179 | wszystkie przedziały ufności zawierają 1 |

Po uwzględnieniu pozostałych cech `AGE` przestaje być istotny (p = 0,557). Jednowymiarowa różnica wieku wynika więc ze związku `AGE` z `CONTACT`, `POUTCOME` i `HOUSE_LOAN`, a nie z samego wieku. Z kontrastu kanałów wynika dodatkowo, że szansa braku Y przy A wobec B wynosi około 0,26 (exp(−1,019 − 0,343)).

### Wniosek

1. **MCAR nie obroni się.** Odrzucamy go dla `CONTACT`, `POUTCOME` i `HOUSE_LOAN` z p < 0,0001. Analiza na obserwacjach kompletnych (przy MCAR) może więc być obciążona.
2. **Założenie MAR jest wiarygodne, ale niesprawdzalne.** Prawdopodobieństwo braku dobrze tłumaczą zmienne obserwowane, a `CONTACT` i `HOUSE_LOAN` są też w modelu analitycznym. Danych nie da się jednak użyć do wykluczenia MNAR, czyli zależności braku od samej wartości Y. Warto go sprawdzić analizą wrażliwości (osoba 5).
3. **Cechy do modelu imputacyjnego.** Obowiązkowo `CONTACT`, `AGE`, `HOUSE_LOAN` i `POUTCOME`, bo model imputacyjny musi zawierać wszystkie zmienne modelu analitycznego (także `AGE`, mimo że sam nie tłumaczy braków). Ponadto zalecam `EDUCATION` jako zmienną pomocniczą. Nie tłumaczy ona braków (p = 0,18), ale w obserwowanych danych wyraźnie wiąże się z Y: zakup deklaruje 6,9% klientów z wykształceniem wyższym wobec 4,1% w pozostałych grupach (χ², p < 0,0001). Dzięki temu poprawia przewidywanie Y w imputacji i zmniejsza wariancję oszacowań, a nie szkodzi ich obciążeniu.
4. **Interakcje.** Przy bardzo różnych odsetkach braków w kanałach warto sprawdzić model imputacyjny z interakcjami `CONTACT` z pozostałymi cechami albo imputować osobno w kanałach. Zastosowany skrypt tego testu nie obejmuje.
