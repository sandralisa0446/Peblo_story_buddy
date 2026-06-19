import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../state/story_state.dart';
import '../content/story_data.dart';
import '../widgets/quiz_widget.dart';
import '../widgets/video_background.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storyState = context.watch<StoryState>();
    final showQuiz = storyState.quizStatus != QuizStatus.hidden;
    final backgroundAsset = showQuiz
        ? 'assets/videos/quiz_bg.mp4'
        : 'assets/videos/story_bg.mp4';

    return Scaffold(
      body: VideoBackground(
        assetPath: backgroundAsset,
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      child: showQuiz
                          ? QuizWidget(confettiController: _confettiController)
                          : _buildStoryContent(context, storyState),
                    ),
                  ),
                  const Spacer(flex: 5),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: true,
                numberOfParticles: 40,
                maxBlastForce: 30,
                minBlastForce: 15,
                gravity: 0.3,
                emissionFrequency: 0.05,
                minimumSize: const Size(8, 8),
                maximumSize: const Size(16, 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryContent(BuildContext context, StoryState storyState) {
    return Column(
      children: [
        _buildStoryCard(),
        const SizedBox(height: 20),
        _buildReadButton(context, storyState),
        const SizedBox(height: 12),
        if (storyState.ttsStatus == TtsStatus.failed)
          _buildErrorMessage(context, storyState),
      ],
    );
  }

  Widget _buildStoryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.6),
          width: 1.5,
        ),
      ),
      child: Text(
        storyText,
        style: const TextStyle(
          fontSize: 20,
          height: 1.4,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildReadButton(BuildContext context, StoryState storyState) {
    final isLoading = storyState.ttsStatus == TtsStatus.loading;
    final isPlaying = storyState.ttsStatus == TtsStatus.playing;

    return ElevatedButton(
      onPressed: (isLoading || isPlaying)
          ? null
          : () => storyState.readStory(storyText),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF6F61),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 4,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
          else
            const Icon(Icons.volume_up_rounded),
          const SizedBox(width: 10),
          Text(
            isLoading
                ? "Pip is thinking..."
                : isPlaying
                ? "Reading..."
                : "Read Me a Story",
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(BuildContext context, StoryState storyState) {
    return Column(
      children: [
        const Text(
          "Oops! Couldn't read the story.",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => storyState.retryReading(storyText),
          child: const Text(
            "Try again",
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}