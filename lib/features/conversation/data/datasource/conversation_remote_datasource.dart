import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:konektz/features/conversation/data/models/conversation_model.dart';
import 'package:konektz/features/conversation/data/models/message_model.dart';

abstract class ConversationRemoteDataSource {
  Future<List<ConversationModel>> fetchConversations();

  /// Returns the ID of the created (or already-existing) conversation.
  Future<String> createConversation(String participantId);
  Future<List<MessageModel>> fetchMessages(String conversationId);
  Future<MessageModel> sendMessage(String conversationId, String content);
  Future<void> restoreConversation(String conversationId);
  Future<void> deleteConversation(String conversationId);
}

class ConversationRemoteDataSourceImpl implements ConversationRemoteDataSource {
  final String baseUrl;
  final http.Client _client;

  ConversationRemoteDataSourceImpl({
    this.baseUrl = 'http://192.168.1.66:5000/conversations',
    http.Client? client,
  }) : _client = client ?? http.Client();

  @override
  Future<String> createConversation(String participantId) async {
    try {
      final response = await _client.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'participantId': participantId}),
      );
      // 201 = newly created, 200 = conversation already exists
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return (data['conversation'] as Map<String, dynamic>)['id'] as String;
      } else {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(body['message'] ?? 'Failed to create conversation');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid server response');
    } on http.ClientException catch (e) {
      throw Exception('Failed to create conversation: ${e.message}');
    }
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    try {
      final response = await _client.delete(
        Uri.parse('$baseUrl/$conversationId'),
      );
      if (response.statusCode != 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(body['message'] ?? 'Failed to delete conversation');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid server response');
    } on http.ClientException catch (e) {
      throw Exception('Failed to delete conversation: ${e.message}');
    }
  }

  @override
  Future<List<ConversationModel>> fetchConversations() async {
    try {
      final response = await _client.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final list = data['conversations'] as List<dynamic>;
        return list
            .map((e) => ConversationModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(body['message'] ?? 'Failed to fetch conversations');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid server response');
    } on http.ClientException catch (e) {
      throw Exception('Failed to fetch conversations: ${e.message}');
    }
  }

  @override
  Future<List<MessageModel>> fetchMessages(String conversationId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/$conversationId/messages'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final list = data['messages'] as List<dynamic>;
        return list
            .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(body['message'] ?? 'Failed to fetch messages');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid server response');
    } on http.ClientException catch (e) {
      throw Exception('Failed to fetch messages: ${e.message}');
    }
  }

  @override
  Future<void> restoreConversation(String conversationId) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/$conversationId/restore'),
      );
      if (response.statusCode != 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(body['message'] ?? 'Failed to restore conversation');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid server response');
    } on http.ClientException catch (e) {
      throw Exception('Failed to restore conversation: ${e.message}');
    }
  }

  @override
  Future<MessageModel> sendMessage(
    String conversationId,
    String content,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/$conversationId/messages'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'content': content}),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return MessageModel.fromJson(data['message'] as Map<String, dynamic>);
      } else {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(body['message'] ?? 'Failed to send message');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid server response');
    } on http.ClientException catch (e) {
      throw Exception('Failed to send message: ${e.message}');
    }
  }
}
