import 'package:speech_to_text/speech_to_text.dart';

class RecognitionResult {
  const RecognitionResult.success() : error = null;
  const RecognitionResult.failure(this.error);

  final String? error;
  bool get isSuccess => error == null;
}

class SpeechRecognitionService {
  SpeechRecognitionService._();

  static final instance = SpeechRecognitionService._();
  final SpeechToText _speech = SpeechToText();
  bool _initialized = false;

  Future<RecognitionResult> start({
    required String locale,
    required void Function(String words, bool isFinal) onResult,
    required void Function(String message) onError,
  }) async {
    try {
      if (!_initialized) {
        _initialized = await _speech.initialize(
          onError: (error) => onError(error.errorMsg),
        );
      }
      if (!_initialized) {
        return const RecognitionResult.failure(
          'Rozpoznawanie mowy jest niedostępne na tym urządzeniu.',
        );
      }

      var localeId = locale.replaceAll('-', '_');
      try {
        final prefix = locale.substring(0, 2).toLowerCase();
        final locales = await _speech.locales();
        final matching = locales.where(
          (candidate) => candidate.localeId.toLowerCase().startsWith(prefix),
        );
        if (matching.isNotEmpty) localeId = matching.first.localeId;
      } on Object {
        // System może nadal przyjąć standardowy identyfikator locale.
      }

      await _speech.listen(
        onResult: (result) =>
            onResult(result.recognizedWords, result.finalResult),
        listenOptions: SpeechListenOptions(
          localeId: localeId,
          listenFor: const Duration(seconds: 12),
          pauseFor: const Duration(seconds: 3),
          partialResults: true,
          cancelOnError: true,
        ),
      );
      return const RecognitionResult.success();
    } on Object catch (error) {
      return RecognitionResult.failure('Błąd rozpoznawania mowy: $error');
    }
  }

  Future<void> stop() async {
    try {
      await _speech.stop();
    } on Object {
      // Brak działania jest bezpieczny przy zamykaniu ekranu.
    }
  }
}
