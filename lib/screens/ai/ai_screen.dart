import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/user.dart';
import '../../services/ai_service.dart';
import '../../widgets/app_navbar.dart';

class AIScreen extends StatefulWidget {
  final AppUser currentUser;
  final VoidCallback? onCharts;
  final VoidCallback? onAI;
  final VoidCallback? onAccount;
  final VoidCallback? onBrandTap;

  const AIScreen({
    super.key,
    required this.currentUser,
    this.onCharts,
    this.onAI,
    this.onAccount,
    this.onBrandTap,
  });

  @override
  State<AIScreen> createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> {
  final _searchController = TextEditingController();
  final _messageController = TextEditingController();
  final _aiService = AIService();
  
  final List<_Message> _messages = [
    _Message(
      text: 'Hello! I\'m your AI book assistant. I can help you find book recommendations, answer questions about books, or discuss literature. What would you like to know?',
      isUser: false,
    )
  ];

  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_Message(text: text, isUser: true));
      _messageController.clear();
      _isLoading = true;
    });

    // Get AI response
    final response = await _aiService.getResponse(text);
    
    if (mounted) {
      setState(() {
        _messages.add(_Message(text: response, isUser: false));
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3EE),
      body: Column(
        children: [
          AppNavbar(
            searchController: _searchController,
            currentUser: widget.currentUser,
            onCharts: widget.onCharts,
            onAI: widget.onAI,
            onAccount: widget.onAccount,
            onBrandTap: widget.onBrandTap,
          ),
          Expanded(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'AI Book Assistant',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.close,
                          size: 28,
                          color: AppTheme.black,
                        ),
                      ),
                    ],
                  ),
                ),
                // Messages
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _MessageBubble(
                        message: message.text,
                        isUser: message.isUser,
                      );
                    },
                  ),
                ),
                if (_isLoading)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'AI is thinking...',
                          style: TextStyle(
                            color: AppTheme.textGrey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                // Input
                Container(
                  color: AppTheme.white,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          enabled: !_isLoading,
                          style: const TextStyle(
                            color: AppTheme.black,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Ask me anything about books...',
                            hintStyle: const TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFDDDDDD),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFDDDDDD),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppTheme.black,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: _isLoading ? null : _sendMessage,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: _isLoading ? Colors.grey : AppTheme.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.send, color: AppTheme.white, size: 18),
                              SizedBox(width: 6),
                              Text(
                                'Send',
                                style: TextStyle(
                                  color: AppTheme.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const _MessageBubble({
    required this.message,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isUser
                  ? AppTheme.black
                  : const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: isUser ? AppTheme.white : AppTheme.black,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Message {
  final String text;
  final bool isUser;

  _Message({
    required this.text,
    required this.isUser,
  });
}
