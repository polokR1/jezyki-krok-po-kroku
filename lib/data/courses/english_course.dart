import '../../domain/models/course.dart';
import '../curriculum_seed.dart';
import '../generated/multilingual_vocabulary.dart';

final englishCourse = buildVocabularyCourse(
  id: 'english',
  languageCode: 'en',
  speechLocale: 'en-GB',
  name: const LocalizedText(pl: 'Angielski', uk: 'Англійська'),
  nativeName: 'English',
  flag: '🇬🇧',
  colorValue: 0xFF3157A4,
  topics: multilingualVocabularyTopics,
);
