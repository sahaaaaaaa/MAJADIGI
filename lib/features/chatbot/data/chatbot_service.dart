import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:majadigi/features/chatbot/data/models/chatbot_history.dart';
import 'package:majadigi/features/chatbot/data/models/chatbot_response.dart';
import 'package:majadigi/core/services/api_config.dart';

class ChatbotService {
  ChatbotService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<ChatbotResponse> sendMessage({
    required String message,
    String? conversationId,
    required String token,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/chatbot');
      final Map<String, dynamic> bodyData = {'message': message};
      bodyData['user_id'] = '';

      final response = await _client.post(
        url,
        headers: _headers(token),
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedData = _decode(response.body);
        return ChatbotResponse.fromJson(decodedData);
      } else {
        throw Exception('Gagal mengirim pesan. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('tidak dapat terhubung ke chatbot service');
    }
  }

  Future<ChatbotHistory> getChatHistory({required String token}) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/chatbot/history');
      final response = await _client.get(url, headers: _headers(token));
      if (response.statusCode == 200) {
        final decodedData = _decode(response.body);
        return ChatbotHistory.fromJson(decodedData);
      } else {
        throw Exception('Gagal memuat riwayat. Status: ${response.statusCode}');
      }
    } catch (_) {
      throw Exception('tidak dapat terhubung dengan chatbot service');
    }
  }

  Map<String, dynamic> _decode(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {}
    return {};
  }

  Map<String, String> _headers(String token) {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': token, // Langsung pasang token yang valid dari parameter
    };
  }

  void dispose() {
    _client.close();
  }
}
