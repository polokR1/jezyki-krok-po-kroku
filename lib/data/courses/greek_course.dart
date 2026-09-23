import '../../domain/models/course.dart';
import '../curriculum_seed.dart';
import '../generated/multilingual_vocabulary.dart';

final greekCourse = buildVocabularyCourse(
  id: 'greek',
  languageCode: 'el',
  speechLocale: 'el-GR',
  name: const LocalizedText(pl: 'Grecki', uk: 'Грецька'),
  nativeName: 'Ελληνικά',
  flag: '🇬🇷',
  colorValue: 0xFF2377C9,
  topics: multilingualVocabularyTopics,
);
