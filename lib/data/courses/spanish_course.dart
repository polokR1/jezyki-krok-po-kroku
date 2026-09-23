import '../../domain/models/course.dart';
import '../curriculum_seed.dart';
import '../generated/multilingual_vocabulary.dart';

final spanishCourse = buildVocabularyCourse(
  id: 'spanish',
  languageCode: 'es',
  speechLocale: 'es-ES',
  name: const LocalizedText(pl: 'Hiszpański', uk: 'Іспанська'),
  nativeName: 'Español',
  flag: '🇪🇸',
  colorValue: 0xFFE0523D,
  topics: multilingualVocabularyTopics,
);
