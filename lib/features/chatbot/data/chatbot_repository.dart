import 'package:majadigi/features/chatbot/data/chatbot_service.dart';
import 'package:majadigi/features/chatbot/data/models/chatbot_history.dart';
import 'package:majadigi/features/chatbot/data/models/chatbot_response.dart';

class ChatbotRepository {
  final ChatbotService _service;

  ChatbotRepository(this._service);

  Future<ChatbotResponse> sendChatMessages({
    required String message,
    String? conversationId,
    required String token,
  }) async {
    try {
      return await _service.sendMessage(
        message: message,
        conversationId: conversationId,
        token: token,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Mengambil data riwayat pesan dari service
  Future<ChatbotHistory> fetchChatHistory({required String token}) async {
    try {
      // Panggil fungsi service untuk get data dari API
      return await _service.getChatHistory(token: token);
    } catch (e) {
      // Anda bisa menyelipkan logika fallback di sini,
      // misal: jika offline, ambil dari lokal database/cache.
      rethrow;
    }
  }
}
