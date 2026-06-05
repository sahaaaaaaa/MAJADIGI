import 'package:majadigi/features/chatbot/data/models/chatbot_history.dart';

class ChatbotState {
  final List<ChatMessage> messages;
  final bool isLoadingHistory;
  final bool isSendingMessage;
  final String? conversationId;
  final String? errorMessage;

  const ChatbotState({
    this.messages = const [],
    this.isLoadingHistory = false,
    this.isSendingMessage = false,
    this.conversationId,
    this.errorMessage,
  });

  ChatbotState copyWith({
    List<ChatMessage>? messages,
    bool? isLoadingHistory,
    bool? isSendingMessage,
    String? conversationId,
    String? errorMessage,
  }) {
    return ChatbotState(
      messages: messages ?? this.messages,
      isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
      conversationId: conversationId ?? this.conversationId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
