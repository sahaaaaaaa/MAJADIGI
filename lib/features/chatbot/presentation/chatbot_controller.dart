import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:majadigi/features/chatbot/data/chatbot_repository.dart';
import 'package:majadigi/features/chatbot/data/chatbot_service.dart';
import 'package:majadigi/features/chatbot/data/models/chatbot_history.dart';
import 'package:majadigi/features/chatbot/presentation/chatbot_state.dart';

final chatbotServiceProvider = Provider<ChatbotService>((ref) {
  final service = ChatbotService();
  ref.onDispose(service.dispose);
  return service;
});

final chatbotRepositoryProvider = Provider<ChatbotRepository>((ref) {
  return ChatbotRepository(ref.read(chatbotServiceProvider));
});

final chatbotControllerProvider =
    StateNotifierProvider<ChatbotController, ChatbotState>((ref) {
      return ChatbotController(ref.read(chatbotRepositoryProvider));
    });

class ChatbotController extends StateNotifier<ChatbotState> {
  ChatbotController(this._repository) : super(const ChatbotState());

  final ChatbotRepository _repository;

  Future<void> loadChatHistory(String token) async {
    state = state.copyWith(isLoadingHistory: true, errorMessage: null);

    try {
      final history = await _repository.fetchChatHistory(token: token);
      final reversedMessage = history.messages.reversed.toList();
      state = state.copyWith(
        isLoadingHistory: false,
        messages: reversedMessage,
        conversationId: history.conversationId,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingHistory: false,
        errorMessage: 'Gagal memuat riwayat pesan: $e',
      );
    }
  }

  Future<void> sendNewMessages({
    required String text,
    required String token,
  }) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch,
      userId: 'local_user',
      conversationId: state.conversationId ?? '',
      role: 'user',
      content: text,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      messages: [userMessage, ...state.messages],
      isSendingMessage: true,
      errorMessage: null,
    );

    try {
      final response = await _repository.sendChatMessages(
        message: text,
        conversationId: state.conversationId,
        token: token,
      );

      final botMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch + 1,
        userId: 'assistant',
        conversationId: response.conversationId,
        role: 'assistant',
        content: response.answer,
        createdAt: DateTime.now(),
      );

      state = state.copyWith(
        isSendingMessage: false,
        messages: [botMessage, ...state.messages],
        conversationId: response.conversationId,
      );
    } catch (e) {
      state = state.copyWith(
        isSendingMessage: false,
        errorMessage: 'Gagal mengirim pesan. Silahkan coba lagi',
      );
    }
  }
}
