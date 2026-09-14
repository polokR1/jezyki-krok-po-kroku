import 'package:flutter_tts/flutter_tts.dart';

class SpeechResult {
  const SpeechResult.success() : error = null;
  const SpeechResult.failure(this.error);

  final String? error;
  bool get isSuccess => error == null;
}

class SpeechService {
  SpeechService._();

  static final instance = SpeechService._();
  final FlutterTts _tts = FlutterTts();

  Future<SpeechResult> speak({
    required String text,
    required String locale,
    required double rate,
  }) async {
    if (text.trim().isEmpty) {
      return const SpeechResult.failure('Brak tekstu do odtworzenia.');
    }
    try {
      await _tts.stop();
      final languageResult = await _tts.setLanguage(locale);
      if (languageResult == 0 || languageResult == false) {
        return SpeechResult.failure(
          'Na urządzeniu nie ma głosu dla języka $locale.',
        );
      }
      await _tts.setSpeechRate(rate.clamp(0.2, 0.65));
      await _tts.setPitch(1.0);
      final result = await _tts.speak(text);
      if (result == 0 || result == false) {
        return const SpeechResult.failure('Nie udało się uruchomić wymowy.');
      }
      return const SpeechResult.success();
    } on Object catch (error) {
      return SpeechResult.failure('Błąd syntezatora mowy: $error');
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } on Object {
      // Zatrzymanie mowy jest operacją pomocniczą; ekran może być zamykany.
    }
  }
}
