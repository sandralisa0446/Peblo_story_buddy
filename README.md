Peblo Flutter / Swift Developer Intern Challenge: "The AI Story
Buddy & Quiz Component"
A SHORT README
1. Which framework did you choose and why?
Answer:
• Framework: Flutter
• Single codebase for Android and iOS.
• Fast development with Hot Reload.
• Rich ecosystem for TTS, animations, and state management.
• Consistent UI and performance across devices.
2. How did you manage the transition state between audio ending and quiz appearing?
Answer:
• Used Provider + ChangeNotifier for state management.
• Managed narration and quiz states separately.
• Used Flutter TTS setCompletionHandler() to detect narration completion.
• Automatically revealed the quiz when audio finished.
• Used event-based state updates instead of timers for reliability.
3. How did you build the quiz to be data-driven?
Answer:
• Created a reusable QuizQuestion model.
• Loaded quiz content from JSON using fromJson().
• Dynamically generated answer options from the JSON data.
• No hardcoded questions or answer buttons.
• Supports different questions and varying option counts without code changes.
4. What was your caching approach?
Answer:
• Used Flutter TTS for local on-device speech generation.
• No remote audio downloads; therefore no audio caching required.
• Story and quiz data are stored locally.
• For remote audio, files would be cached locally using path_provider and reused on future
playback.
5. How did you handle audio loading and failure states?
Answer:
• Implemented audio states:
o Loading
o Playing
o Completed
o Failed
• Displayed loading feedback before narration starts.
• Used TTS error handlers and try-catch blocks.
• Showed user-friendly error messages.
• Added retry functionality.
• Prevented duplicate playback requests during narration.
6. How did you profile and optimize performance?
Answer:
• Used Flutter DevTools and Performance Overlay.
• Measured:
o Frame rendering time
o Animation smoothness
o Widget rebuild frequency
• Optimizations:
o Reduced unnecessary widget rebuilds.
o Reused controllers where possible.
o Lazy-loaded TTS resources.
• Result:
o Smooth transitions and animations.
o Stable performance within the 16.6ms frame budget.
o No noticeable frame drops on mid-range Android devices.
• Frame timing screenshots attached separately.
7. How did you optimize for mid-range Android devices?
Answer:
• Used lightweight state management with Provider.
• Stored data locally to avoid network overhead.
• Lazy initialization of TTS components.
• Reused media controllers.
• Properly disposed controllers and resources.
• Minimized widget rebuilds.
• Kept animations lightweight and efficient.
8. AI Usage & Judgment
8.1 Where did you use AI assistance?
Answer:
• Architecture planning.
• State management guidance.
• Flutter best-practice recommendations.
• Performance optimization suggestions.
• Documentation refinement.
8.2 One AI suggestion you rejected or changed?
Answer:
• AI suggested using a timer to reveal the quiz after narration.
• Rejected because narration duration may vary across devices.
• Used TTS completion callbacks instead for accurate synchronization.
8.3 What did you try that didn't work, and how did you resolve it?
Answer:
• Initially used a single TTS instance for narration and quiz feedback.
• This caused playback and state conflicts.
• Resolved by separating narration and feedback responsibilities.
• Improved reliability and state management.
