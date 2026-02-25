import 'package:konektz/features/conversation/domain/entities/message_entity.dart';
import 'package:konektz/features/conversation/domain/repositories/conversations_repository.dart';

class FetchMessagesUseCase {
  final ConversationsRepository repository;

  FetchMessagesUseCase({ required this.repository});

  Future<List<MessageEntity>> call(String conversationId) {
    return repository.fetchMessages(conversationId);
  }
}