import 'package:flutter/material.dart';

import '../domain/learning/learning_engine.dart';
import '../domain/models/course.dart';
import '../l10n/app_localization.dart';
import '../services/speech_service.dart';
import '../state/app_controller.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({
    super.key,
    required this.controller,
    required this.course,
    required this.lesson,
  });

  final AppController controller;
  final LanguageCourse course;
  final CourseLesson lesson;

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final _answerController = TextEditingController();
  late List<LearningExercise> _exercises;
  var _studyIndex = 0;
  var _exerciseIndex = 0;
  var _studying = true;
  var _finished = false;
  var _answered = false;
  var _correct = 0;
  bool? _lastCorrect;
  String? _selectedOption;

  String get _language => widget.controller.interfaceLanguage;

  @override
  void initState() {
    super.initState();
    _buildExercises();
  }

  void _buildExercises() {
    _exercises = LearningEngine.buildExercises(
      course: widget.course,
      lesson: widget.lesson,
      interfaceLanguage: widget.controller.interfaceLanguage,
    );
  }

  @override
  void dispose() {
    _answerController.dispose();
    SpeechService.instance.stop();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    final result = await SpeechService.instance.speak(
      text: text,
      locale: widget.course.speechLocale,
      rate: widget.controller.speechRate,
    );
    if (!result.isSuccess && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.error!)));
    }
  }

  void _nextStudyCard() {
    if (_studyIndex + 1 < widget.lesson.items.length) {
      setState(() => _studyIndex++);
    } else {
      setState(() {
        _studying = false;
        _studyIndex = 0;
      });
    }
  }

  void _checkAnswer() {
    if (_answered) return;
    final exercise = _exercises[_exerciseIndex];
    final actual = exercise.type == ExerciseType.writing
        ? _answerController.text
        : _selectedOption ?? '';
    if (actual.trim().isEmpty) return;
    final matches = LearningEngine.answersMatch(actual, exercise.answer);
    setState(() {
      _answered = true;
      _lastCorrect = matches;
      if (matches) _correct++;
    });
  }

  Future<void> _nextExercise() async {
    if (_exerciseIndex + 1 < _exercises.length) {
      setState(() {
        _exerciseIndex++;
        _answered = false;
        _lastCorrect = null;
        _selectedOption = null;
        _answerController.clear();
      });
      return;
    }
    await widget.controller.completeLesson(
      course: widget.course,
      lesson: widget.lesson,
      correctAnswers: _correct,
    );
    if (mounted) setState(() => _finished = true);
  }

  void _retry() {
    setState(() {
      _exerciseIndex = 0;
      _correct = 0;
      _finished = false;
      _answered = false;
      _lastCorrect = null;
      _selectedOption = null;
      _answerController.clear();
      _buildExercises();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_finished) return _resultScreen();
    return Scaffold(
      appBar: AppBar(title: Text(widget.lesson.title.resolve(_language))),
      body: SafeArea(
        top: false,
        child: _studying ? _studyView() : _exerciseView(),
      ),
    );
  }

  Widget _studyView() {
    final item = widget.lesson.items[_studyIndex];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                localized(_language, pl: 'POZNAJ ZWROTY', uk: 'ВИВЧИ ФРАЗИ'),
              ),
              const Spacer(),
              Text('${_studyIndex + 1}/${widget.lesson.items.length}'),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: (_studyIndex + 1) / widget.lesson.items.length,
          ),
          const SizedBox(height: 22),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(26),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.target,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    if (item.pronunciation != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        '[${item.pronunciation}]',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                    const SizedBox(height: 20),
                    Text(
                      item.translation.resolve(_language),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    if (item.exampleTarget != null) ...[
                      const SizedBox(height: 28),
                      const Divider(),
                      const SizedBox(height: 14),
                      Text(item.exampleTarget!, textAlign: TextAlign.center),
                      if (item.exampleTranslation != null)
                        Text(
                          item.exampleTranslation!.resolve(_language),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                    const SizedBox(height: 24),
                    IconButton.filledTonal(
                      tooltip: localized(
                        _language,
                        pl: 'Posłuchaj',
                        uk: 'Прослухати',
                      ),
                      onPressed: () => _speak(item.target),
                      icon: const Icon(Icons.volume_up_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: _nextStudyCard,
            child: Text(
              _studyIndex + 1 == widget.lesson.items.length
                  ? localized(
                      _language,
                      pl: 'Przejdź do ćwiczeń',
                      uk: 'Перейти до вправ',
                    )
                  : localized(_language, pl: 'Dalej', uk: 'Далі'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _exerciseView() {
    final exercise = _exercises[_exerciseIndex];
    final canCheck = exercise.type == ExerciseType.writing
        ? _answerController.text.trim().isNotEmpty
        : _selectedOption != null;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Row(
          children: [
            Text(localized(_language, pl: 'ĆWICZENIA', uk: 'ВПРАВИ')),
            const Spacer(),
            Text('${_exerciseIndex + 1}/${_exercises.length}'),
          ],
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: (_exerciseIndex + 1) / _exercises.length,
        ),
        const SizedBox(height: 30),
        Text(
          _instruction(exercise.type),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 18),
        if (exercise.type == ExerciseType.listening)
          Center(
            child: FilledButton.tonalIcon(
              onPressed: () => _speak(exercise.item.target),
              icon: const Icon(Icons.headphones_rounded),
              label: Text(
                localized(
                  _language,
                  pl: 'Odtwórz nagranie',
                  uk: 'Відтворити запис',
                ),
              ),
            ),
          )
        else
          Text(
            exercise.prompt,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
        const SizedBox(height: 26),
        if (exercise.type == ExerciseType.writing)
          TextField(
            controller: _answerController,
            enabled: !_answered,
            autocorrect: false,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _checkAnswer(),
            decoration: InputDecoration(
              labelText: localized(
                _language,
                pl: 'Twoja odpowiedź',
                uk: 'Твоя відповідь',
              ),
            ),
          )
        else
          RadioGroup<String>(
            groupValue: _selectedOption,
            onChanged: (value) {
              if (!_answered && value != null) {
                setState(() => _selectedOption = value);
              }
            },
            child: Column(
              children: [
                for (final option in exercise.options) ...[
                  Card(
                    color: _optionColor(option, exercise.answer),
                    child: RadioListTile<String>(
                      value: option,
                      enabled: !_answered,
                      title: Text(option),
                    ),
                  ),
                  const SizedBox(height: 9),
                ],
              ],
            ),
          ),
        if (_answered) ...[
          const SizedBox(height: 18),
          Card(
            color: _lastCorrect!
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _lastCorrect!
                        ? localized(_language, pl: 'Dobrze!', uk: 'Правильно!')
                        : localized(
                            _language,
                            pl: 'Jeszcze nie tym razem',
                            uk: 'Цього разу не вийшло',
                          ),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  if (!_lastCorrect!) ...[
                    const SizedBox(height: 6),
                    Text(
                      '${localized(_language, pl: 'Poprawna odpowiedź', uk: 'Правильна відповідь')}: ${exercise.answer}',
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _answered
              ? _nextExercise
              : (canCheck ? _checkAnswer : null),
          child: Text(
            _answered
                ? (_exerciseIndex + 1 == _exercises.length
                      ? localized(
                          _language,
                          pl: 'Zakończ lekcję',
                          uk: 'Завершити урок',
                        )
                      : localized(_language, pl: 'Dalej', uk: 'Далі'))
                : localized(_language, pl: 'Sprawdź', uk: 'Перевірити'),
          ),
        ),
      ],
    );
  }

  String _instruction(ExerciseType type) => switch (type) {
    ExerciseType.choice => localized(
      _language,
      pl: 'Wybierz właściwe znaczenie',
      uk: 'Обери правильне значення',
    ),
    ExerciseType.writing => localized(
      _language,
      pl: 'Napisz w języku ${widget.course.name.resolve(_language).toLowerCase()}',
      uk: 'Напиши мовою курсу',
    ),
    ExerciseType.listening => localized(
      _language,
      pl: 'Posłuchaj i wybierz znaczenie',
      uk: 'Прослухай і обери значення',
    ),
  };

  Color? _optionColor(String option, String answer) {
    if (!_answered) return null;
    if (option == answer) return Theme.of(context).colorScheme.primaryContainer;
    if (option == _selectedOption && !_lastCorrect!) {
      return Theme.of(context).colorScheme.errorContainer;
    }
    return null;
  }

  Widget _resultScreen() {
    final passed = _correct >= (_exercises.length * 0.8).ceil();
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                passed ? Icons.emoji_events_rounded : Icons.refresh_rounded,
                size: 78,
                color: passed
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(height: 22),
              Text(
                passed
                    ? localized(
                        _language,
                        pl: 'Lekcja ukończona!',
                        uk: 'Урок завершено!',
                      )
                    : localized(
                        _language,
                        pl: 'Warto spróbować ponownie',
                        uk: 'Варто спробувати ще раз',
                      ),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                localized(
                  _language,
                  pl: 'Poprawne odpowiedzi: $_correct/${_exercises.length}',
                  uk: 'Правильні відповіді: $_correct/${_exercises.length}',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  localized(
                    _language,
                    pl: 'Wróć do kursu',
                    uk: 'Повернутися до курсу',
                  ),
                ),
              ),
              if (!passed) ...[
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: _retry,
                  child: Text(
                    localized(
                      _language,
                      pl: 'Powtórz ćwiczenia',
                      uk: 'Повторити вправи',
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
