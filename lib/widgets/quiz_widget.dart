import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../state/story_state.dart';
import '../content/story_data.dart';

class QuizWidget extends StatefulWidget {
  final ConfettiController confettiController;

  const QuizWidget({super.key, required this.confettiController});

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  // A separate FlutterTts instance from the story one in StoryState,
  // so a quick "uh oh" doesn't interfere with story narration status.
  // Initialised lazily in initState so it's only created when the quiz
  // is actually shown — avoiding expensive TTS engine startup on load.
  late FlutterTts _feedbackTts;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _feedbackTts = FlutterTts();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _feedbackTts.stop();
    super.dispose();
  }

  void _handleOptionTap(BuildContext context, String option) {
    final storyState = context.read<StoryState>();
    final isCorrect = option == quizQuestion.answer;

    storyState.submitAnswer(option, quizQuestion.answer);

    if (isCorrect) {
      widget.confettiController.play();
      HapticFeedback.mediumImpact();
      _feedbackTts.stop();
      _feedbackTts.speak("Yay, you got it right!");
    } else {
      HapticFeedback.heavyImpact();
      _feedbackTts.stop();
      _feedbackTts.speak("Uh oh! Wrong answer.");
      _shakeController.forward(from: 0).then((_) {
        storyState.resetWrongAnswerFlag();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final storyState = context.watch<StoryState>();
    final quizStatus = storyState.quizStatus;

    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        final offset =
        (quizStatus == QuizStatus.wrongAnswer || _shakeController.value > 0)
            ? _shakeOffset(_shakeController.value)
            : 0.0;
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: _buildQuizCard(context, quizStatus),
    );
  }

  double _shakeOffset(double t) {
    return 12 * (1 - t) * (t < 0.5 ? 1 : -1);
  }

  Widget _buildQuizCard(BuildContext context, QuizStatus quizStatus) {
    if (quizStatus == QuizStatus.correct) {
      return _buildSuccessCard();
    }

    return Center(
      child: SizedBox(
        width: 220,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: quizStatus == QuizStatus.wrongAnswer
                  ? Colors.redAccent
                  : Colors.white.withValues(alpha: 0.6),
              width: quizStatus == QuizStatus.wrongAnswer ? 3 : 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => context.read<StoryState>().resetToStory(),
                  child: const Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
              Text(
                quizQuestion.question,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Divider(color: Colors.white.withValues(alpha: 0.4), height: 1),
              const SizedBox(height: 16),
              ...quizQuestion.options.map((option) {
                return GestureDetector(
                  onTap: () => _handleOptionTap(context, option),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      option,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }),
              if (quizStatus == QuizStatus.wrongAnswer)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    "Not quite! Try again 💪",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessCard() {
    return Builder(
      builder: (context) {
        return Center(
          child: SizedBox(
            width: 220,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.6),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("🎉", style: TextStyle(fontSize: 28)),
                  const SizedBox(height: 8),
                  const Text(
                    "Yay! You got it right!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => context.read<StoryState>().resetToStory(),
                    child: const Text(
                      "Back to story",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}