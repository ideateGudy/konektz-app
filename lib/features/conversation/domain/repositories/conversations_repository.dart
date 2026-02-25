import 'package:konektz/features/conversation/domain/entities/conversation_entities.dart';
import 'package:konektz/features/conversation/domain/entities/message_entity.dart';

abstract class ConversationsRepository {
  Future<List<ConversationEntity>> fetchConversations();

  /// Returns the ID of the created (or already-existing) conversation.
  Future<String> createConversation(String participantId);
  Future<List<MessageEntity>> fetchMessages(String conversationId);
  Future<MessageEntity> sendMessage(String conversationId, String content);
  Future<void> restoreConversation(String conversationId);
  Future<void> deleteConversation(String conversationId);
}
