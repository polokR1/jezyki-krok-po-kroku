import '../domain/models/course.dart';

LocalizedText _lt(String pl, String uk) => LocalizedText(pl: pl, uk: uk);

class _GrammarSeed {
  const _GrammarSeed(
    this.titlePl,
    this.titleUk,
    this.explanationPl,
    this.explanationUk,
    this.target,
    this.examplePl,
    this.exampleUk,
  );

  final String titlePl;
  final String titleUk;
  final String explanationPl;
  final String explanationUk;
  final String target;
  final String examplePl;
  final String exampleUk;
}

List<GrammarLesson> buildGrammarLessons(String courseId) {
  final seeds = switch (courseId) {
    'english' => _englishGrammar,
    'spanish' => _spanishGrammar,
    'greek' => _greekGrammar,
    'swedish' => _swedishGrammar,
    _ => throw ArgumentError.value(courseId, 'courseId', 'Unknown course'),
  };
  return [
    for (var index = 0; index < seeds.length; index++)
      GrammarLesson(
        id: '${courseId}_grammar_${index + 1}',
        level: index < 4
            ? 'A0'
            : index < 10
            ? 'A1'
            : index < 14
            ? 'A2'
            : 'B1',
        title: _lt(seeds[index].titlePl, seeds[index].titleUk),
        explanation: _lt(
          seeds[index].explanationPl,
          seeds[index].explanationUk,
        ),
        exampleTarget: seeds[index].target,
        exampleTranslation: _lt(seeds[index].examplePl, seeds[index].exampleUk),
      ),
  ];
}

const _englishGrammar = <_GrammarSeed>[
  _GrammarSeed(
    'Alfabet i wymowa',
    'Алфавіт і вимова',
    'Angielski ma 26 liter. Zwracaj uwagę na dźwięki th oraz różnicę między krótkimi i długimi samogłoskami.',
    'Англійська має 26 літер. Звертай увагу на th і різницю між короткими та довгими голосними.',
    'Three green trees.',
    'Trzy zielone drzewa.',
    'Три зелені дерева.',
  ),
  _GrammarSeed(
    'Zaimki osobowe',
    'Особові займенники',
    'Przed czasownikiem zwykle występuje podmiot: I, you, he, she, it, we, they.',
    'Перед дієсловом зазвичай стоїть підмет: I, you, he, she, it, we, they.',
    'She lives in London.',
    'Ona mieszka w Londynie.',
    'Вона живе в Лондоні.',
  ),
  _GrammarSeed(
    'Czasownik to be',
    'Дієслово to be',
    'W teraźniejszości używamy am, is albo are, zależnie od osoby.',
    'У теперішньому часі вживаємо am, is або are залежно від особи.',
    'We are ready.',
    'Jesteśmy gotowi.',
    'Ми готові.',
  ),
  _GrammarSeed(
    'A, an i the',
    'A, an і the',
    'A/an wprowadza rzecz nieokreśloną, a the wskazuje rzecz znaną rozmówcom.',
    'A/an вводить невизначену річ, а the вказує на відому співрозмовникам.',
    'I have a key. The key is new.',
    'Mam klucz. Ten klucz jest nowy.',
    'У мене є ключ. Цей ключ новий.',
  ),
  _GrammarSeed(
    'Liczba mnoga',
    'Множина',
    'Najczęściej dodajemy -s lub -es. Niektóre formy są nieregularne, np. child – children.',
    'Найчастіше додаємо -s або -es. Деякі форми неправильні, напр. child – children.',
    'Two children are playing.',
    'Dwoje dzieci się bawi.',
    'Двоє дітей граються.',
  ),
  _GrammarSeed(
    'Present Simple',
    'Present Simple',
    'Czasu Present Simple używamy do zwyczajów i faktów. Po he/she/it czasownik zwykle otrzymuje -s.',
    'Present Simple вживаємо для звичок і фактів. Після he/she/it дієслово зазвичай має -s.',
    'He works every day.',
    'On pracuje codziennie.',
    'Він працює щодня.',
  ),
  _GrammarSeed(
    'Przeczenia z do',
    'Заперечення з do',
    'W Present Simple tworzymy przeczenie przez do not lub does not.',
    'У Present Simple заперечення утворюємо через do not або does not.',
    "I don't drink coffee.",
    'Nie piję kawy.',
    'Я не п’ю кави.',
  ),
  _GrammarSeed(
    'Pytania z do',
    'Питання з do',
    'Pytanie zaczynamy od do/does, potem podmiot i podstawowa forma czasownika.',
    'Питання починаємо з do/does, потім підмет і початкова форма дієслова.',
    'Do you speak English?',
    'Czy mówisz po angielsku?',
    'Ти розмовляєш англійською?',
  ),
  _GrammarSeed(
    'Present Continuous',
    'Present Continuous',
    'Am/is/are z formą -ing opisuje czynność trwającą teraz.',
    'Am/is/are з формою -ing описує дію, що триває зараз.',
    'They are waiting outside.',
    'Oni czekają na zewnątrz.',
    'Вони чекають надворі.',
  ),
  _GrammarSeed(
    'Przyimki miejsca',
    'Прийменники місця',
    'In oznacza wewnątrz, on na powierzchni, a at konkretny punkt lub miejsce.',
    'In означає всередині, on на поверхні, а at конкретну точку чи місце.',
    'The phone is on the table.',
    'Telefon jest na stole.',
    'Телефон на столі.',
  ),
  _GrammarSeed(
    'Past Simple',
    'Past Simple',
    'Czas przeszły tworzymy końcówką -ed lub nieregularną drugą formą czasownika.',
    'Минулий час утворюємо закінченням -ed або другою формою неправильного дієслова.',
    'We went home early.',
    'Wróciliśmy wcześnie do domu.',
    'Ми рано пішли додому.',
  ),
  _GrammarSeed(
    'Present Perfect',
    'Present Perfect',
    'Have/has z imiesłowem łączy przeszłe zdarzenie z teraźniejszością.',
    'Have/has з дієприкметником пов’язує минулу подію з теперішнім.',
    'I have finished my work.',
    'Skończyłem pracę.',
    'Я закінчив роботу.',
  ),
  _GrammarSeed(
    'Przyszłość',
    'Майбутній час',
    'Will służy do spontanicznych decyzji i przewidywań, a going to do planów.',
    'Will вживаємо для спонтанних рішень і прогнозів, going to — для планів.',
    "I'm going to visit Madrid.",
    'Zamierzam odwiedzić Madryt.',
    'Я збираюся відвідати Мадрид.',
  ),
  _GrammarSeed(
    'Czasowniki modalne',
    'Модальні дієслова',
    'Can, should i must występują przed podstawową formą czasownika.',
    'Can, should і must стоять перед початковою формою дієслова.',
    'You should call a doctor.',
    'Powinieneś zadzwonić do lekarza.',
    'Тобі слід зателефонувати лікарю.',
  ),
  _GrammarSeed(
    'Tryby warunkowe',
    'Умовні речення',
    'Pierwszy okres warunkowy opisuje realną możliwość: if + Present Simple, will + czasownik.',
    'Перший умовний тип описує реальну можливість: if + Present Simple, will + дієслово.',
    "If it rains, we'll stay home.",
    'Jeśli będzie padać, zostaniemy w domu.',
    'Якщо буде дощ, ми залишимося вдома.',
  ),
  _GrammarSeed(
    'Zdania podrzędne',
    'Підрядні речення',
    'Because podaje przyczynę, although kontrast, a who/which wprowadza zdanie względne.',
    'Because подає причину, although — контраст, а who/which вводить відносне речення.',
    'I stayed because I wanted to help.',
    'Zostałem, ponieważ chciałem pomóc.',
    'Я залишився, бо хотів допомогти.',
  ),
];

const _spanishGrammar = <_GrammarSeed>[
  _GrammarSeed(
    'Alfabet i akcent',
    'Алфавіт і наголос',
    'Hiszpańska pisownia jest regularna. Znak akcentu wskazuje nieregularnie akcentowaną sylabę.',
    'Іспанський правопис регулярний. Знак наголосу вказує на нестандартно наголошений склад.',
    '¿Cómo estás?',
    'Jak się masz?',
    'Як справи?',
  ),
  _GrammarSeed(
    'Rodzaj rzeczownika',
    'Рід іменника',
    'Rzeczowniki mają rodzaj męski lub żeński. Często -o oznacza męski, a -a żeński, lecz są wyjątki.',
    'Іменники мають чоловічий або жіночий рід. Часто -o означає чоловічий, а -a жіночий, але є винятки.',
    'el libro y la casa',
    'książka i dom',
    'книга і будинок',
  ),
  _GrammarSeed(
    'Rodzajniki',
    'Артиклі',
    'El, la, los, las są określone; un, una, unos, unas — nieokreślone.',
    'El, la, los, las — означені; un, una, unos, unas — неозначені.',
    'Quiero una mesa cerca de la ventana.',
    'Chcę stolik przy oknie.',
    'Я хочу столик біля вікна.',
  ),
  _GrammarSeed(
    'Zaimki podmiotowe',
    'Займенники-підмети',
    'Końcówka czasownika zwykle wskazuje osobę, dlatego zaimek często można pominąć.',
    'Закінчення дієслова зазвичай указує особу, тому займенник часто можна опустити.',
    'Hablamos español.',
    'Mówimy po hiszpańsku.',
    'Ми розмовляємо іспанською.',
  ),
  _GrammarSeed(
    'Ser',
    'Дієслово ser',
    'Ser opisuje tożsamość, pochodzenie, zawód i trwałe cechy.',
    'Ser описує ідентичність, походження, професію та сталі ознаки.',
    'Soy de Polonia.',
    'Jestem z Polski.',
    'Я з Польщі.',
  ),
  _GrammarSeed(
    'Estar',
    'Дієслово estar',
    'Estar opisuje stan i położenie.',
    'Estar описує стан і місцезнаходження.',
    'La estación está cerca.',
    'Dworzec jest blisko.',
    'Вокзал близько.',
  ),
  _GrammarSeed(
    'Hay',
    'Конструкція hay',
    'Hay oznacza „jest/są” i wprowadza informację o istnieniu czegoś.',
    'Hay означає «є» і вводить інформацію про існування чогось.',
    'Hay un banco aquí.',
    'Tutaj jest bank.',
    'Тут є банк.',
  ),
  _GrammarSeed(
    'Czas teraźniejszy',
    'Теперішній час',
    'Czasowniki -ar, -er i -ir otrzymują różne końcówki osobowe.',
    'Дієслова на -ar, -er та -ir мають різні особові закінчення.',
    'Trabajo en una oficina.',
    'Pracuję w biurze.',
    'Я працюю в офісі.',
  ),
  _GrammarSeed(
    'Gustar',
    'Дієслово gustar',
    'Gustar zgadza się z rzeczą, która się podoba; osobę wskazuje me, te, le, nos lub les.',
    'Gustar узгоджується з тим, що подобається; особу позначають me, te, le, nos або les.',
    'Me gustan estos zapatos.',
    'Podobają mi się te buty.',
    'Мені подобається це взуття.',
  ),
  _GrammarSeed(
    'Pytania i przeczenia',
    'Питання і заперечення',
    'Pytania zapisujemy między ¿ i ?. Przeczenie no stoi bezpośrednio przed czasownikiem.',
    'Питання пишемо між ¿ та ?. Заперечення no стоїть безпосередньо перед дієсловом.',
    '¿No tienes tiempo?',
    'Nie masz czasu?',
    'У тебе немає часу?',
  ),
  _GrammarSeed(
    'Pretérito perfecto',
    'Pretérito perfecto',
    'He/has/ha/hemos/habéis/han z imiesłowem opisuje niedawną przeszłość związaną z teraz.',
    'He/has/ha/hemos/habéis/han з дієприкметником описує недавнє минуле, пов’язане з теперішнім.',
    'He terminado el trabajo.',
    'Skończyłem pracę.',
    'Я закінчив роботу.',
  ),
  _GrammarSeed(
    'Pretérito indefinido',
    'Pretérito indefinido',
    'Indefinido opisuje zakończone wydarzenia w zamkniętym czasie przeszłym.',
    'Indefinido описує завершені події в закритому минулому часі.',
    'Ayer compré un billete.',
    'Wczoraj kupiłem bilet.',
    'Учора я купив квиток.',
  ),
  _GrammarSeed(
    'Imperfecto',
    'Imperfecto',
    'Imperfecto opisuje tło, zwyczaje i trwające stany w przeszłości.',
    'Imperfecto описує тло, звички та тривалі стани в минулому.',
    'Cuando era niño, vivía aquí.',
    'Kiedy byłem dzieckiem, mieszkałem tutaj.',
    'Коли я був дитиною, я жив тут.',
  ),
  _GrammarSeed(
    'Przyszłość i zamiary',
    'Майбутнє й наміри',
    'Ir a + bezokolicznik wyraża zamiar; futuro simple także przewidywanie.',
    'Ir a + інфінітив виражає намір; futuro simple також прогноз.',
    'Vamos a viajar mañana.',
    'Jutro będziemy podróżować.',
    'Завтра ми подорожуватимемо.',
  ),
  _GrammarSeed(
    'Tryb rozkazujący',
    'Наказовий спосіб',
    'Formy rozkazujące zależą od osoby i mogą dołączać zaimki na końcu.',
    'Наказові форми залежать від особи й можуть приєднувати займенники в кінці.',
    'Dígame la verdad, por favor.',
    'Proszę powiedzieć mi prawdę.',
    'Скажіть мені правду, будь ласка.',
  ),
  _GrammarSeed(
    'Subjuntivo',
    'Subjuntivo',
    'Subjuntivo występuje m.in. po wyrażeniach życzenia, emocji, wątpliwości i konieczności.',
    'Subjuntivo вживається, зокрема, після виразів бажання, емоції, сумніву й необхідності.',
    'Espero que tengas un buen día.',
    'Mam nadzieję, że będziesz mieć dobry dzień.',
    'Сподіваюся, у тебе буде гарний день.',
  ),
];

const _greekGrammar = <_GrammarSeed>[
  _GrammarSeed(
    'Alfabet grecki',
    'Грецький алфавіт',
    'Grecki ma 24 litery. Naucz się rozpoznawać osobno małe i wielkie formy.',
    'Грецька має 24 літери. Навчися окремо розпізнавати малі й великі форми.',
    'Α α, Β β, Γ γ',
    'alfa, beta, gamma',
    'альфа, бета, гамма',
  ),
  _GrammarSeed(
    'Akcent i dwuznaki',
    'Наголос і диграфи',
    'Akcent oznaczamy znakiem ´. Połączenia αι, ει, οι, ου oraz μπ, ντ, γκ mają własną wymowę.',
    'Наголос позначаємо знаком ´. Сполучення αι, ει, οι, ου та μπ, ντ, γκ мають особливу вимову.',
    'καλημέρα',
    'dzień dobry',
    'добрий день',
  ),
  _GrammarSeed(
    'Rodzajniki',
    'Артиклі',
    'Rodzajniki ο, η, το wskazują rodzaj męski, żeński i nijaki.',
    'Артиклі ο, η, το вказують на чоловічий, жіночий і середній рід.',
    'ο φίλος, η φίλη, το παιδί',
    'przyjaciel, przyjaciółka, dziecko',
    'друг, подруга, дитина',
  ),
  _GrammarSeed(
    'Mianownik',
    'Називний відмінок',
    'Mianownik służy głównie do oznaczania wykonawcy czynności.',
    'Називний відмінок переважно позначає виконавця дії.',
    'Ο Γιάννης δουλεύει.',
    'Jan pracuje.',
    'Ян працює.',
  ),
  _GrammarSeed(
    'Czasownik είμαι',
    'Дієслово είμαι',
    'Είμαι oznacza „być” i odmienia się nieregularnie: είμαι, είσαι, είναι, είμαστε, είστε, είναι.',
    'Είμαι означає «бути» й відмінюється неправильно: είμαι, είσαι, είναι, είμαστε, είστε, είναι.',
    'Είμαστε έτοιμοι.',
    'Jesteśmy gotowi.',
    'Ми готові.',
  ),
  _GrammarSeed(
    'Biernik',
    'Знахідний відмінок',
    'Biernik oznacza dopełnienie i występuje po wielu przyimkach, np. σε.',
    'Знахідний позначає додаток і вживається після багатьох прийменників, напр. σε.',
    'Βλέπω τον φίλο μου.',
    'Widzę mojego przyjaciela.',
    'Я бачу свого друга.',
  ),
  _GrammarSeed(
    'Czas teraźniejszy',
    'Теперішній час',
    'Końcówka czasownika wskazuje osobę; zaimek podmiotowy często jest zbędny.',
    'Закінчення дієслова вказує особу; займенник-підмет часто зайвий.',
    'Μιλάω ελληνικά.',
    'Mówię po grecku.',
    'Я розмовляю грецькою.',
  ),
  _GrammarSeed(
    'Przeczenie',
    'Заперечення',
    'Δεν stawiamy przed czasownikiem w zdaniach oznajmujących.',
    'Δεν ставимо перед дієсловом у розповідних реченнях.',
    'Δεν καταλαβαίνω.',
    'Nie rozumiem.',
    'Я не розумію.',
  ),
  _GrammarSeed(
    'Pytania',
    'Питання',
    'Pytanie często ma taki sam szyk jak zdanie oznajmujące; rozpoznajemy je po intonacji i znaku ;',
    'Питання часто має такий самий порядок слів, як твердження; його впізнаємо за інтонацією та знаком ;',
    'Μιλάτε αγγλικά;',
    'Czy mówi pan/pani po angielsku?',
    'Ви розмовляєте англійською?',
  ),
  _GrammarSeed(
    'Dopełniacz',
    'Родовий відмінок',
    'Dopełniacz wyraża posiadanie i występuje w krótkich zaimkach μου, σου, του, της.',
    'Родовий виражає належність і трапляється в коротких займенниках μου, σου, του, της.',
    'Αυτό είναι το σπίτι μου.',
    'To jest mój dom.',
    'Це мій дім.',
  ),
  _GrammarSeed(
    'Aoryst',
    'Аорист',
    'Aoryst opisuje zakończone wydarzenie w przeszłości. Wiele czasowników zmienia temat.',
    'Аорист описує завершену подію в минулому. Багато дієслів змінюють основу.',
    'Χθες πήγα στη δουλειά.',
    'Wczoraj poszedłem do pracy.',
    'Учора я пішов на роботу.',
  ),
  _GrammarSeed(
    'Czas przeszły ciągły',
    'Минулий тривалий час',
    'Paratatikos opisuje czynność powtarzaną lub trwającą w przeszłości.',
    'Парата́тикос описує повторювану або тривалу дію в минулому.',
    'Όταν ήμουν παιδί, έπαιζα εδώ.',
    'Kiedy byłem dzieckiem, bawiłem się tutaj.',
    'Коли я був дитиною, я грався тут.',
  ),
  _GrammarSeed(
    'Przyszłość',
    'Майбутній час',
    'Θα przed odpowiednią formą czasownika tworzy przyszłość.',
    'Θα перед відповідною формою дієслова творить майбутній час.',
    'Θα ταξιδέψουμε αύριο.',
    'Jutro będziemy podróżować.',
    'Завтра ми подорожуватимемо.',
  ),
  _GrammarSeed(
    'Tryb rozkazujący',
    'Наказовий спосіб',
    'Rozkaz może mieć formę jednorazową lub ciągłą, zależnie od aspektu czasownika.',
    'Наказ може мати одноразову або тривалу форму залежно від виду дієслова.',
    'Περιμένετε εδώ, παρακαλώ.',
    'Proszę tutaj poczekać.',
    'Зачекайте тут, будь ласка.',
  ),
  _GrammarSeed(
    'Zdania z να',
    'Речення з να',
    'Να z czasownikiem wyraża zamiar, życzenie, możliwość lub konieczność.',
    'Να з дієсловом виражає намір, бажання, можливість або необхідність.',
    'Θέλω να μάθω ελληνικά.',
    'Chcę nauczyć się greckiego.',
    'Я хочу вивчити грецьку.',
  ),
  _GrammarSeed(
    'Zdania warunkowe',
    'Умовні речення',
    'Realny warunek wprowadzamy przez αν, a rezultat często zawiera θα.',
    'Реальну умову вводимо через αν, а результат часто містить θα.',
    'Αν βρέχει, θα μείνουμε σπίτι.',
    'Jeśli pada, zostaniemy w domu.',
    'Якщо йде дощ, ми залишимося вдома.',
  ),
];

const _swedishGrammar = <_GrammarSeed>[
  _GrammarSeed(
    'Alfabet i samogłoski',
    'Алфавіт і голосні',
    'Szwedzki alfabet kończy się literami å, ä, ö. Długość samogłoski może zmieniać znaczenie.',
    'Шведський алфавіт закінчується літерами å, ä, ö. Довжина голосної може змінювати значення.',
    'Å, Ä och Ö',
    'Å, Ä i Ö',
    'Å, Ä та Ö',
  ),
  _GrammarSeed(
    'En czy ett',
    'En чи ett',
    'Każdy rzeczownik ma rodzaj en albo ett; najlepiej uczyć się go razem z rodzajnikiem.',
    'Кожен іменник має рід en або ett; найкраще вчити його разом з артиклем.',
    'en stol och ett bord',
    'krzesło i stół',
    'стілець і стіл',
  ),
  _GrammarSeed(
    'Forma określona',
    'Означена форма',
    'Rodzajnik określony dołączamy do końca rzeczownika: en bil – bilen, ett hus – huset.',
    'Означений артикль додаємо в кінці іменника: en bil – bilen, ett hus – huset.',
    'Bilen står utanför huset.',
    'Samochód stoi przed domem.',
    'Автомобіль стоїть перед будинком.',
  ),
  _GrammarSeed(
    'Zaimki osobowe',
    'Особові займенники',
    'Podstawowe zaimki to jag, du, han, hon, den/det, vi, ni, de.',
    'Основні займенники: jag, du, han, hon, den/det, vi, ni, de.',
    'Vi lär oss svenska.',
    'Uczymy się szwedzkiego.',
    'Ми вивчаємо шведську.',
  ),
  _GrammarSeed(
    'Czas teraźniejszy',
    'Теперішній час',
    'Czasownik ma tę samą formę dla wszystkich osób; często kończy się na -r.',
    'Дієслово має однакову форму для всіх осіб; часто закінчується на -r.',
    'Hon arbetar varje dag.',
    'Ona pracuje codziennie.',
    'Вона працює щодня.',
  ),
  _GrammarSeed(
    'Szyk V2',
    'Порядок V2',
    'W zdaniu głównym odmieniony czasownik zajmuje drugą pozycję, także gdy zdanie zaczyna się od czasu lub miejsca.',
    'У головному реченні відмінюване дієслово займає другу позицію, навіть якщо речення починається з часу чи місця.',
    'I dag arbetar jag hemma.',
    'Dzisiaj pracuję w domu.',
    'Сьогодні я працюю вдома.',
  ),
  _GrammarSeed(
    'Przeczenie inte',
    'Заперечення inte',
    'W zdaniu głównym inte zwykle stoi po odmienionym czasowniku.',
    'У головному реченні inte зазвичай стоїть після відмінюваного дієслова.',
    'Jag förstår inte.',
    'Nie rozumiem.',
    'Я не розумію.',
  ),
  _GrammarSeed(
    'Pytania',
    'Питання',
    'Pytanie tak/nie zaczyna się od czasownika, a pytanie szczegółowe od słowa pytającego.',
    'Питання так/ні починається з дієслова, а спеціальне питання — з питального слова.',
    'Var bor du?',
    'Gdzie mieszkasz?',
    'Де ти живеш?',
  ),
  _GrammarSeed(
    'Przymiotnik',
    'Прикметник',
    'Przymiotnik dopasowuje się do rodzaju i liczby: en stor bil, ett stort hus, stora hus.',
    'Прикметник узгоджується з родом і числом: en stor bil, ett stort hus, stora hus.',
    'Det är ett stort rum.',
    'To jest duży pokój.',
    'Це велика кімната.',
  ),
  _GrammarSeed(
    'Czasowniki modalne',
    'Модальні дієслова',
    'Po kan, vill, ska, måste i bör używamy bezokolicznika bez att.',
    'Після kan, vill, ska, måste та bör вживаємо інфінітив без att.',
    'Jag kan hjälpa dig.',
    'Mogę ci pomóc.',
    'Я можу тобі допомогти.',
  ),
  _GrammarSeed(
    'Preteritum',
    'Претерит',
    'Czas przeszły ma kilka wzorców regularnych oraz liczne formy nieregularne.',
    'Минулий час має кілька регулярних моделей і багато неправильних форм.',
    'Vi köpte biljetter i går.',
    'Wczoraj kupiliśmy bilety.',
    'Учора ми купили квитки.',
  ),
  _GrammarSeed(
    'Perfekt',
    'Перфект',
    'Har z supinum opisuje doświadczenie lub wydarzenie ważne teraz.',
    'Har із супіном описує досвід або подію, важливу зараз.',
    'Jag har redan ätit.',
    'Już jadłem.',
    'Я вже їв.',
  ),
  _GrammarSeed(
    'Przyszłość',
    'Майбутній час',
    'Ska wyraża plan, tänker zamiar, a kommer att przewidywanie.',
    'Ska виражає план, tänker — намір, а kommer att — прогноз.',
    'Vi ska resa i morgon.',
    'Jutro pojedziemy.',
    'Завтра ми поїдемо.',
  ),
  _GrammarSeed(
    'Zdanie podrzędne',
    'Підрядне речення',
    'W zdaniu podrzędnym inte stoi przed odmienionym czasownikiem: BIFF.',
    'У підрядному реченні inte стоїть перед відмінюваним дієсловом: BIFF.',
    'Jag stannar eftersom jag inte mår bra.',
    'Zostaję, ponieważ źle się czuję.',
    'Я залишаюся, бо погано почуваюся.',
  ),
  _GrammarSeed(
    'Czasowniki rozdzielnie złożone',
    'Фразові дієслова',
    'Partykuła może zmienić znaczenie czasownika, np. tycka om, gå ut, slå på.',
    'Частка може змінити значення дієслова, напр. tycka om, gå ut, slå på.',
    'Jag tycker om att läsa.',
    'Lubię czytać.',
    'Я люблю читати.',
  ),
  _GrammarSeed(
    'Mowa zależna',
    'Непряма мова',
    'Po czasownikach säga, fråga i berätta przekazujemy cudzą wypowiedź, zwykle zachowując szyk zdania podrzędnego.',
    'Після säga, fråga та berätta передаємо чужі слова, зазвичай із порядком підрядного речення.',
    'Hon säger att hon kommer senare.',
    'Ona mówi, że przyjdzie później.',
    'Вона каже, що прийде пізніше.',
  ),
];

class _DialogueTemplate {
  const _DialogueTemplate(
    this.id,
    this.titlePl,
    this.titleUk,
    this.situationPl,
    this.situationUk,
    this.speakers,
    this.linesPl,
    this.linesUk,
  );

  final String id;
  final String titlePl;
  final String titleUk;
  final String situationPl;
  final String situationUk;
  final List<String> speakers;
  final List<String> linesPl;
  final List<String> linesUk;
}

const _dialogueTemplates = <_DialogueTemplate>[
  _DialogueTemplate(
    'cafe',
    'W kawiarni',
    'У кав’ярні',
    'Zamów napój i zapytaj o cenę.',
    'Замов напій і запитай про ціну.',
    ['Klient', 'Obsługa', 'Klient', 'Obsługa'],
    [
      'Dzień dobry. Poproszę kawę.',
      'Oczywiście. Z mlekiem?',
      'Tak, proszę. Ile płacę?',
      'Trzy euro, proszę.',
    ],
    [
      'Добрий день. Каву, будь ласка.',
      'Звичайно. З молоком?',
      'Так, будь ласка. Скільки з мене?',
      'Три євро, будь ласка.',
    ],
  ),
  _DialogueTemplate(
    'station',
    'Na dworcu',
    'На вокзалі',
    'Kup bilet i znajdź właściwy peron.',
    'Купи квиток і знайди потрібну платформу.',
    ['Podróżny', 'Kasjer', 'Podróżny', 'Kasjer'],
    [
      'Poproszę bilet do centrum.',
      'W jedną czy w obie strony?',
      'W jedną stronę. Z którego peronu?',
      'Pociąg odjeżdża z peronu drugiego.',
    ],
    [
      'Квиток до центру, будь ласка.',
      'В один бік чи туди й назад?',
      'В один бік. З якої платформи?',
      'Поїзд відходить із другої платформи.',
    ],
  ),
  _DialogueTemplate(
    'doctor',
    'U lekarza',
    'У лікаря',
    'Opisz objawy i zrozum zalecenie.',
    'Опиши симптоми й зрозумій рекомендацію.',
    ['Lekarz', 'Pacjent', 'Lekarz', 'Pacjent'],
    [
      'Co panu/pani dolega?',
      'Boli mnie gardło i mam gorączkę.',
      'Proszę odpoczywać i pić dużo wody.',
      'Dobrze. Dziękuję za pomoc.',
    ],
    [
      'Що вас турбує?',
      'У мене болить горло й температура.',
      'Відпочивайте й пийте багато води.',
      'Добре. Дякую за допомогу.',
    ],
  ),
  _DialogueTemplate(
    'work',
    'Pierwszy dzień w pracy',
    'Перший день на роботі',
    'Przedstaw się i zapytaj o zadanie.',
    'Представся й запитай про завдання.',
    ['Nowa osoba', 'Kolega', 'Nowa osoba', 'Kolega'],
    [
      'Cześć, jestem nową osobą w zespole.',
      'Miło cię poznać. Jestem Alex.',
      'Od czego mam zacząć?',
      'Najpierw pokażę ci biuro.',
    ],
    [
      'Привіт, я нова людина в команді.',
      'Приємно познайомитися. Я Алекс.',
      'З чого мені почати?',
      'Спочатку я покажу тобі офіс.',
    ],
  ),
];

const _dialogueTargets = <String, List<List<String>>>{
  'english': [
    [
      'Good morning. A coffee, please.',
      'Of course. With milk?',
      'Yes, please. How much is it?',
      'Three euros, please.',
    ],
    [
      'A ticket to the city centre, please.',
      'Single or return?',
      'Single. Which platform is it?',
      'The train leaves from platform two.',
    ],
    [
      'What seems to be the problem?',
      'I have a sore throat and a fever.',
      'Please rest and drink plenty of water.',
      'All right. Thank you for your help.',
    ],
    [
      "Hi, I'm new to the team.",
      "Nice to meet you. I'm Alex.",
      'What should I start with?',
      "First, I'll show you the office.",
    ],
  ],
  'spanish': [
    [
      'Buenos días. Un café, por favor.',
      'Claro. ¿Con leche?',
      'Sí, por favor. ¿Cuánto es?',
      'Tres euros, por favor.',
    ],
    [
      'Un billete al centro, por favor.',
      '¿Solo ida o ida y vuelta?',
      'Solo ida. ¿De qué andén sale?',
      'El tren sale del andén dos.',
    ],
    [
      '¿Qué le pasa?',
      'Me duele la garganta y tengo fiebre.',
      'Descanse y beba mucha agua.',
      'De acuerdo. Gracias por su ayuda.',
    ],
    [
      'Hola, soy nuevo en el equipo.',
      'Encantado. Soy Alex.',
      '¿Por dónde empiezo?',
      'Primero te enseñaré la oficina.',
    ],
  ],
  'greek': [
    [
      'Καλημέρα. Έναν καφέ, παρακαλώ.',
      'Βεβαίως. Με γάλα;',
      'Ναι, παρακαλώ. Πόσο κάνει;',
      'Τρία ευρώ, παρακαλώ.',
    ],
    [
      'Ένα εισιτήριο για το κέντρο, παρακαλώ.',
      'Απλή μετάβαση ή με επιστροφή;',
      'Απλή μετάβαση. Από ποια αποβάθρα;',
      'Το τρένο φεύγει από την αποβάθρα δύο.',
    ],
    [
      'Τι πρόβλημα έχετε;',
      'Πονάει ο λαιμός μου και έχω πυρετό.',
      'Να ξεκουραστείτε και να πίνετε πολύ νερό.',
      'Εντάξει. Ευχαριστώ για τη βοήθεια.',
    ],
    [
      'Γεια σας, είμαι καινούριος στην ομάδα.',
      'Χάρηκα. Είμαι ο Άλεξ.',
      'Από πού να αρχίσω;',
      'Πρώτα θα σου δείξω το γραφείο.',
    ],
  ],
  'swedish': [
    [
      'God morgon. En kaffe, tack.',
      'Självklart. Med mjölk?',
      'Ja, tack. Hur mycket kostar det?',
      'Tre euro, tack.',
    ],
    [
      'En biljett till centrum, tack.',
      'Enkel eller tur och retur?',
      'Enkel. Från vilken plattform?',
      'Tåget går från plattform två.',
    ],
    [
      'Vad är det för problem?',
      'Jag har ont i halsen och feber.',
      'Vila och drick mycket vatten.',
      'Okej. Tack för hjälpen.',
    ],
    [
      'Hej, jag är ny i teamet.',
      'Trevligt att träffas. Jag heter Alex.',
      'Vad ska jag börja med?',
      'Först ska jag visa dig kontoret.',
    ],
  ],
};

List<DialogueScenario> buildDialogues(String courseId) {
  final targets = _dialogueTargets[courseId];
  if (targets == null) throw ArgumentError.value(courseId, 'courseId');
  return [
    for (var scenario = 0; scenario < _dialogueTemplates.length; scenario++)
      DialogueScenario(
        id: '${courseId}_dialogue_${_dialogueTemplates[scenario].id}',
        level: scenario < 2 ? 'A1' : 'A2',
        title: _lt(
          _dialogueTemplates[scenario].titlePl,
          _dialogueTemplates[scenario].titleUk,
        ),
        situation: _lt(
          _dialogueTemplates[scenario].situationPl,
          _dialogueTemplates[scenario].situationUk,
        ),
        lines: [
          for (var line = 0; line < targets[scenario].length; line++)
            DialogueLine(
              speaker: _dialogueTemplates[scenario].speakers[line],
              target: targets[scenario][line],
              translation: _lt(
                _dialogueTemplates[scenario].linesPl[line],
                _dialogueTemplates[scenario].linesUk[line],
              ),
            ),
        ],
      ),
  ];
}

class _StoryTemplate {
  const _StoryTemplate(this.id, this.titlePl, this.titleUk, this.pl, this.uk);
  final String id;
  final String titlePl;
  final String titleUk;
  final String pl;
  final String uk;
}

const _storyTemplates = <_StoryTemplate>[
  _StoryTemplate(
    'morning',
    'Spóźniony poranek',
    'Запізнілий ранок',
    'Marta budzi się o ósmej. Autobus odjeżdża za dwadzieścia minut. Bierze klucze i szybko wychodzi z domu.',
    'Марта прокидається о восьмій. Автобус від’їжджає за двадцять хвилин. Вона бере ключі й швидко виходить із дому.',
  ),
  _StoryTemplate(
    'trip',
    'Weekend nad morzem',
    'Вихідні біля моря',
    'W sobotę Adam jedzie pociągiem nad morze. Pogoda jest słoneczna, ale woda jest zimna. Wieczorem je kolację w małej restauracji.',
    'У суботу Адам їде потягом до моря. Погода сонячна, але вода холодна. Увечері він вечеряє в маленькому ресторані.',
  ),
  _StoryTemplate(
    'job',
    'Nowa praca',
    'Нова робота',
    'Nina zaczyna nową pracę w poniedziałek. Jej biuro jest blisko dworca. Koledzy pokazują jej budynek i wspólnie piją kawę.',
    'Ніна починає нову роботу в понеділок. Її офіс біля вокзалу. Колеги показують їй будівлю, і вони разом п’ють каву.',
  ),
  _StoryTemplate(
    'help',
    'Pomoc sąsiadowi',
    'Допомога сусідові',
    'Starszy sąsiad nie może otworzyć drzwi. Leon dzwoni do administracji i czeka razem z nim. Po godzinie pracownik naprawia zamek.',
    'Літній сусід не може відчинити двері. Леон телефонує в адміністрацію й чекає разом із ним. Через годину працівник ремонтує замок.',
  ),
];

const _storyTargets = <String, List<String>>{
  'english': [
    'Marta wakes up at eight. The bus leaves in twenty minutes. She takes her keys and quickly leaves the house.',
    'On Saturday Adam travels to the seaside by train. The weather is sunny, but the water is cold. In the evening he has dinner in a small restaurant.',
    'Nina starts a new job on Monday. Her office is near the station. Her colleagues show her the building and they drink coffee together.',
    'An elderly neighbour cannot open his door. Leon calls the building manager and waits with him. An hour later, a worker repairs the lock.',
  ],
  'spanish': [
    'Marta se despierta a las ocho. El autobús sale dentro de veinte minutos. Coge las llaves y sale rápidamente de casa.',
    'El sábado Adam viaja en tren a la costa. Hace sol, pero el agua está fría. Por la noche cena en un restaurante pequeño.',
    'Nina empieza un nuevo trabajo el lunes. Su oficina está cerca de la estación. Sus compañeros le enseñan el edificio y toman café juntos.',
    'Un vecino mayor no puede abrir la puerta. Leon llama al administrador y espera con él. Una hora después, un trabajador repara la cerradura.',
  ],
  'greek': [
    'Η Μάρτα ξυπνάει στις οκτώ. Το λεωφορείο φεύγει σε είκοσι λεπτά. Παίρνει τα κλειδιά της και βγαίνει γρήγορα από το σπίτι.',
    'Το Σάββατο ο Άνταμ ταξιδεύει με τρένο στη θάλασσα. Ο καιρός είναι ηλιόλουστος, αλλά το νερό είναι κρύο. Το βράδυ τρώει σε ένα μικρό εστιατόριο.',
    'Η Νίνα αρχίζει μια νέα δουλειά τη Δευτέρα. Το γραφείο της είναι κοντά στον σταθμό. Οι συνάδελφοί της δείχνουν το κτίριο και πίνουν καφέ μαζί.',
    'Ένας ηλικιωμένος γείτονας δεν μπορεί να ανοίξει την πόρτα. Ο Λέον καλεί τον διαχειριστή και περιμένει μαζί του. Μία ώρα αργότερα, ένας τεχνικός επισκευάζει την κλειδαριά.',
  ],
  'swedish': [
    'Marta vaknar klockan åtta. Bussen går om tjugo minuter. Hon tar sina nycklar och går snabbt hemifrån.',
    'På lördagen åker Adam tåg till havet. Det är soligt, men vattnet är kallt. På kvällen äter han middag på en liten restaurang.',
    'Nina börjar ett nytt jobb på måndag. Hennes kontor ligger nära stationen. Kollegorna visar henne byggnaden och de dricker kaffe tillsammans.',
    'En äldre granne kan inte öppna dörren. Leon ringer fastighetsskötaren och väntar med honom. En timme senare lagar en tekniker låset.',
  ],
};

List<CourseStory> buildStories(String courseId) {
  final targets = _storyTargets[courseId];
  if (targets == null) throw ArgumentError.value(courseId, 'courseId');
  return [
    for (var index = 0; index < _storyTemplates.length; index++)
      CourseStory(
        id: '${courseId}_story_${_storyTemplates[index].id}',
        level: index < 2 ? 'A1' : 'A2',
        title: _lt(
          _storyTemplates[index].titlePl,
          _storyTemplates[index].titleUk,
        ),
        targetText: targets[index],
        translation: _lt(_storyTemplates[index].pl, _storyTemplates[index].uk),
        questions: _questionsFor(index),
      ),
  ];
}

List<StoryQuestion> _questionsFor(int story) {
  const promptsPl = [
    [
      'O której budzi się Marta?',
      'Za ile minut odjeżdża autobus?',
      'Co zabiera Marta?',
    ],
    ['Dokąd jedzie Adam?', 'Jaka jest woda?', 'Gdzie je kolację?'],
    ['Kiedy Nina zaczyna pracę?', 'Gdzie jest jej biuro?', 'Co piją razem?'],
    [
      'Czego nie może otworzyć sąsiad?',
      'Do kogo dzwoni Leon?',
      'Co naprawia pracownik?',
    ],
  ];
  const promptsUk = [
    [
      'О котрій прокидається Марта?',
      'За скільки хвилин від’їжджає автобус?',
      'Що бере Марта?',
    ],
    ['Куди їде Адам?', 'Яка вода?', 'Де він вечеряє?'],
    ['Коли Ніна починає працювати?', 'Де її офіс?', 'Що вони п’ють разом?'],
    [
      'Що не може відчинити сусід?',
      'Кому телефонує Леон?',
      'Що ремонтує працівник?',
    ],
  ];
  const correctPl = [
    ['O ósmej', 'Za dwadzieścia minut', 'Klucze'],
    ['Nad morze', 'Zimna', 'W małej restauracji'],
    ['W poniedziałek', 'Blisko dworca', 'Kawę'],
    ['Drzwi', 'Do administracji', 'Zamek'],
  ];
  const correctUk = [
    ['О восьмій', 'За двадцять хвилин', 'Ключі'],
    ['До моря', 'Холодна', 'У маленькому ресторані'],
    ['У понеділок', 'Біля вокзалу', 'Каву'],
    ['Двері', 'В адміністрацію', 'Замок'],
  ];
  return [
    for (var index = 0; index < 3; index++)
      StoryQuestion(
        prompt: _lt(promptsPl[story][index], promptsUk[story][index]),
        options: [
          _lt(correctPl[story][index], correctUk[story][index]),
          _lt('Nie podano', 'Не вказано'),
          _lt('Następnego dnia', 'Наступного дня'),
        ],
        correctIndex: 0,
      ),
  ];
}
