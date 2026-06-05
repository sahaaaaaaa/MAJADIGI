class ChatbotResponse {
  final String answer;
  final String conversationId;

  const ChatbotResponse({required this.answer, required this.conversationId});

  factory ChatbotResponse.fromJson(Map<String, dynamic> json) {
    return ChatbotResponse(
      answer: json['answer']?.toString() ?? '',
      conversationId: json['conversation_id']?.toString() ?? '',
    );
  }
}
