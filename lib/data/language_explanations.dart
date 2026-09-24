import '../domain/models/course.dart';

LocalizedText lessonWhy({
  required String courseId,
  required String topicId,
  required int part,
}) {
  final context = _topicReasons[topicId] ?? _defaultTopicReason;
  final rules = _courseRules[courseId] ?? _courseRules['english']!;
  final rule = rules[part.clamp(0, rules.length - 1).toInt()];
  return LocalizedText(
    pl: 'Dlaczego ten temat? ${context.pl}\n\nDlaczego mówi się lub pisze właśnie tak? ${rule.pl}',
    uk: 'Навіщо ця тема? ${context.uk}\n\nЧому так говорять або пишуть? ${rule.uk}',
  );
}

LocalizedText courseWritingGuide(String courseId) =>
    _writingGuides[courseId] ?? _writingGuides['english']!;

const _defaultTopicReason = LocalizedText(
  pl: 'Nowe wyrażenia są pokazane w jednym kontekście, ponieważ pamięć łatwiej łączy słowo z sytuacją niż z oderwaną listą tłumaczeń.',
  uk: 'Нові вислови подано в одному контексті, бо пам’ять легше пов’язує слово із ситуацією, ніж з окремим списком перекладів.',
);

const _topicReasons = <String, LocalizedText>{
  'numbers_time': LocalizedText(
    pl: 'Liczby łączą się z godziną, ceną, datą i ilością. Całe wyrażenie trzeba zapamiętać razem, ponieważ języki inaczej budują godziny i używają innych przyimków czasu.',
    uk: 'Числа поєднуються з годиною, ціною, датою та кількістю. Цілий вислів варто вчити разом, бо мови по-різному називають час і вживають різні прийменники.',
  ),
  'people': LocalizedText(
    pl: 'Nazwy osób często wymagają informacji o rodzaju, liczbie albo relacji. Dlatego uczymy się ich razem z rodzajnikiem, zaimkiem lub typowym określeniem.',
    uk: 'Назви людей часто потребують інформації про рід, число або стосунок. Тому вчимо їх разом з артиклем, займенником чи типовим означенням.',
  ),
  'home': LocalizedText(
    pl: 'Przedmioty domowe pozwalają ćwiczyć rodzajniki, liczbę mnogą i określanie położenia. Sama nazwa rzeczy nie wystarcza, jeśli później chcemy powiedzieć, gdzie ona jest.',
    uk: 'Домашні предмети допомагають тренувати артиклі, множину й місце. Самої назви речі недостатньо, якщо потім треба сказати, де вона знаходиться.',
  ),
  'daily': LocalizedText(
    pl: 'Rutyna naturalnie łączy czasowniki z porą dnia i częstotliwością. Takie połączenia pokazują, jak z pojedynczego słowa powstaje użyteczne zdanie.',
    uk: 'Розпорядок природно поєднує дієслова з часом дня та частотністю. Такі сполучення показують, як з окремого слова утворюється корисне речення.',
  ),
  'food': LocalizedText(
    pl: 'Przy jedzeniu języki rozróżniają rzeczy policzalne i niepoliczalne oraz inaczej wyrażają ilość. Dlatego produkt warto zapamiętać z typową porcją albo czasownikiem.',
    uk: 'У темі їжі мови розрізняють злічуване й незлічуване та по-різному виражають кількість. Тому продукт варто вчити з типовою порцією або дієсловом.',
  ),
  'cafe': LocalizedText(
    pl: 'W restauracji bezpośrednie „chcę” może brzmieć zbyt ostro. Uczymy się gotowych, grzecznych konstrukcji, ponieważ ich forma zależy od zwyczaju językowego, nie od tłumaczenia słowo w słowo.',
    uk: 'У ресторані пряме «хочу» може звучати надто різко. Вчимо готові ввічливі конструкції, бо їхня форма залежить від мовної норми, а не від дослівного перекладу.',
  ),
  'shopping': LocalizedText(
    pl: 'Zakupy łączą pytania, liczby, jednostki i nazwy produktów. Końcówka albo rodzajnik może zmieniać się przy liczbie, dlatego ćwiczymy całe połączenia.',
    uk: 'Покупки поєднують запитання, числа, одиниці й назви товарів. Закінчення або артикль може змінюватися біля числа, тому тренуємо цілі сполучення.',
  ),
  'city': LocalizedText(
    pl: 'Mówienie o mieście wymaga odróżnienia miejsca od kierunku. Język może używać innej formy przy „jestem w” i innej przy „idę do”.',
    uk: 'Розмова про місто вимагає відрізняти місце від напрямку. Мова може мати різну форму для «я перебуваю в» і «я йду до».',
  ),
  'directions': LocalizedText(
    pl: 'Instrukcje drogi są krótkie i często używają trybu rozkazującego. Kolejność kroków oraz przyimki są ważniejsze niż dosłowne tłumaczenie każdego wyrazu.',
    uk: 'Пояснення дороги короткі й часто мають наказовий спосіб. Послідовність кроків і прийменники важливіші за дослівний переклад кожного слова.',
  ),
  'calendar': LocalizedText(
    pl: 'Dni, miesiące i daty łączą się z ustalonymi przyimkami oraz innym szykiem zapisu. Uczymy się całej formuły daty, aby nie przenosić polskiego wzoru.',
    uk: 'Дні, місяці й дати поєднуються з усталеними прийменниками та іншим порядком запису. Вчимо цілу формулу дати, щоб не переносити польську схему.',
  ),
  'clothing': LocalizedText(
    pl: 'Przy ubraniach przymiotnik może dopasowywać się do rodzaju, liczby lub określoności rzeczownika. Dlatego kolor i rozmiar ćwiczymy razem z nazwą ubrania.',
    uk: 'У темі одягу прикметник може узгоджуватися з родом, числом або означеністю іменника. Тому колір і розмір тренуємо разом із назвою одягу.',
  ),
  'verbs': LocalizedText(
    pl: 'Czasownik jest osią zdania, ale jego forma zależy od osoby, czasu albo miejsca w szyku. Uczymy go razem z typowym dopełnieniem, a nie jako samotny bezokolicznik.',
    uk: 'Дієслово є віссю речення, але його форма залежить від особи, часу чи місця в порядку слів. Вчимо його з типовим додатком, а не як окремий інфінітив.',
  ),
  'nature': LocalizedText(
    pl: 'Pogodę często opisuje się konstrukcją bezosobową, której nie da się przełożyć słowo w słowo. Gotowy zwrot jest więc bezpieczniejszy niż sam rzeczownik „deszcz” lub „wiatr”.',
    uk: 'Погоду часто описують безособовою конструкцією, яку не можна перекласти слово в слово. Тому готова фраза надійніша за окремий іменник «дощ» чи «вітер».',
  ),
  'work': LocalizedText(
    pl: 'Nazwy zawodów i miejsc pracy łączą się z innymi czasownikami oraz czasem występują bez rodzajnika. Przykład pokazuje naturalny wzór danego języka.',
    uk: 'Назви професій і місць роботи поєднуються з різними дієсловами та іноді вживаються без артикля. Приклад показує природну схему конкретної мови.',
  ),
  'workplace': LocalizedText(
    pl: 'W pracy znaczenie zależy także od stopnia uprzejmości. Prośba, polecenie i propozycja mogą zawierać te same słowa, lecz inną formę czasownika.',
    uk: 'На роботі значення залежить і від рівня ввічливості. Прохання, доручення та пропозиція можуть мати ті самі слова, але іншу форму дієслова.',
  ),
  'travel': LocalizedText(
    pl: 'Podróż opiera się na przewidywalnych sytuacjach: rezerwacji, bilecie, bagażu i noclegu. Gotowe schematy skracają czas potrzebny na zbudowanie wypowiedzi pod presją.',
    uk: 'Подорож складається з передбачуваних ситуацій: бронювання, квитка, багажу й ночівлі. Готові схеми скорочують час побудови вислову під тиском.',
  ),
  'services': LocalizedText(
    pl: 'W usługach używa się ustalonych połączeń czasownika z rzeczownikiem. Brzmią naturalnie dlatego, że są konwencją języka, nawet jeśli inne połączenie byłoby zrozumiałe.',
    uk: 'У сфері послуг уживають сталі сполучення дієслова з іменником. Вони звучать природно через мовну норму, навіть якщо інше сполучення було б зрозумілим.',
  ),
  'official_matters': LocalizedText(
    pl: 'Język urzędowy jest bardziej formalny i pełen stałych zwrotów. Warto zapamiętać cały wzór formularza lub prośby, zamiast tworzyć go przez dosłowne tłumaczenie.',
    uk: 'Офіційна мова формальніша й містить багато сталих фраз. Варто запам’ятати цілу схему форми чи прохання, а не будувати її дослівним перекладом.',
  ),
  'adjectives': LocalizedText(
    pl: 'Przymiotnik może stać przed albo po rzeczowniku i może zmieniać końcówkę. Jego miejsce oraz forma niosą informację o rodzaju, liczbie lub nacisku.',
    uk: 'Прикметник може стояти перед або після іменника та змінювати закінчення. Його місце й форма передають рід, число або смисловий наголос.',
  ),
  'emotions': LocalizedText(
    pl: 'Uczucia nie zawsze są wyrażane czasownikiem „być”. Niektóre języki mówią dosłownie „mam głód” albo „podoba mi się”, dlatego uczymy się całej konstrukcji.',
    uk: 'Почуття не завжди виражають дієсловом «бути». Деякі мови буквально кажуть «маю голод» або «мені подобається», тому вчимо цілу конструкцію.',
  ),
  'body': LocalizedText(
    pl: 'Przy częściach ciała języki różnie używają rodzajnika i zaimka dzierżawczego. Naturalna forma może dosłownie znaczyć „boli mnie głowa”, a nie „moja głowa boli”.',
    uk: 'З частинами тіла мови по-різному вживають артикль і присвійний займенник. Природна форма може буквально означати «мені болить голова», а не «моя голова болить».',
  ),
  'health_visit': LocalizedText(
    pl: 'Opis objawu musi wskazać miejsce, czas i nasilenie. Lekarz częściej oczekuje naturalnego zwrotu niż pojedynczej nazwy choroby.',
    uk: 'Опис симптому має вказувати місце, час і силу. Лікар частіше очікує природну фразу, ніж окрему назву хвороби.',
  ),
  'housing_help': LocalizedText(
    pl: 'Zgłoszenie usterki łączy opis stanu z prośbą o działanie. Rozróżnienie „nie działa” od „proszę naprawić” pomaga mówić jasno i uprzejmie.',
    uk: 'Повідомлення про несправність поєднує опис стану з проханням про дію. Різниця між «не працює» і «прошу полагодити» допомагає говорити чітко й ввічливо.',
  ),
  'emergency': LocalizedText(
    pl: 'W nagłej sytuacji zdania powinny być krótkie i jednoznaczne. Najważniejsze są czasownik działania, miejsce oraz informacja o osobie poszkodowanej.',
    uk: 'У надзвичайній ситуації речення мають бути короткі й однозначні. Найважливіші дієслово дії, місце та інформація про постраждалого.',
  ),
  'education': LocalizedText(
    pl: 'Czasowniki związane z nauką wymagają różnych przyimków i dopełnień. „Uczyć się języka”, „uczyć kogoś” i „dowiedzieć się” to odrębne wzory.',
    uk: 'Дієслова навчання потребують різних прийменників і додатків. «Вивчати мову», «навчати когось» і «дізнатися» — це різні схеми.',
  ),
  'communication': LocalizedText(
    pl: 'Czasowniki mówienia łączą się z osobą, tematem albo całym zdaniem na różne sposoby. Przyimek i szyk pokazują, kto mówi do kogo.',
    uk: 'Дієслова мовлення по-різному поєднуються з особою, темою чи цілим реченням. Прийменник і порядок слів показують, хто до кого говорить.',
  ),
  'technology': LocalizedText(
    pl: 'Wiele słów technologicznych jest zapożyczonych, ale ich wymowa i odmiana dostosowują się do języka. Podobny zapis nie zawsze oznacza identyczne brzmienie.',
    uk: 'Багато технологічних слів запозичені, але їхня вимова й відмінювання пристосовуються до мови. Схоже написання не завжди означає однакове звучання.',
  ),
  'society': LocalizedText(
    pl: 'Tematy społeczne częściej używają rzeczowników abstrakcyjnych i formalnych łączników. Dzięki nim wypowiedź brzmi precyzyjnie, a nie jak zbiór prostych zdań.',
    uk: 'Суспільні теми частіше використовують абстрактні іменники й формальні сполучники. Завдяки їм вислів точний, а не схожий на набір простих речень.',
  ),
  'thinking': LocalizedText(
    pl: 'Opinia może być pewna, ostrożna albo uprzejmie przeciwna. Zwroty wprowadzające pokazują nastawienie mówiącego jeszcze przed właściwym argumentem.',
    uk: 'Думка може бути впевненою, обережною або ввічливо заперечною. Вступні фрази показують ставлення мовця ще до основного аргументу.',
  ),
  'connectors': LocalizedText(
    pl: 'Łączniki pokazują przyczynę, skutek, kontrast i kolejność. W niektórych językach wpływają także na szyk następnej części zdania, dlatego ćwiczymy je w całości.',
    uk: 'Сполучники показують причину, наслідок, протиставлення й послідовність. У деяких мовах вони впливають і на порядок наступної частини речення, тому тренуємо їх у цілому.',
  ),
};

const _courseRules = <String, List<LocalizedText>>{
  'english': [
    LocalizedText(
      pl: 'Angielski ma mało końcówek, więc funkcję wyrazu pokazuje głównie jego miejsce. Podmiot zwykle musi być zapisany: „I work here”, ponieważ samo „work here” brzmiałoby jak polecenie.',
      uk: 'В англійській мало закінчень, тому роль слова показує передусім його місце. Підмет зазвичай треба написати: «I work here», бо саме «work here» звучало б як наказ.',
    ),
    LocalizedText(
      pl: 'Pisownia angielska zachowała ślady starszej wymowy, dlatego jedna litera może brzmieć różnie. Nie należy czytać słowa mechanicznie po polsku; zapis trzeba łączyć z odsłuchem i całym przykładem.',
      uk: 'Англійський правопис зберіг сліди давнішої вимови, тому та сама літера може звучати по-різному. Не варто читати слово механічно; написання треба поєднувати з аудіо та цілим прикладом.',
    ),
    LocalizedText(
      pl: 'W pytaniach i przeczeniach do/does/did przejmuje informację o osobie lub czasie, dlatego główny czasownik wraca do formy podstawowej: „Does she work?”, nie „Does she works?”.',
      uk: 'У запитаннях і запереченнях do/does/did бере на себе особу або час, тому головне дієслово повертається до початкової форми: «Does she work?», а не «Does she works?».',
    ),
    LocalizedText(
      pl: 'Rodzajniki pokazują, czy rzecz jest nowa, dowolna czy już znana rozmówcom. Przyimki i czasowniki tworzą też stałe połączenia, więc naturalniej uczyć się „listen to” albo „wait for” jako jednej jednostki.',
      uk: 'Артиклі показують, чи річ нова, будь-яка або вже відома співрозмовникам. Прийменники й дієслова утворюють сталі сполучення, тому природніше вчити «listen to» чи «wait for» як одну одиницю.',
    ),
  ],
  'spanish': [
    LocalizedText(
      pl: 'Końcówka hiszpańskiego czasownika wskazuje osobę, dlatego zaimek często można pominąć. „Hablo español” już oznacza „mówię po hiszpańsku”; dodanie „yo” służy zwykle podkreśleniu lub kontrastowi.',
      uk: 'Закінчення іспанського дієслова показує особу, тому займенник часто можна пропустити. «Hablo español» уже означає «я говорю іспанською»; «yo» зазвичай додають для наголосу чи протиставлення.',
    ),
    LocalizedText(
      pl: 'Rzeczowniki mają rodzaj, a rodzajniki i przymiotniki zwykle się z nim zgadzają: „la casa blanca”, ale „el coche blanco”. Dlatego rzeczownika nie warto zapamiętywać bez el albo la.',
      uk: 'Іменники мають рід, а артиклі й прикметники зазвичай з ним узгоджуються: «la casa blanca», але «el coche blanco». Тому іменник варто вчити разом з el або la.',
    ),
    LocalizedText(
      pl: 'Hiszpańskie pytanie nie potrzebuje angielskiego operatora do. Intonację i granice pytania pokazują znaki ¿…?, a zaimek pytający często ma akcent: „¿Qué significa esto?”.',
      uk: 'Іспанське запитання не потребує англійського do. Інтонацію й межі питання показують знаки ¿…?, а питальний займенник часто має наголос: «¿Qué significa esto?».',
    ),
    LocalizedText(
      pl: 'Samogłoski a, e, i, o, u zachowują dość stałe brzmienie. Znak akcentu wskazuje nietypowy nacisk albo rozróżnia wyrazy, np. „sí” — tak i „si” — jeśli, więc jest częścią poprawnej pisowni.',
      uk: 'Голосні a, e, i, o, u мають доволі стале звучання. Знак наголосу показує нетиповий наголос або розрізняє слова, наприклад «sí» — так і «si» — якщо, тому він є частиною правильного написання.',
    ),
  ],
  'greek': [
    LocalizedText(
      pl: 'Nowoczesny grecki należy czytać bez transliteracji. Podobny kształt może oznaczać inny dźwięk — Β brzmi jak „w”, Ρ jak „r”, a Η jak „i” — dlatego bezpośrednie połączenie znaku z dźwiękiem zapobiega trwałym błędom.',
      uk: 'Сучасну грецьку варто читати без транслітерації. Схожа форма може означати інший звук: Β звучить як «в», Ρ як «р», а Η як «і», тому прямий зв’язок знака зі звуком запобігає стійким помилкам.',
    ),
    LocalizedText(
      pl: 'Akcent graficzny pokazuje, którą sylabę wymawia się mocniej i może odróżniać formy. Pominięcie go jest błędem zapisu, dlatego słowo zapamiętujemy od razu razem z akcentem.',
      uk: 'Графічний наголос показує, який склад вимовляється сильніше, і може розрізняти форми. Його пропуск є помилкою, тому слово відразу запам’ятовуємо разом із наголосом.',
    ),
    LocalizedText(
      pl: 'Rodzajnik ο, η albo το informuje o rodzaju, a jego forma zmienia się zależnie od funkcji rzeczownika. Końcówka niesie więc informację gramatyczną; najlepiej uczyć się rzeczownika razem z rodzajnikiem.',
      uk: 'Артикль ο, η або το показує рід, а його форма змінюється залежно від ролі іменника. Закінчення несе граматичну інформацію, тому іменник найкраще вчити разом з артиклем.',
    ),
    LocalizedText(
      pl: 'Kilka zapisów historycznie zbliżyło się do tego samego dźwięku: η, ι, υ, ει i οι wymawia się dziś jak „i”. Dlatego poprawnej pisowni nie da się zawsze odgadnąć ze słuchu — potrzebne jest równoczesne patrzenie i słuchanie.',
      uk: 'Кілька історичних написань зблизилися до одного звука: η, ι, υ, ει та οι сьогодні вимовляються як «і». Тому правопис не завжди можна вгадати на слух — треба одночасно дивитися й слухати.',
    ),
  ],
  'swedish': [
    LocalizedText(
      pl: 'Szwedzkie rzeczowniki należą do grupy en albo ett, a wybór wpływa na przymiotnik i późniejszą formę określoną. Rodzaju zwykle nie da się pewnie odgadnąć, dlatego uczymy się „en bil” i „ett hus” jako całości.',
      uk: 'Шведські іменники належать до групи en або ett, і цей вибір впливає на прикметник та означену форму. Рід не завжди можна вгадати, тому вчимо «en bil» і «ett hus» як цілісні одиниці.',
    ),
    LocalizedText(
      pl: 'Określoność często zapisuje się końcówką dołączoną do rzeczownika: „en bil” zmienia się w „bilen”, a „ett hus” w „huset”. To dlatego szwedzkie „the” nie zawsze stoi jako osobne słowo.',
      uk: 'Означеність часто виражається закінченням іменника: «en bil» стає «bilen», а «ett hus» — «huset». Тому шведське «the» не завжди є окремим словом.',
    ),
    LocalizedText(
      pl: 'W głównym zdaniu odmieniony czasownik zajmuje zwykle drugą pozycję. Gdy na początku stoi czas, otrzymujemy „I dag arbetar jag”, a nie polski szyk przeniesiony słowo w słowo.',
      uk: 'У головному реченні змінене дієслово зазвичай стоїть на другій позиції. Коли спочатку є час, маємо «I dag arbetar jag», а не дослівно перенесений слов’янський порядок.',
    ),
    LocalizedText(
      pl: 'Długość samogłoski i następującej spółgłoski współtworzy wymowę, a zapis nie oddaje całej melodii słowa. Dlatego trzeba słuchać pełnej formy, szczególnie przy å, ä, ö oraz zbitkach sj i sk.',
      uk: 'Довжина голосної й наступної приголосної разом формують вимову, а написання не передає всієї мелодики слова. Тому слід слухати цілу форму, особливо з å, ä, ö та сполученнями sj і sk.',
    ),
  ],
};

const _writingGuides = <String, LocalizedText>{
  'english': LocalizedText(
    pl: 'Czytaj przykład od lewej do prawej i zaznacz: podmiot, czasownik oraz resztę informacji. W angielskim miejsce wyrazu często zastępuje końcówkę, dlatego zmiana szyku może zmienić funkcję lub sens zdania.',
    uk: 'Читай приклад зліва направо й знайди підмет, дієслово та решту інформації. В англійській місце слова часто замінює закінчення, тому зміна порядку може змінити роль або сенс речення.',
  ),
  'spanish': LocalizedText(
    pl: 'Najpierw znajdź czasownik i jego końcówkę, potem sprawdź zgodność rodzajnika, rzeczownika i przymiotnika. Zapisuj oba znaki pytania oraz akcenty — nie są ozdobą, lecz przekazują informację.',
    uk: 'Спочатку знайди дієслово та його закінчення, потім перевір узгодження артикля, іменника й прикметника. Пиши обидва знаки питання та наголоси — це не прикраса, а інформація.',
  ),
  'greek': LocalizedText(
    pl: 'Rozpoznaj litery bez przepisywania ich na alfabet łaciński, znajdź akcent i przeczytaj całe sylaby. Przy rzeczowniku obserwuj rodzajnik oraz końcówkę, bo pokazują jego rolę w zdaniu.',
    uk: 'Розпізнавай літери без переписування латинкою, знайди наголос і читай цілими складами. Біля іменника стеж за артиклем і закінченням, бо вони показують його роль у реченні.',
  ),
  'swedish': LocalizedText(
    pl: 'Przy rzeczowniku zaznacz en lub ett i sprawdź końcówkę formy określonej. W całym zdaniu policz pozycje: odmieniony czasownik powinien zwykle znaleźć się na drugim miejscu.',
    uk: 'Біля іменника познач en або ett і перевір закінчення означеної форми. У всьому реченні порахуй позиції: змінене дієслово зазвичай має бути другим.',
  ),
};
