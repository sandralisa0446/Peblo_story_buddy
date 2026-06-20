import '../models/quiz_question.dart';

const String storyText =
    "Once upon a time, a clever little robot named Pip lost his "
    "shiny blue gear in the Whispering Woods.";

final Map<String, dynamic> quizJson = {
  "question": "What color was Pip the Robot's lost gear?",
  "options": ["Red", "Green", "Blue", "Yellow"],
  "answer": "Blue",
};

final QuizQuestion quizQuestion = QuizQuestion.fromJson(quizJson);
