import '../domain/models/course.dart';

class _PhraseSeed {
  const _PhraseSeed(
    this.id,
    this.pl,
    this.uk,
    this.en,
    this.es,
    this.el,
    this.sv,
  );

  final String id;
  final String pl;
  final String uk;
  final String en;
  final String es;
  final String el;
  final String sv;

  String targetFor(String courseId) => switch (courseId) {
    'english' => en,
    'spanish' => es,
    'greek' => el,
    'swedish' => sv,
    _ => throw ArgumentError.value(courseId, 'courseId', 'Unknown course'),
  };
}

class _AlphabetSeed {
  const _AlphabetSeed(this.target, this.pl, this.uk, [this.pronunciation]);

  final String target;
  final String pl;
  final String uk;
  final String? pronunciation;
}

List<CourseModule> buildFoundationModules(String courseId) {
  if (courseId == 'greek') {
    return [
      for (var index = 0; index < _greekAlphabetModules.length; index++)
        _buildAlphabetModule(index, _greekAlphabetModules[index]),
      _buildPhraseModule(courseId, 0, _starterPhrases.take(20).toList()),
    ];
  }
  return [
    _buildPhraseModule(courseId, 0, _starterPhrases.take(20).toList()),
    _buildPhraseModule(courseId, 1, _starterPhrases.skip(20).take(20).toList()),
  ];
}

CourseModule _buildPhraseModule(
  String courseId,
  int moduleIndex,
  List<_PhraseSeed> phrases,
) {
  final first = moduleIndex == 0;
  return CourseModule(
    id: '${courseId}_foundation_${moduleIndex + 1}',
    title: LocalizedText(
      pl: first ? 'Start: pierwsze zdania' : 'Start: radzę sobie w rozmowie',
      uk: first ? 'Старт: перші речення' : 'Старт: даю собі раду в розмові',
    ),
    description: LocalizedText(
      pl: first
          ? 'Najważniejsze zwroty od razu w pełnych zdaniach'
          : 'Pytania i odpowiedzi potrzebne w codziennych sytuacjach',
      uk: first
          ? 'Найважливіші фрази одразу в повних реченнях'
          : 'Запитання й відповіді для щоденних ситуацій',
    ),
    level: 'A0',
    lessons: [
      for (var part = 0; part < 4; part++)
        CourseLesson(
          id: '${courseId}_foundation_${moduleIndex + 1}_${part + 1}',
          title: LocalizedText(
            pl: _foundationLessonTitlesPl[part],
            uk: _foundationLessonTitlesUk[part],
          ),
          objective: LocalizedText(
            pl: _foundationObjectivesPl[part],
            uk: _foundationObjectivesUk[part],
          ),
          explanation: LocalizedText(
            pl: '${_foundationExplanationsPl[part]} ${_languageTipPl(courseId, part)}',
            uk: '${_foundationExplanationsUk[part]} ${_languageTipUk(courseId, part)}',
          ),
          items: [
            for (final phrase in phrases.skip(part * 5).take(5))
              LearningItem(
                id: '${courseId}_foundation_${phrase.id}',
                target: phrase.targetFor(courseId),
                translation: LocalizedText(pl: phrase.pl, uk: phrase.uk),
              ),
          ],
          minutes: 10,
        ),
    ],
  );
}

CourseModule _buildAlphabetModule(int moduleIndex, List<_AlphabetSeed> seeds) {
  return CourseModule(
    id: 'greek_alphabet_${moduleIndex + 1}',
    title: LocalizedText(
      pl: _greekAlphabetTitlesPl[moduleIndex],
      uk: _greekAlphabetTitlesUk[moduleIndex],
    ),
    description: LocalizedText(
      pl: _greekAlphabetDescriptionsPl[moduleIndex],
      uk: _greekAlphabetDescriptionsUk[moduleIndex],
    ),
    level: 'A0',
    lessons: [
      for (var part = 0; part < 4; part++)
        CourseLesson(
          id: 'greek_alphabet_${moduleIndex + 1}_${part + 1}',
          title: LocalizedText(
            pl: 'Alfabet ${moduleIndex + 1} · krok ${part + 1}/4',
            uk: 'Алфавіт ${moduleIndex + 1} · крок ${part + 1}/4',
          ),
          objective: LocalizedText(
            pl: _alphabetObjectivesPl[part],
            uk: _alphabetObjectivesUk[part],
          ),
          explanation: LocalizedText(
            pl: '${_alphabetExplanationsPl[part]} ${_greekAlphabetTipsPl[moduleIndex]}',
            uk: '${_alphabetExplanationsUk[part]} ${_greekAlphabetTipsUk[moduleIndex]}',
          ),
          items: [
            for (var itemIndex = 0; itemIndex < 5; itemIndex++)
              LearningItem(
                id: 'greek_alphabet_${moduleIndex + 1}_${part + 1}_${itemIndex + 1}',
                target: seeds[part * 5 + itemIndex].target,
                translation: LocalizedText(
                  pl: seeds[part * 5 + itemIndex].pl,
                  uk: seeds[part * 5 + itemIndex].uk,
                ),
                pronunciation: seeds[part * 5 + itemIndex].pronunciation,
              ),
          ],
          minutes: 8,
        ),
    ],
  );
}

const _foundationLessonTitlesPl = <String>[
  'Zauważ i posłuchaj',
  'Rozpoznaj znaczenie',
  'Ułóż zdania z kafelków',
  'Powiedz bez podpowiedzi',
];
const _foundationLessonTitlesUk = <String>[
  'Поміть і послухай',
  'Розпізнай значення',
  'Склади речення з плиток',
  'Скажи без підказки',
];
const _foundationObjectivesPl = <String>[
  'Poznaj 5 zwrotów i ich brzmienie',
  'Połącz formę ze znaczeniem',
  'Odtwórz prawidłowy szyk zdania',
  'Przywołaj zwroty z pamięci',
];
const _foundationObjectivesUk = <String>[
  'Вивчи 5 фраз та їх звучання',
  'Поєднай форму зі значенням',
  'Відтвори правильний порядок слів',
  'Пригадай фрази з пам’яті',
];
const _foundationExplanationsPl = <String>[
  'Najpierw słuchaj i zauważaj wzór. Nie próbuj zapamiętać wszystkiego po jednym pokazaniu.',
  'Rozpoznawanie jest łatwiejsze niż samodzielne mówienie, dlatego stanowi bezpieczny drugi krok.',
  'Kafelki uczą szyku bez obciążania pamięci pisownią. Czytaj całe zdanie po ułożeniu.',
  'Aktywne odtwarzanie wzmacnia pamięć. Błąd jest sygnałem do szybszej powtórki, nie karą.',
];
const _foundationExplanationsUk = <String>[
  'Спочатку слухай і помічай схему. Не намагайся запам’ятати все після одного показу.',
  'Розпізнавання легше за самостійне мовлення, тому це безпечний другий крок.',
  'Плитки навчають порядку слів без зайвого навантаження правописом. Після складання прочитай усе речення.',
  'Активне пригадування зміцнює пам’ять. Помилка означає швидше повторення, а не покарання.',
];

String _languageTipPl(String courseId, int part) => switch (courseId) {
  'english' => const [
    'W angielskim podmiot zwykle stoi przed czasownikiem.',
    'Zwróć uwagę na krótkie formy I’m i don’t.',
    'W pytaniu operator często pojawia się przed podmiotem.',
    'Powtarzaj całe połączenia słów, nie pojedyncze tłumaczenia.',
  ][part],
  'spanish' => const [
    'W hiszpańskim akcent i samogłoski wymawia się wyraźnie.',
    'Podmiot bywa pomijany, bo osobę wskazuje końcówka czasownika.',
    'Pytanie zapisuje się między znakami ¿ oraz ?.',
    'Ucz się rzeczownika razem z rodzajnikiem, gdy się pojawia.',
  ][part],
  'greek' => const [
    'Czytaj powoli i zawsze zauważaj znak akcentu.',
    'Końcówka czasownika często wskazuje osobę.',
    'Nie zamieniaj greckich liter na podobne litery łacińskie.',
    'Najpierw odtwórz brzmienie, dopiero potem sprawdzaj zapis.',
  ][part],
  'swedish' => const [
    'Słuchaj długości samogłosek i melodii całego zwrotu.',
    'Rzeczowniki najlepiej zapamiętywać razem z en albo ett.',
    'W zdaniu oznajmującym odmieniony czasownik zajmuje zwykle drugą pozycję.',
    'Powtarzaj całe zwroty z naturalnym rytmem.',
  ][part],
  _ => '',
};

String _languageTipUk(String courseId, int part) => switch (courseId) {
  'english' => const [
    'В англійській підмет зазвичай стоїть перед дієсловом.',
    'Звертай увагу на короткі форми I’m і don’t.',
    'У запитанні допоміжне дієслово часто стоїть перед підметом.',
    'Вчи цілі сполучення слів, а не окремі переклади.',
  ][part],
  'spanish' => const [
    'В іспанській наголос і голосні вимовляються виразно.',
    'Підмет часто пропускають, бо особу показує закінчення дієслова.',
    'Запитання пишеться між знаками ¿ та ?.',
    'Коли є артикль, вчи іменник разом із ним.',
  ][part],
  'greek' => const [
    'Читай повільно й завжди помічай знак наголосу.',
    'Закінчення дієслова часто показує особу.',
    'Не замінюй грецькі літери схожими латинськими.',
    'Спочатку відтвори звучання, а потім перевір написання.',
  ][part],
  'swedish' => const [
    'Слухай довжину голосних і мелодику всієї фрази.',
    'Іменники найкраще вчити разом з en або ett.',
    'У розповідному реченні змінене дієслово зазвичай стоїть другим.',
    'Повторюй цілі фрази з природним ритмом.',
  ][part],
  _ => '',
};

const _alphabetObjectivesPl = <String>[
  'Zobacz znaki i połącz je z dźwiękiem',
  'Rozpoznaj litery bez pomocy alfabetu łacińskiego',
  'Przeczytaj znaki w zmienionej kolejności',
  'Odtwórz zapis i brzmienie z pamięci',
];
const _alphabetObjectivesUk = <String>[
  'Побач знаки та поєднай їх зі звуком',
  'Розпізнай літери без допомоги латинки',
  'Прочитай знаки в зміненому порядку',
  'Відтвори написання і звучання з пам’яті',
];
const _alphabetExplanationsPl = <String>[
  'Grecki zapis jest nowy, więc uczymy się maksymalnie pięciu znaków naraz.',
  'Drugi kontakt następuje w tym samym module, ale wymaga już samodzielnego rozpoznania.',
  'Zmiana kolejności zapobiega zapamiętywaniu wyłącznie układu alfabetu.',
  'Ta sama umiejętność wróci w kolejnych modułach jako sylaba, połączenie liter i prawdziwe słowo.',
];
const _alphabetExplanationsUk = <String>[
  'Грецьке письмо нове, тому за раз вивчаємо не більше п’яти знаків.',
  'Другий контакт відбувається в тому самому модулі, але вже потребує самостійного розпізнавання.',
  'Зміна порядку не дає запам’ятовувати лише послідовність алфавіту.',
  'Та сама навичка повернеться як склад, буквосполучення і справжнє слово.',
];

const _greekAlphabetTitlesPl = <String>[
  'Alfabet 1: podstawowe litery',
  'Alfabet 2: znaki mylące',
  'Alfabet 3: czytanie sylab',
  'Alfabet 4: połączenia liter',
  'Alfabet 5: pierwsze słowa',
];
const _greekAlphabetTitlesUk = <String>[
  'Алфавіт 1: основні літери',
  'Алфавіт 2: оманливі знаки',
  'Алфавіт 3: читання складів',
  'Алфавіт 4: буквосполучення',
  'Алфавіт 5: перші слова',
];
const _greekAlphabetDescriptionsPl = <String>[
  '20 liter: kształt, nazwa i podstawowy dźwięk',
  'Pozostałe litery, akcent i pułapki podobnych znaków',
  'Od pojedynczych liter do prostych sylab',
  'Dwuznaki i dźwięki charakterystyczne dla greckiego',
  'Czytanie krótkich, potrzebnych słów bez transliteracji',
];
const _greekAlphabetDescriptionsUk = <String>[
  '20 літер: форма, назва та основний звук',
  'Решта літер, наголос і пастки схожих знаків',
  'Від окремих літер до простих складів',
  'Диграфи та характерні грецькі звуки',
  'Читання коротких потрібних слів без транслітерації',
];
const _greekAlphabetTipsPl = <String>[
  'Najpierw wiąż znak z dźwiękiem, a nazwę litery traktuj pomocniczo.',
  'Β brzmi jak polskie „w”, Ρ jak „r”, a Η jak „i” — wygląd może mylić.',
  'Czytaj sylabę jednym ruchem, bez literowania w głowie.',
  'Dwuznaki tworzą jeden dźwięk; ucz się ich jak pojedynczych jednostek.',
  'Nie używamy transliteracji, bo celem jest bezpośrednie czytanie greckiego zapisu.',
];
const _greekAlphabetTipsUk = <String>[
  'Спочатку пов’язуй знак зі звуком, а назву літери сприймай як допоміжну.',
  'Β звучить як «в», Ρ як «р», а Η як «і» — вигляд може вводити в оману.',
  'Читай склад одним рухом, не називаючи кожну літеру подумки.',
  'Диграфи утворюють один звук; вчи їх як цілісні одиниці.',
  'Ми не використовуємо транслітерацію, бо мета — читати грецький запис безпосередньо.',
];

const _starterPhrases = <_PhraseSeed>[
  _PhraseSeed(
    'hello',
    'Dzień dobry.',
    'Добрий день.',
    'Hello.',
    'Hola.',
    'Γεια σας.',
    'Hej.',
  ),
  _PhraseSeed(
    'good_morning',
    'Dzień dobry rano.',
    'Доброго ранку.',
    'Good morning.',
    'Buenos días.',
    'Καλημέρα.',
    'God morgon.',
  ),
  _PhraseSeed(
    'good_evening',
    'Dobry wieczór.',
    'Добрий вечір.',
    'Good evening.',
    'Buenas tardes.',
    'Καλησπέρα.',
    'God kväll.',
  ),
  _PhraseSeed(
    'goodbye',
    'Do widzenia.',
    'До побачення.',
    'Goodbye.',
    'Adiós.',
    'Αντίο.',
    'Hej då.',
  ),
  _PhraseSeed(
    'thanks',
    'Dziękuję.',
    'Дякую.',
    'Thank you.',
    'Gracias.',
    'Ευχαριστώ.',
    'Tack.',
  ),
  _PhraseSeed(
    'please',
    'Proszę.',
    'Будь ласка.',
    'Please.',
    'Por favor.',
    'Παρακαλώ.',
    'Snälla.',
  ),
  _PhraseSeed(
    'my_name',
    'Mam na imię…',
    'Мене звати…',
    'My name is…',
    'Me llamo…',
    'Με λένε…',
    'Jag heter…',
  ),
  _PhraseSeed(
    'from_poland',
    'Jestem z Polski.',
    'Я з Польщі.',
    'I am from Poland.',
    'Soy de Polonia.',
    'Είμαι από την Πολωνία.',
    'Jag kommer från Polen.',
  ),
  _PhraseSeed(
    'live_here',
    'Mieszkam tutaj.',
    'Я живу тут.',
    'I live here.',
    'Vivo aquí.',
    'Μένω εδώ.',
    'Jag bor här.',
  ),
  _PhraseSeed(
    'speak_little',
    'Mówię trochę w tym języku.',
    'Я трохи розмовляю цією мовою.',
    'I speak a little English.',
    'Hablo un poco de español.',
    'Μιλάω λίγα ελληνικά.',
    'Jag talar lite svenska.',
  ),
  _PhraseSeed(
    'not_understand',
    'Nie rozumiem.',
    'Я не розумію.',
    "I don't understand.",
    'No entiendo.',
    'Δεν καταλαβαίνω.',
    'Jag förstår inte.',
  ),
  _PhraseSeed(
    'repeat',
    'Proszę powtórzyć.',
    'Повторіть, будь ласка.',
    'Please repeat.',
    'Repita, por favor.',
    'Παρακαλώ, επαναλάβετε.',
    'Upprepa, tack.',
  ),
  _PhraseSeed(
    'slowly',
    'Proszę mówić wolniej.',
    'Говоріть повільніше, будь ласка.',
    'Please speak slowly.',
    'Hable más despacio, por favor.',
    'Παρακαλώ, μιλήστε πιο αργά.',
    'Tala långsammare, tack.',
  ),
  _PhraseSeed(
    'meaning',
    'Co to znaczy?',
    'Що це означає?',
    'What does this mean?',
    '¿Qué significa esto?',
    'Τι σημαίνει αυτό;',
    'Vad betyder det här?',
  ),
  _PhraseSeed(
    'how_are_you',
    'Jak się masz?',
    'Як справи?',
    'How are you?',
    '¿Cómo está?',
    'Τι κάνετε;',
    'Hur mår du?',
  ),
  _PhraseSeed(
    'fine',
    'Mam się dobrze.',
    'У мене все добре.',
    "I'm fine.",
    'Estoy bien.',
    'Είμαι καλά.',
    'Jag mår bra.',
  ),
  _PhraseSeed('yes', 'Tak.', 'Так.', 'Yes.', 'Sí.', 'Ναι.', 'Ja.'),
  _PhraseSeed('no', 'Nie.', 'Ні.', 'No.', 'No.', 'Όχι.', 'Nej.'),
  _PhraseSeed(
    'excuse_me',
    'Przepraszam.',
    'Перепрошую.',
    'Excuse me.',
    'Disculpe.',
    'Συγγνώμη.',
    'Ursäkta.',
  ),
  _PhraseSeed(
    'help_me',
    'Czy może mi Pan/Pani pomóc?',
    'Можете мені допомогти?',
    'Can you help me?',
    '¿Puede ayudarme?',
    'Μπορείτε να με βοηθήσετε;',
    'Kan du hjälpa mig?',
  ),
  _PhraseSeed(
    'water',
    'Poproszę wodę.',
    'Я хотів би води.',
    'I would like water.',
    'Quisiera agua.',
    'Θα ήθελα νερό.',
    'Jag skulle vilja ha vatten.',
  ),
  _PhraseSeed(
    'toilet',
    'Gdzie jest toaleta?',
    'Де туалет?',
    'Where is the toilet?',
    '¿Dónde está el baño?',
    'Πού είναι η τουαλέτα;',
    'Var är toaletten?',
  ),
  _PhraseSeed(
    'cost',
    'Ile to kosztuje?',
    'Скільки це коштує?',
    'How much does it cost?',
    '¿Cuánto cuesta?',
    'Πόσο κοστίζει;',
    'Hur mycket kostar det?',
  ),
  _PhraseSeed(
    'ticket',
    'Potrzebuję biletu.',
    'Мені потрібен квиток.',
    'I need a ticket.',
    'Necesito un billete.',
    'Χρειάζομαι ένα εισιτήριο.',
    'Jag behöver en biljett.',
  ),
  _PhraseSeed(
    'time',
    'Która jest godzina?',
    'Котра година?',
    'What time is it?',
    '¿Qué hora es?',
    'Τι ώρα είναι;',
    'Vad är klockan?',
  ),
  _PhraseSeed(
    'station',
    'Szukam dworca.',
    'Я шукаю вокзал.',
    'I am looking for the station.',
    'Busco la estación.',
    'Ψάχνω τον σταθμό.',
    'Jag letar efter stationen.',
  ),
  _PhraseSeed(
    'reservation',
    'Mam rezerwację.',
    'У мене є бронювання.',
    'I have a reservation.',
    'Tengo una reserva.',
    'Έχω κράτηση.',
    'Jag har en bokning.',
  ),
  _PhraseSeed(
    'hungry',
    'Jestem głodny/głodna.',
    'Я голодний/голодна.',
    'I am hungry.',
    'Tengo hambre.',
    'Πεινάω.',
    'Jag är hungrig.',
  ),
  _PhraseSeed(
    'tired',
    'Jestem zmęczony/zmęczona.',
    'Я втомлений/втомлена.',
    'I am tired.',
    'Estoy cansado.',
    'Είμαι κουρασμένος.',
    'Jag är trött.',
  ),
  _PhraseSeed(
    'coffee',
    'Lubię kawę.',
    'Я люблю каву.',
    'I like coffee.',
    'Me gusta el café.',
    'Μου αρέσει ο καφές.',
    'Jag gillar kaffe.',
  ),
  _PhraseSeed(
    'no_milk',
    'Nie piję mleka.',
    'Я не п’ю молока.',
    "I don't drink milk.",
    'No bebo leche.',
    'Δεν πίνω γάλα.',
    'Jag dricker inte mjölk.',
  ),
  _PhraseSeed(
    'family',
    'To jest moja rodzina.',
    'Це моя сім’я.',
    'This is my family.',
    'Esta es mi familia.',
    'Αυτή είναι η οικογένειά μου.',
    'Det här är min familj.',
  ),
  _PhraseSeed(
    'work_here',
    'Pracuję tutaj.',
    'Я працюю тут.',
    'I work here.',
    'Trabajo aquí.',
    'Δουλεύω εδώ.',
    'Jag arbetar här.',
  ),
  _PhraseSeed(
    'monday',
    'Dzisiaj jest poniedziałek.',
    'Сьогодні понеділок.',
    'Today is Monday.',
    'Hoy es lunes.',
    'Σήμερα είναι Δευτέρα.',
    'I dag är det måndag.',
  ),
  _PhraseSeed(
    'tomorrow',
    'Do zobaczenia jutro.',
    'До зустрічі завтра.',
    'See you tomorrow.',
    'Hasta mañana.',
    'Τα λέμε αύριο.',
    'Vi ses i morgon.',
  ),
  _PhraseSeed(
    'where_live',
    'Gdzie Pan/Pani mieszka?',
    'Де ви живете?',
    'Where do you live?',
    '¿Dónde vive?',
    'Πού μένετε;',
    'Var bor du?',
  ),
  _PhraseSeed(
    'speak_english',
    'Czy mówi Pan/Pani po angielsku?',
    'Ви розмовляєте англійською?',
    'Do you speak English?',
    '¿Habla inglés?',
    'Μιλάτε αγγλικά;',
    'Talar du engelska?',
  ),
  _PhraseSeed(
    'not_know',
    'Nie wiem.',
    'Я не знаю.',
    "I don't know.",
    'No lo sé.',
    'Δεν ξέρω.',
    'Jag vet inte.',
  ),
  _PhraseSeed(
    'okay',
    'Wszystko jest w porządku.',
    'Усе гаразд.',
    'Everything is okay.',
    'Todo está bien.',
    'Όλα είναι εντάξει.',
    'Allt är okej.',
  ),
  _PhraseSeed(
    'doctor',
    'Proszę wezwać lekarza.',
    'Викличте лікаря.',
    'Call a doctor.',
    'Llame a un médico.',
    'Καλέστε έναν γιατρό.',
    'Ring en läkare.',
  ),
];

const _greekAlphabetModules = <List<_AlphabetSeed>>[
  [
    _AlphabetSeed('Α α', 'alfa — dźwięk a', 'альфа — звук а', 'alfa'),
    _AlphabetSeed('Β β', 'wita — dźwięk w', 'віта — звук в', 'wita'),
    _AlphabetSeed(
      'Γ γ',
      'gamma — gardłowe g/j',
      'гамма — гортанне г/й',
      'gamma',
    ),
    _AlphabetSeed(
      'Δ δ',
      'delta — dźwięczne th',
      'дельта — дзвінке th',
      'delta',
    ),
    _AlphabetSeed('Ε ε', 'epsilon — dźwięk e', 'епсилон — звук е', 'epsilon'),
    _AlphabetSeed('Ζ ζ', 'zita — dźwięk z', 'зіта — звук з', 'zita'),
    _AlphabetSeed('Η η', 'ita — dźwięk i', 'іта — звук і', 'ita'),
    _AlphabetSeed('Θ θ', 'thita — bezdźwięczne th', 'тіта — глухе th', 'thita'),
    _AlphabetSeed('Ι ι', 'jota — dźwięk i', 'йота — звук і', 'jota'),
    _AlphabetSeed('Κ κ', 'kapa — dźwięk k', 'капа — звук к', 'kapa'),
    _AlphabetSeed('Λ λ', 'lamda — dźwięk l', 'ламда — звук л', 'lamda'),
    _AlphabetSeed('Μ μ', 'mi — dźwięk m', 'мі — звук м', 'mi'),
    _AlphabetSeed('Ν ν', 'ni — dźwięk n', 'ні — звук н', 'ni'),
    _AlphabetSeed('Ξ ξ', 'ksi — dźwięk ks', 'ксі — звук кс', 'ksi'),
    _AlphabetSeed('Ο ο', 'omikron — dźwięk o', 'омікрон — звук о', 'omikron'),
    _AlphabetSeed('Π π', 'pi — dźwięk p', 'пі — звук п', 'pi'),
    _AlphabetSeed('Ρ ρ', 'ro — dźwięk r', 'ро — звук р', 'ro'),
    _AlphabetSeed(
      'Σ σ ς',
      'sigma — dźwięk s; ς na końcu',
      'сігма — звук с; ς у кінці',
      'sigma',
    ),
    _AlphabetSeed('Τ τ', 'taf — dźwięk t', 'таф — звук т', 'taf'),
    _AlphabetSeed('Υ υ', 'ipsilon — dźwięk i', 'іпсилон — звук і', 'ipsilon'),
  ],
  [
    _AlphabetSeed('Φ φ', 'fi — dźwięk f', 'фі — звук ф', 'fi'),
    _AlphabetSeed('Χ χ', 'chi — dźwięk ch', 'хі — звук х', 'chi'),
    _AlphabetSeed('Ψ ψ', 'psi — dźwięk ps', 'псі — звук пс', 'psi'),
    _AlphabetSeed('Ω ω', 'omega — dźwięk o', 'омега — звук о', 'omega'),
    _AlphabetSeed(
      'ά έ ή ί ό ύ ώ',
      'akcent pokazuje mocniejszą sylabę',
      'наголос показує сильніший склад',
    ),
    _AlphabetSeed('Β ≠ B', 'Β czytamy jak w', 'Β читаємо як в'),
    _AlphabetSeed('Ρ ≠ P', 'Ρ czytamy jak r', 'Ρ читаємо як р'),
    _AlphabetSeed('Η ≠ H', 'Η czytamy jak i', 'Η читаємо як і'),
    _AlphabetSeed('Χ ≠ X', 'Χ czytamy jak ch', 'Χ читаємо як х'),
    _AlphabetSeed('Υ ≠ Y', 'Υ czytamy jak i', 'Υ читаємо як і'),
    _AlphabetSeed('Ν ν', 'Ν/ν odpowiada dźwiękowi n', 'Ν/ν відповідає звуку н'),
    _AlphabetSeed('Μ μ', 'Μ/μ odpowiada dźwiękowi m', 'Μ/μ відповідає звуку м'),
    _AlphabetSeed('Π π', 'Π/π odpowiada dźwiękowi p', 'Π/π відповідає звуку п'),
    _AlphabetSeed('Τ τ', 'Τ/τ odpowiada dźwiękowi t', 'Τ/τ відповідає звуку т'),
    _AlphabetSeed('Κ κ', 'Κ/κ odpowiada dźwiękowi k', 'Κ/κ відповідає звуку к'),
    _AlphabetSeed(
      'Α Ε Ο',
      'wyraźne samogłoski a, e, o',
      'чіткі голосні а, е, о',
    ),
    _AlphabetSeed(
      'Η Ι Υ',
      'trzy litery wymawiane jak i',
      'три літери вимовляються як і',
    ),
    _AlphabetSeed(
      'Ο Ω',
      'obie litery wymawiane jak o',
      'обидві літери вимовляються як о',
    ),
    _AlphabetSeed(
      'Σ σ',
      'sigma w początku i środku',
      'сігма на початку й у середині',
    ),
    _AlphabetSeed(
      'ς',
      'sigma tylko na końcu słowa',
      'сігма лише в кінці слова',
    ),
  ],
  [
    _AlphabetSeed('μα', 'sylaba ma', 'склад ма'),
    _AlphabetSeed('με', 'sylaba me', 'склад ме'),
    _AlphabetSeed('μη', 'sylaba mi', 'склад мі'),
    _AlphabetSeed('μι', 'sylaba mi', 'склад мі'),
    _AlphabetSeed('μο', 'sylaba mo', 'склад мо'),
    _AlphabetSeed('μου', 'sylaba mu', 'склад му'),
    _AlphabetSeed('να', 'sylaba na', 'склад на'),
    _AlphabetSeed('νε', 'sylaba ne', 'склад не'),
    _AlphabetSeed('νη', 'sylaba ni', 'склад ні'),
    _AlphabetSeed('νι', 'sylaba ni', 'склад ні'),
    _AlphabetSeed('νο', 'sylaba no', 'склад но'),
    _AlphabetSeed('νου', 'sylaba nu', 'склад ну'),
    _AlphabetSeed('πα', 'sylaba pa', 'склад па'),
    _AlphabetSeed('πε', 'sylaba pe', 'склад пе'),
    _AlphabetSeed('πη', 'sylaba pi', 'склад пі'),
    _AlphabetSeed('πι', 'sylaba pi', 'склад пі'),
    _AlphabetSeed('πο', 'sylaba po', 'склад по'),
    _AlphabetSeed('που', 'sylaba pu', 'склад пу'),
    _AlphabetSeed('τα', 'sylaba ta', 'склад та'),
    _AlphabetSeed('το', 'sylaba to', 'склад то'),
  ],
  [
    _AlphabetSeed('αι', 'dwuznak brzmi jak e', 'диграф звучить як е'),
    _AlphabetSeed('ει', 'dwuznak brzmi jak i', 'диграф звучить як і'),
    _AlphabetSeed('οι', 'dwuznak brzmi jak i', 'диграф звучить як і'),
    _AlphabetSeed('ου', 'dwuznak brzmi jak u', 'диграф звучить як у'),
    _AlphabetSeed(
      'αυ',
      'av przed dźwięczną, af przed bezdźwięczną',
      'ав перед дзвінкою, аф перед глухою',
    ),
    _AlphabetSeed(
      'ευ',
      'ev przed dźwięczną, ef przed bezdźwięczną',
      'ев перед дзвінкою, еф перед глухою',
    ),
    _AlphabetSeed('μπ', 'na początku zwykle b', 'на початку зазвичай б'),
    _AlphabetSeed('ντ', 'na początku zwykle d', 'на початку зазвичай д'),
    _AlphabetSeed('γκ', 'na początku zwykle g', 'на початку зазвичай ґ'),
    _AlphabetSeed('γγ', 'połączenie z dźwiękiem ng', 'сполучення зі звуком нг'),
    _AlphabetSeed('τσ', 'dźwięk c/ts', 'звук ц/ts'),
    _AlphabetSeed('τζ', 'dźwięk dz', 'звук дз'),
    _AlphabetSeed('θα', 'połączenie tha', 'сполучення tha'),
    _AlphabetSeed('θε', 'połączenie the', 'сполучення the'),
    _AlphabetSeed('θη', 'połączenie thi', 'сполучення thi'),
    _AlphabetSeed('χα', 'połączenie cha', 'сполучення ха'),
    _AlphabetSeed('χε', 'miększe che', 'м’якше хе'),
    _AlphabetSeed('χι', 'miększe chi', 'м’якше хі'),
    _AlphabetSeed('γε', 'miękkie ge/je', 'м’яке ге/йе'),
    _AlphabetSeed('γι', 'miękkie gi/ji', 'м’яке гі/йі'),
  ],
  [
    _AlphabetSeed('μαμά', 'mama', 'мама'),
    _AlphabetSeed('μπαμπάς', 'tata', 'тато'),
    _AlphabetSeed('νερό', 'woda', 'вода'),
    _AlphabetSeed('ψωμί', 'chleb', 'хліб'),
    _AlphabetSeed('καφές', 'kawa', 'кава'),
    _AlphabetSeed('σπίτι', 'dom', 'дім'),
    _AlphabetSeed('φίλος', 'przyjaciel', 'друг'),
    _AlphabetSeed('φίλη', 'przyjaciółka', 'подруга'),
    _AlphabetSeed('μέρα', 'dzień', 'день'),
    _AlphabetSeed('νύχτα', 'noc', 'ніч'),
    _AlphabetSeed('Ελλάδα', 'Grecja', 'Греція'),
    _AlphabetSeed('Αθήνα', 'Ateny', 'Афіни'),
    _AlphabetSeed('ναι', 'tak', 'так'),
    _AlphabetSeed('όχι', 'nie', 'ні'),
    _AlphabetSeed('εγώ', 'ja', 'я'),
    _AlphabetSeed('εσύ', 'ty', 'ти'),
    _AlphabetSeed('είναι', 'jest', 'є'),
    _AlphabetSeed('έχω', 'mam', 'маю'),
    _AlphabetSeed('θέλω', 'chcę', 'хочу'),
    _AlphabetSeed('ευχαριστώ', 'dziękuję', 'дякую'),
  ],
];
