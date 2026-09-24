import '../domain/models/course.dart';
import 'foundation_catalog.dart';
import 'language_explanations.dart';
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
                explanation: _lessonExplanation(
                  courseId: id,
                  topicId: topic.id,
                  part: part,
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

LocalizedText _lessonExplanation({
  required String courseId,
  required String topicId,
  required int part,
}) {
  final why = lessonWhy(courseId: courseId, topicId: topicId, part: part);
  return LocalizedText(
    pl: '${why.pl}\n\nJak ćwiczyć? ${_lessonStepsPl[part]}',
    uk: '${why.uk}\n\nЯк тренуватися? ${_lessonStepsUk[part]}',
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
