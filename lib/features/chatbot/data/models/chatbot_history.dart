class ChatbotHistory {
  final String conversationId;
  final List<ChatMessage> messages;

  const ChatbotHistory({required this.conversationId, required this.messages});

  factory ChatbotHistory.fromJson(Map<String, dynamic> json) {
    final messagesJson = json['messages'] as List?;
    final messagesList = messagesJson != null
        ? messagesJson
              .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
              .toList()
        : <ChatMessage>[];
    return ChatbotHistory(
      conversationId: json['conversation_id']?.toString() ?? '',
      messages: messagesList,
    );
  }
}

class ChatMessage {
  final int id;
  final String userId;
  final String conversationId;
  final String role;
  final String content;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ChatMessage({
    required this.id,
    required this.userId,
    required this.conversationId,
    required this.role,
    required this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as int? ?? 0,
      userId: json['user_id']?.toString() ?? '',
      conversationId: json['conversation_id']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }
}
