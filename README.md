# Języki Krok po Kroku

Nowa, niezależna aplikacja Flutter do nauki wielu języków. Użytkownik wybiera
kurs, a postęp każdego języka jest przechowywany osobno na urządzeniu.

## Kursy startowe

- angielski (`en-GB`),
- hiszpański (`es-ES`),
- grecki (`el-GR`),
- szwedzki (`sv-SE`).

Każdy kurs ma obecnie 3 moduły startowe, 6 lekcji i 30 elementów nauki.
Wyjaśnienia są dostępne po polsku i ukraińsku.

## Architektura

- `lib/domain` — neutralne modele i silnik ćwiczeń,
- `lib/data/courses` — niezależne pakiety treści poszczególnych języków,
- `lib/state` — wybór kursu, ustawienia i oddzielny postęp,
- `lib/services` — synteza oraz rozpoznawanie mowy z locale kursu,
- `lib/screens` — wybór kursu, ścieżka nauki, lekcja, postęp i ustawienia.

Generator ćwiczeń tworzy zadania wyboru, pisania i słuchania. Porównywanie
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
- wersja początkowa nowego projektu: `0.1.0+1`.

Projekt nie używa danych ani kluczy postępu dawnej aplikacji „Svenska Krok po
Kroku”. Przy pierwszym uruchomieniu usuwa znane stare klucze preferencji.
