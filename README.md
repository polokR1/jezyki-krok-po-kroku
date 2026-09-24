# Języki Krok po Kroku

Nowa, niezależna aplikacja Flutter do nauki wielu języków. Użytkownik wybiera
kurs, a postęp każdego języka jest przechowywany osobno na urządzeniu.

## Pełne kursy

- angielski (`en-GB`),
- hiszpański (`es-ES`),
- grecki (`el-GR`),
- szwedzki (`sv-SE`).

Każdy kurs ma 32 uporządkowane moduły, 640 elementów nauki, 128 lekcji
słownictwa, 16 lekcji gramatycznych, 4 dialogi i 4 historie. Daje to 152
aktywności na język oraz 608 aktywności w całej aplikacji. Materiał prowadzi od
A0 do B1–B2, a wyjaśnienia są dostępne po polsku i ukraińsku.

Pierwsze moduły uczą całych zdań przez słuchanie, rozpoznawanie, kafelki i
samodzielne odtwarzanie. Kurs greckiego zaczyna się od pięciu kolejnych modułów
alfabetu: liter, znaków mylących, sylab, dwuznaków oraz pierwszych słów. Każda
lekcja ma własne objaśnienie, kontekst i rozwiniętą wskazówkę wyjaśniającą szyk,
pisownię albo odmianę. Wszystkie moduły można otworzyć od razu; wynik 80%
oznacza zaliczenie, ale nie blokuje wyboru materiału. Trudne elementy trafiają do
zaplanowanych powtórek.

## Architektura

- `lib/domain` — neutralne modele i silnik ćwiczeń,
- `lib/data/courses` — konfiguracja niezależnych kursów,
- `lib/data/generated` — zapisany w aplikacji katalog 2560 tłumaczeń,
- `lib/data/practice_catalog.dart` — gramatyka, dialogi i historie,
- `lib/state` — wybór kursu, ustawienia i oddzielny postęp,
- `lib/services` — synteza oraz rozpoznawanie mowy z locale kursu,
- `lib/screens` — wybór kursu, ścieżka nauki, lekcja, postęp i ustawienia.

Generator ćwiczeń tworzy zadania wyboru w obu kierunkach, pisania, budowania
zdań z kafelków i słuchania. Inteligentne powtórki planują trudne słowa ponownie, a
statystyki obejmują skuteczność, serię dni oraz dzienny cel. Porównywanie
odpowiedzi ignoruje wielkość liter, interpunkcję i najczęstsze znaki
diakrytyczne. Błędy zapisu, syntezy i rozpoznawania mowy są obsługiwane bez
zamykania aplikacji.

## Uruchomienie i kontrola jakości

Wymagane są Flutter SDK 3.44 lub nowszy, Dart 3.12 oraz Android SDK.

```powershell
flutter pub get
flutter test
flutter analyze --no-pub
flutter build apk --debug
```

Na części wersji Fluttera analizator może mieć problem ze ścieżką Windows
zawierającą znaki narodowe. Kompilacja i testy nadal działają, ale do analizy
warto użyć kopii projektu w ścieżce ASCII.

## Identyfikatory

- pakiet Dart: `jezyki_krok_po_kroku`,
- Android/iOS: `pl.jezykikrokpokroku.app`,
- nazwa widoczna: `Języki Krok po Kroku`,
- bieżąca wersja rozwojowa: `0.3.1+4`.

Projekt nie używa danych ani kluczy postępu dawnej aplikacji „Svenska Krok po
Kroku”. Przy pierwszym uruchomieniu usuwa znane stare klucze preferencji.
