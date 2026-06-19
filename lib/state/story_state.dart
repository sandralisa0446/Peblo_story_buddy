import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

// Tracks what stage the narration is in.
enum TtsStatus { idle, loading, playing, completed, failed }

// Tracks what stage the quiz is in.
enum QuizStatus { hidden, visible, wrongAnswer, correct }

class StoryState extends ChangeNotifier {
  final FlutterTts _flutterTts = FlutterTts();

  TtsStatus ttsStatus = TtsStatus.idle;
  QuizStatus quizStatus = QuizStatus.hidden;

  StoryState() {
    _setupTtsHandlers();
  }

  void _setupTtsHandlers() {
    _flutterTts.setStartHandler(() {
      ttsStatus = TtsStatus.playing;
      notifyListeners();
    });

    _flutterTts.setCompletionHandler(() {
      ttsStatus = TtsStatus.completed;
      quizStatus = QuizStatus.visible;
      notifyListeners();
    });

    _flutterTts.setErrorHandler((message) {
      ttsStatus = TtsStatus.failed;
      notifyListeners();
    });
  }

  Future<void> readStory(String text) async {
    try {
      ttsStatus = TtsStatus.loading;
      notifyListeners();

      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.45);
      await _flutterTts.setPitch(1.1);

      final result = await _flutterTts.speak(text);

      // speak() returns 1 on success being kicked off, but actual
      // playback start/finish is handled by the handlers above.
      if (result != 1) {
        ttsStatus = TtsStatus.failed;
        notifyListeners();
      }
    } catch (e) {
      ttsStatus = TtsStatus.failed;
      notifyListeners();
    }
  }

  void retryReading(String text) {
    readStory(text);
  }

  void submitAnswer(String selected, String correctAnswer) {
    if (selected == correctAnswer) {
      quizStatus = QuizStatus.correct;
    } else {
      quizStatus = QuizStatus.wrongAnswer;
    }
    notifyListeners();
  }
  void resetToStory() {
    _flutterTts.stop(); // ← add this
    quizStatus = QuizStatus.hidden;
    ttsStatus = TtsStatus.idle;
    notifyListeners();
  }
  void resetWrongAnswerFlag() {
    // Used after the shake animation finishes, so the next tap
    // can register as "wrong" again if needed.
    if (quizStatus == QuizStatus.wrongAnswer) {
      quizStatus = QuizStatus.visible;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }
}