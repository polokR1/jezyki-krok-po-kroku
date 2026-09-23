import '../domain/models/course.dart';
import 'foundation_catalog.dart';
import 'practice_catalog.dart';

class MultilingualWordSeed {
  const MultilingualWordSeed(
    this.id,
    this.polish,
    this.ukrainian,
    this.english,
    this.spanish,
    this.greek,
    this.swedish,
  );

  final String id;
  final String polish;
  final String ukrainian;
  final String english;
  final String spanish;
  final String greek;
  final String swedish;

  String targetFor(String courseId) => switch (courseId) {
    'english' => english,
    'spanish' => spanish,
    'greek' => greek,
    'swedish' => swedish,
    _ => throw ArgumentError.value(courseId, 'courseId', 'Unknown course'),
  };
}

class MultilingualTopicSeed {
  const MultilingualTopicSeed({
    required this.id,
    required this.titlePl,
    required this.titleUk,
    required this.level,
    required this.words,
  });

  final String id;
  final String titlePl;
  final String titleUk;
  final String level;
  final List<MultilingualWordSeed> words;
}

LanguageCourse buildVocabularyCourse({
  required String id,
  required String languageCode,
  required String speechLocale,
  required LocalizedText name,
  required String nativeName,
  required String flag,
  required int colorValue,
  required List<MultilingualTopicSeed> topics,
}) {
  final foundations = buildFoundationModules(id);
  final skippedTopicIds = id == 'greek'
      ? const {
          'core',
          'introductions',
          'cafe',
          'directions',
          'health_visit',
          'official_matters',
        }
      : const {'core', 'introductions'};
  final orderedTopics = [...topics]
    ..sort(
      (left, right) =>
          _topicOrder.indexOf(left.id).compareTo(_topicOrder.indexOf(right.id)),
    );
  final courseTopics = orderedTopics
      .where((topic) => !skippedTopicIds.contains(topic.id))
      .toList(growable: false);
  return LanguageCourse(
    id: id,
    languageCode: languageCode,
    speechLocale: speechLocale,
    name: name,
    nativeName: nativeName,
    flag: flag,
    colorValue: colorValue,
    grammarLessons: buildGrammarLessons(id),
    dialogues: buildDialogues(id),
    stories: buildStories(id),
    modules: [
      ...foundations,
      for (final topic in courseTopics)
        CourseModule(
          id: '${id}_${topic.id}',
          title: LocalizedText(pl: topic.titlePl, uk: topic.titleUk),
          description: _topicDescription(topic.id),
          level: topic.level,
          lessons: [
            for (var part = 0; part < 4; part++)
              CourseLesson(
                id: '${id}_vocab_${topic.id}_${part + 1}',
                title: LocalizedText(
                  pl: '${topic.titlePl} · ${part + 1}/4',
                  uk: '${topic.titleUk} · ${part + 1}/4',
                ),
                objective: const LocalizedText(
                  pl: 'Poznaj 5 nowych wyrażeń, usłysz je i odtwórz z pamięci',
                  uk: 'Вивчи 5 нових висловів, почуй їх і відтвори з пам’яті',
                ),
                explanation: LocalizedText(
                  pl: '${_lessonStepsPl[part]} ${_courseTipPl(id, part)}',
                  uk: '${_lessonStepsUk[part]} ${_courseTipUk(id, part)}',
                ),
                items: [
                  for (final word in topic.words.skip(part * 5).take(5))
                    LearningItem(
                      id: '${id}_${word.id}',
                      target: word.targetFor(id),
                      translation: LocalizedText(
                        pl: word.polish,
                        uk: word.ukrainian,
                      ),
                    ),
                ],
                minutes: 12,
              ),
          ],
        ),
    ],
  );
}

const _topicOrder = <String>[
  'core',
  'introductions',
  'numbers_time',
  'people',
  'home',
  'daily',
  'food',
  'cafe',
  'shopping',
  'city',
  'directions',
  'calendar',
  'clothing',
  'verbs',
  'nature',
  'work',
  'workplace',
  'travel',
  'services',
  'official_matters',
  'adjectives',
  'emotions',
  'body',
  'health_visit',
  'housing_help',
  'emergency',
  'education',
  'communication',
  'technology',
  'society',
  'thinking',
  'connectors',
];

const _lessonStepsPl = <String>[
  'Najpierw obejrzyj i odsłuchaj każde wyrażenie. Potem rozpoznasz jego znaczenie i zapis.',
  'Łącz nowe słowo z sytuacją, nie tylko z polskim odpowiednikiem. Wypowiedz je na głos.',
  'Po rozpoznawaniu przychodzi aktywne odtwarzanie. Kafelki pojawią się przy całych zwrotach, a krótkie formy wpiszesz samodzielnie.',
  'Ostatnia część miesza słuchanie, znaczenie i samodzielną odpowiedź. Błędne elementy wrócą w powtórkach.',
];
const _lessonStepsUk = <String>[
  'Спочатку переглянь і прослухай кожен вислів. Потім розпізнаєш його значення та написання.',
  'Пов’язуй нове слово із ситуацією, а не лише з перекладом. Вимов його вголос.',
  'Після розпізнавання настає активне відтворення. Для цілих фраз з’являться плитки, а короткі форми введеш самостійно.',
  'Остання частина поєднує слухання, значення і самостійну відповідь. Помилкові елементи повернуться в повтореннях.',
];

String _courseTipPl(String courseId, int part) => switch (courseId) {
  'english' => const [
    'Zauważaj stały szyk: podmiot, czasownik, reszta zdania.',
    'Nie zgaduj wymowy z pisowni — korzystaj z odsłuchu.',
    'W pytaniach zwracaj uwagę na do/does oraz kolejność wyrazów.',
    'Ucz się krótkich połączeń, np. czasownika razem z przyimkiem.',
  ][part],
  'spanish' => const [
    'Samogłoski zachowują wyraźne, stabilne brzmienie.',
    'Końcówka czasownika często mówi, kto wykonuje czynność.',
    'Rodzajnik pomaga zapamiętać rodzaj rzeczownika.',
    'Akcent graficzny jest częścią poprawnego zapisu.',
  ][part],
  'greek' => const [
    'Najpierw czytaj bez transliteracji, nawet jeśli robisz to powoli.',
    'Akcent pokazuje sylabę wymawianą mocniej.',
    'Rodzajnik i końcówka są ważną częścią formy słowa.',
    'Jeśli mylą Ci się znaki, wróć do jednego z pięciu modułów alfabetu.',
  ][part],
  'swedish' => const [
    'Zapamiętuj rzeczownik razem z en albo ett.',
    'Długość samogłoski może zmienić brzmienie i znaczenie.',
    'W zwykłym zdaniu odmieniony czasownik zajmuje zazwyczaj drugą pozycję.',
    'Końcówka rzeczownika często wyraża formę określoną.',
  ][part],
  _ => '',
};

String _courseTipUk(String courseId, int part) => switch (courseId) {
  'english' => const [
    'Помічай сталий порядок: підмет, дієслово, решта речення.',
    'Не вгадуй вимову з написання — користуйся прослуховуванням.',
    'У запитаннях звертай увагу на do/does і порядок слів.',
    'Вчи короткі сполучення, наприклад дієслово разом із прийменником.',
  ][part],
  'spanish' => const [
    'Голосні мають чітке й стабільне звучання.',
    'Закінчення дієслова часто показує, хто виконує дію.',
    'Артикль допомагає запам’ятати рід іменника.',
    'Графічний наголос є частиною правильного написання.',
  ][part],
  'greek' => const [
    'Спочатку читай без транслітерації, навіть якщо повільно.',
    'Наголос показує склад, який вимовляється сильніше.',
    'Артикль і закінчення є важливою частиною форми слова.',
    'Якщо плутаються знаки, повернися до одного з п’яти модулів алфавіту.',
  ][part],
  'swedish' => const [
    'Запам’ятовуй іменник разом з en або ett.',
    'Довжина голосної може змінити звучання і значення.',
    'У звичайному реченні змінене дієслово зазвичай стоїть другим.',
    'Закінчення іменника часто виражає означену форму.',
  ][part],
  _ => '',
};

LocalizedText _topicDescription(String topicId) {
  final description =
      _topicDescriptions[topicId] ??
      const (
        '20 praktycznych słów i zwrotów w czterech krótkich lekcjach',
        '20 практичних слів і фраз у чотирьох коротких уроках',
      );
  return LocalizedText(pl: description.$1, uk: description.$2);
}

const _topicDescriptions = <String, (String, String)>{
  'numbers_time': (
    'Liczby, godziny i podstawowe określanie czasu',
    'Числа, години й основне визначення часу',
  ),
  'people': (
    'Rodzina, relacje i nazywanie osób',
    'Родина, стосунки й назви людей',
  ),
  'home': (
    'Pomieszczenia, meble i przedmioty w domu',
    'Кімнати, меблі й предмети вдома',
  ),
  'daily': (
    'Rutyna od poranka do wieczora',
    'Щоденний розпорядок від ранку до вечора',
  ),
  'food': (
    'Produkty, składniki, smaki i posiłki',
    'Продукти, інгредієнти, смаки та прийоми їжі',
  ),
  'cafe': (
    'Zamawianie, obsługa i płacenie w lokalu',
    'Замовлення, обслуговування й оплата в закладі',
  ),
  'shopping': (
    'Wybór produktu, cena, ilość i płatność',
    'Вибір товару, ціна, кількість і оплата',
  ),
  'city': (
    'Miejsca i obiekty, które spotykasz w mieście',
    'Місця й об’єкти, які зустрічаєш у місті',
  ),
  'directions': (
    'Pytanie o drogę, orientacja i przesiadki',
    'Як запитати дорогу, зорієнтуватися й зробити пересадку',
  ),
  'calendar': (
    'Daty, terminy i umawianie spotkań',
    'Дати, терміни й домовленості про зустрічі',
  ),
  'clothing': (
    'Ubrania, kolory, rozmiary i przymierzanie',
    'Одяг, кольори, розміри й примірювання',
  ),
  'verbs': (
    'Najczęstsze czynności potrzebne do budowania zdań',
    'Найчастіші дії для побудови речень',
  ),
  'nature': (
    'Pogoda, krajobraz i zjawiska przyrodnicze',
    'Погода, краєвид і природні явища',
  ),
  'work': (
    'Zawody, miejsca pracy i podstawowe obowiązki',
    'Професії, місця роботи й основні обов’язки',
  ),
  'workplace': (
    'Polecenia, ustalenia i współpraca w zespole',
    'Доручення, домовленості й командна робота',
  ),
  'travel': (
    'Nocleg, bagaż i przebieg podróży',
    'Ночівля, багаж і перебіг подорожі',
  ),
  'services': (
    'Poczta, bank, naprawa i codzienne usługi',
    'Пошта, банк, ремонт і щоденні послуги',
  ),
  'official_matters': (
    'Dokumenty, formularze i kontakt z urzędem',
    'Документи, форми й звернення до установ',
  ),
  'adjectives': (
    'Cechy, rozmiary i porównywanie rzeczy',
    'Ознаки, розміри й порівняння речей',
  ),
  'emotions': (
    'Nastrój, potrzeby i reakcje w rozmowie',
    'Настрій, потреби й реакції в розмові',
  ),
  'body': (
    'Części ciała, podstawowe objawy i samopoczucie',
    'Частини тіла, основні симптоми й самопочуття',
  ),
  'health_visit': (
    'Rejestracja, rozmowa z lekarzem i zalecenia',
    'Запис, розмова з лікарем і рекомендації',
  ),
  'housing_help': (
    'Zgłaszanie usterek i uzgadnianie naprawy',
    'Повідомлення про несправності й узгодження ремонту',
  ),
  'emergency': (
    'Wołanie o pomoc i przekazywanie ważnych informacji',
    'Виклик допомоги й передавання важливої інформації',
  ),
  'education': (
    'Nauka, szkoła i strategie uczenia się języka',
    'Навчання, школа й стратегії вивчення мови',
  ),
  'communication': (
    'Telefon, wiadomości i podtrzymywanie kontaktu',
    'Телефон, повідомлення й підтримання зв’язку',
  ),
  'technology': (
    'Urządzenia, internet i rozwiązywanie problemów',
    'Пристрої, інтернет і розв’язання проблем',
  ),
  'society': (
    'Życie publiczne, zasady i sprawy społeczne',
    'Суспільне життя, правила й громадські питання',
  ),
  'thinking': (
    'Opinie, argumenty, zgoda i wątpliwości',
    'Думки, аргументи, згода й сумніви',
  ),
  'connectors': (
    'Łączenie zdań w dłuższą, spójną wypowiedź',
    'Поєднання речень у довше зв’язне висловлювання',
  ),
};
