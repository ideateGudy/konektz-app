import 'package:konektz/features/conversation/data/datasource/conversation_remote_datasource.dart';
import 'package:konektz/features/conversation/domain/entities/conversation_entities.dart';
import 'package:konektz/features/conversation/domain/entities/message_entity.dart';
import 'package:konektz/features/conversation/domain/repositories/conversations_repository.dart';

class ConversationRepositoryImpl implements ConversationsRepository {
  final ConversationRemoteDataSource remoteDataSource;

  ConversationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> createConversation(String participantId) {
    return remoteDataSource.createConversation(participantId);
  }

  @override
  Future<void> deleteConversation(String conversationId) {
    return remoteDataSource.deleteConversation(conversationId);
  }

  @override
  Future<List<ConversationEntity>> fetchConversations() {
    return remoteDataSource.fetchConversations();
  }

  @override
  Future<List<MessageEntity>> fetchMessages(String conversationId) {
    return remoteDataSource.fetchMessages(conversationId);
  }

  @override
  Future<void> restoreConversation(String conversationId) {
    return remoteDataSource.restoreConversation(conversationId);
  }

  @override
  Future<MessageEntity> sendMessage(String conversationId, String content) {
    return remoteDataSource.sendMessage(conversationId, content);
  }
}
