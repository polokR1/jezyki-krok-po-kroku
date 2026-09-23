import '../../domain/models/course.dart';
import '../curriculum_seed.dart';
import '../generated/multilingual_vocabulary.dart';

final swedishCourse = buildVocabularyCourse(
  id: 'swedish',
  languageCode: 'sv',
  speechLocale: 'sv-SE',
  name: const LocalizedText(pl: 'Szwedzki', uk: 'Шведська'),
  nativeName: 'Svenska',
  flag: '🇸🇪',
  colorValue: 0xFF126782,
  topics: multilingualVocabularyTopics,
);
