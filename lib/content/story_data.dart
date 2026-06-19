import '../models/quiz_question.dart';

// This file is the single source of truth for the story + quiz.
// To change the story or quiz later, ONLY edit this file —
// nothing else in the app needs to change.

const String storyText =
    "Once upon a time, a clever little robot named Pip lost his "
    "shiny blue gear in the Whispering Woods.";

// This mimics exactly what would arrive from a real backend as JSON.
final Map<String, dynamic> quizJson = {
  "question": "What color was Pip the Robot's lost gear?",
  "options": ["Red", "Green", "Blue", "Yellow"],
  "answer": "Blue",
};

final QuizQuestion quizQuestion = QuizQuestion.fromJson(quizJson);