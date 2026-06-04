import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:majadigi/features/chatbot/presentation/chatbot_controller.dart';
import 'package:majadigi/features/chatbot/presentation/widgets/chat_bubble.dart';
import 'package:majadigi/features/chatbot/presentation/widgets/chat_input_bar.dart';

class ChatbotScreen extends ConsumerStatefulWidget {
  final String token;

  const ChatbotScreen({super.key, required this.token});

  @override
  ConsumerState<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends ConsumerState<ChatbotScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(chatbotControllerProvider.notifier)
          .loadChatHistory(widget.token);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSendMessage() {
    final text = _textController.text;
    if (text.trim().isNotEmpty) {
      ref
          .read(chatbotControllerProvider.notifier)
          .sendNewMessages(text: text, token: widget.token);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatbotState = ref.watch(chatbotControllerProvider);
    if (chatbotState.isSendingMessage) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/latar_belakang.png',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Maja.ai',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: chatbotState.isLoadingHistory
                              ? const Center(child: CircularProgressIndicator())
                              : ListView.builder(
                                  controller: _scrollController,
                                  padding: const EdgeInsets.all(16),
                                  reverse: true,
                                  itemCount: chatbotState.messages.length,
                                  itemBuilder: (context, index) {
                                    final message =
                                        chatbotState.messages[index];
                                    return ChatBubble(message: message);
                                  },
                                ),
                        ),
                        if (chatbotState.isSendingMessage)
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Maja sedang mengetik...',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ChatInputBar(
                          controller: _textController,
                          isSending: chatbotState.isSendingMessage,
                          onSend: _handleSendMessage,
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
    );
  }
}
