import 'dart:math';

/// Abstract interface for AI responses - allows for easy swapping between mock and real implementations
abstract class AIProvider {
  Future<String> getResponse(String query);
}

/// Mock AI provider that returns random responses - easily swappable for real API later
class MockAIProvider implements AIProvider {
  static const List<String> _bookResponses = [
    'That\'s a great question! I\'d recommend starting with classics like "To Kill a Mockingbird" or "1984" if you\'re looking for thought-provoking literature.',
    'Fiction is wonderful because it allows us to explore different worlds and perspectives. What genre interests you most?',
    'Book recommendations often depend on your mood and preferences. Are you in the mood for mystery, romance, fantasy, or something else?',
    'Many literary classics have stood the test of time because they explore universal human themes. Would you like suggestions in a particular genre?',
    'Reading enriches our minds and expands our imagination. I\'d be happy to help you find your next great read!',
    'Different books speak to different people at different times in their lives. What kind of stories resonate with you?',
    'Authors craft intricate worlds and characters to draw us into their narratives. Have you found any authors you particularly enjoy?',
    'The beauty of literature is its diversity. There\'s something out there for every reader. What\'s your last favorite book?',
    'Book clubs are wonderful ways to discover new perspectives on literature. Do you participate in any?',
    'Non-fiction can be just as engaging as fiction when exploring topics you\'re passionate about. Any particular subjects interest you?',
    'The written word has the power to transport us, teach us, and transform us. What brings you to explore books?',
    'Series can be wonderful for getting deeply invested in characters and worlds. Are you a series reader?',
    'Poetry offers unique perspectives in just a few lines. Have you explored any contemporary poets?',
    'Graphic novels and visual storytelling are increasingly recognized as legitimate literary art forms. Have you read any?',
    'This is a mock AI response. In a real application, this would be connected to an actual AI service to provide personalized recommendations.',
  ];

  @override
  Future<String> getResponse(String query) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Return random response
    final random = Random();
    return _bookResponses[random.nextInt(_bookResponses.length)];
  }
}

/// Main AI Service - handles the abstraction between the app and the AI provider
class AIService {
  late final AIProvider _provider;

  AIService({AIProvider? provider}) {
    // Use injected provider or default to MockAIProvider
    _provider = provider ?? MockAIProvider();
  }

  /// Get AI response for a user query
  /// This method signature stays the same regardless of provider implementation
  Future<String> getResponse(String query) {
    return _provider.getResponse(query);
  }

  /// Easy method to swap providers for real API later
  void setProvider(AIProvider provider) {
    _provider = provider;
  }
}
