import 'package:flutter/material.dart';

import '../domain/models/course.dart';
import '../l10n/app_localization.dart';
import '../services/speech_service.dart';
import '../state/app_controller.dart';

class PracticeHubScreen extends StatelessWidget {
  const PracticeHubScreen({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final course = controller.selectedCourse!;
    final language = controller.interfaceLanguage;
    return Scaffold(
      appBar: AppBar(
        title: Text(localized(language, pl: 'Praktyka', uk: 'Практика')),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
        children: [
          _IntroCard(course: course, language: language),
          const SizedBox(height: 16),
          _SectionCard(
            icon: Icons.school_rounded,
            title: localized(language, pl: 'Gramatyka', uk: 'Граматика'),
            subtitle: localized(
              language,
              pl: '16 lekcji od podstaw do B1',
              uk: '16 уроків від основ до B1',
            ),
            children: [
              for (final lesson in course.grammarLessons)
                _ActivityTile(
                  level: lesson.level,
                  title: lesson.title.resolve(language),
                  completed: controller.isActivityCompleted(
                    course.id,
                    lesson.id,
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => GrammarLessonScreen(
                        controller: controller,
                        course: course,
                        lesson: lesson,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          _SectionCard(
            icon: Icons.record_voice_over_rounded,
            title: localized(language, pl: 'Dialogi', uk: 'Діалоги'),
            subtitle: localized(
              language,
              pl: '4 praktyczne sytuacje z odsłuchem',
              uk: '4 практичні ситуації з прослуховуванням',
            ),
            children: [
              for (final dialogue in course.dialogues)
                _ActivityTile(
                  level: dialogue.level,
                  title: dialogue.title.resolve(language),
                  completed: controller.isActivityCompleted(
                    course.id,
                    dialogue.id,
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DialogueScreen(
                        controller: controller,
                        course: course,
                        dialogue: dialogue,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          _SectionCard(
            icon: Icons.auto_stories_rounded,
            title: localized(language, pl: 'Historie', uk: 'Історії'),
            subtitle: localized(
              language,
              pl: '4 teksty, nagrania i pytania',
              uk: '4 тексти, записи та запитання',
            ),
            children: [
              for (final story in course.stories)
                _ActivityTile(
                  level: story.level,
                  title: story.title.resolve(language),
                  completed: controller.isActivityCompleted(
                    course.id,
                    story.id,
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => StoryScreen(
                        controller: controller,
                        course: course,
                        story: story,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({required this.course, required this.language});
  final LanguageCourse course;
  final String language;

  @override
  Widget build(BuildContext context) => Card(
    color: Color(course.colorValue).withValues(alpha: 0.12),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Text(course.flag, style: const TextStyle(fontSize: 42)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localized(
                    language,
                    pl: '${course.activityCount} aktywności w pełnym kursie',
                    uk: '${course.activityCount} активностей у повному курсі',
                  ),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  localized(
                    language,
                    pl: 'Słownictwo, gramatyka, dialogi i czytanie',
                    uk: 'Лексика, граматика, діалоги та читання',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.children,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Card(
    child: ExpansionTile(
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(subtitle),
      children: children,
    ),
  );
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.level,
    required this.title,
    required this.completed,
    required this.onTap,
  });
  final String level;
  final String title;
  final bool completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: CircleAvatar(
      child: completed ? const Icon(Icons.check_rounded) : Text(level),
    ),
    title: Text(title),
    trailing: const Icon(Icons.chevron_right_rounded),
    onTap: onTap,
  );
}

mixin _SpeechSupport<T extends StatefulWidget> on State<T> {
  Future<void> speak(
    LanguageCourse course,
    AppController controller,
    String text,
  ) async {
    final result = await SpeechService.instance.speak(
      text: text,
      locale: course.speechLocale,
      rate: controller.speechRate,
    );
    if (!result.isSuccess && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.error ?? 'Nie udało się odtworzyć głosu.'),
        ),
      );
    }
  }
}

class GrammarLessonScreen extends StatefulWidget {
  const GrammarLessonScreen({
    super.key,
    required this.controller,
    required this.course,
    required this.lesson,
  });
  final AppController controller;
  final LanguageCourse course;
  final GrammarLesson lesson;

  @override
  State<GrammarLessonScreen> createState() => _GrammarLessonScreenState();
}

class _GrammarLessonScreenState extends State<GrammarLessonScreen>
    with _SpeechSupport<GrammarLessonScreen> {
  @override
  Widget build(BuildContext context) {
    final language = widget.controller.interfaceLanguage;
    return Scaffold(
      appBar: AppBar(title: Text(widget.lesson.title.resolve(language))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Chip(label: Text(widget.lesson.level)),
          const SizedBox(height: 14),
          Text(
            widget.lesson.explanation.resolve(language),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  Text(
                    widget.lesson.exampleTarget,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.lesson.exampleTranslation.resolve(language),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  IconButton.filledTonal(
                    onPressed: () => speak(
                      widget.course,
                      widget.controller,
                      widget.lesson.exampleTarget,
                    ),
                    icon: const Icon(Icons.volume_up_rounded),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () async {
              await widget.controller.completeActivity(
                course: widget.course,
                activityId: widget.lesson.id,
              );
              if (context.mounted) Navigator.pop(context);
            },
            icon: const Icon(Icons.check_rounded),
            label: Text(
              localized(
                language,
                pl: 'Oznacz jako ukończone',
                uk: 'Позначити як завершене',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DialogueScreen extends StatefulWidget {
  const DialogueScreen({
    super.key,
    required this.controller,
    required this.course,
    required this.dialogue,
  });
  final AppController controller;
  final LanguageCourse course;
  final DialogueScenario dialogue;

  @override
  State<DialogueScreen> createState() => _DialogueScreenState();
}

class _DialogueScreenState extends State<DialogueScreen>
    with _SpeechSupport<DialogueScreen> {
  @override
  Widget build(BuildContext context) {
    final language = widget.controller.interfaceLanguage;
    return Scaffold(
      appBar: AppBar(title: Text(widget.dialogue.title.resolve(language))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(widget.dialogue.situation.resolve(language)),
          const SizedBox(height: 18),
          for (var index = 0; index < widget.dialogue.lines.length; index++)
            Align(
              alignment: index.isEven
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Card(
                color: index.isEven
                    ? null
                    : Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.dialogue.lines[index].speaker,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.dialogue.lines[index].target,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        widget.dialogue.lines[index].translation.resolve(
                          language,
                        ),
                      ),
                      IconButton(
                        onPressed: () => speak(
                          widget.course,
                          widget.controller,
                          widget.dialogue.lines[index].target,
                        ),
                        icon: const Icon(Icons.volume_up_rounded),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: () async {
              await widget.controller.completeActivity(
                course: widget.course,
                activityId: widget.dialogue.id,
                minutes: 10,
              );
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(
              localized(language, pl: 'Ukończ dialog', uk: 'Завершити діалог'),
            ),
          ),
        ],
      ),
    );
  }
}

class StoryScreen extends StatefulWidget {
  const StoryScreen({
    super.key,
    required this.controller,
    required this.course,
    required this.story,
  });
  final AppController controller;
  final LanguageCourse course;
  final CourseStory story;

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with _SpeechSupport<StoryScreen> {
  final Map<int, int> _answers = {};
  var _showTranslation = false;
  var _checked = false;

  @override
  Widget build(BuildContext context) {
    final language = widget.controller.interfaceLanguage;
    return Scaffold(
      appBar: AppBar(title: Text(widget.story.title.resolve(language))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.story.targetText,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (_showTranslation) ...[
                    const Divider(height: 28),
                    Text(widget.story.translation.resolve(language)),
                  ],
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      IconButton.filledTonal(
                        onPressed: () => speak(
                          widget.course,
                          widget.controller,
                          widget.story.targetText,
                        ),
                        icon: const Icon(Icons.headphones_rounded),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () => setState(
                          () => _showTranslation = !_showTranslation,
                        ),
                        child: Text(
                          localized(
                            language,
                            pl: _showTranslation
                                ? 'Ukryj tłumaczenie'
                                : 'Pokaż tłumaczenie',
                            uk: _showTranslation
                                ? 'Сховати переклад'
                                : 'Показати переклад',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          for (
            var question = 0;
            question < widget.story.questions.length;
            question++
          ) ...[
            Text(
              '${question + 1}. ${widget.story.questions[question].prompt.resolve(language)}',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            RadioGroup<int>(
              groupValue: _answers[question],
              onChanged: (value) {
                if (!_checked && value != null) {
                  setState(() => _answers[question] = value);
                }
              },
              child: Column(
                children: [
                  for (
                    var option = 0;
                    option < widget.story.questions[question].options.length;
                    option++
                  )
                    RadioListTile<int>(
                      value: option,
                      enabled: !_checked,
                      title: Text(
                        widget.story.questions[question].options[option]
                            .resolve(language),
                      ),
                    ),
                ],
              ),
            ),
          ],
          FilledButton(
            onPressed: _answers.length != widget.story.questions.length
                ? null
                : () => _finish(language),
            child: Text(
              localized(
                language,
                pl: 'Sprawdź odpowiedzi',
                uk: 'Перевірити відповіді',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _finish(String language) async {
    final correct = [
      for (var index = 0; index < widget.story.questions.length; index++)
        _answers[index] == widget.story.questions[index].correctIndex,
    ].where((value) => value).length;
    setState(() => _checked = true);
    if (correct == widget.story.questions.length) {
      await widget.controller.completeActivity(
        course: widget.course,
        activityId: widget.story.id,
        minutes: 12,
      );
      if (mounted) Navigator.pop(context);
      return;
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localized(
              language,
              pl: 'Poprawne odpowiedzi: $correct/${widget.story.questions.length}. Przeczytaj tekst ponownie.',
              uk: 'Правильні відповіді: $correct/${widget.story.questions.length}. Прочитай текст ще раз.',
            ),
          ),
          action: SnackBarAction(
            label: localized(
              language,
              pl: 'Spróbuj ponownie',
              uk: 'Спробувати ще',
            ),
            onPressed: () => setState(() {
              _answers.clear();
              _checked = false;
            }),
          ),
        ),
      );
    }
  }
}
