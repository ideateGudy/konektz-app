
import 'package:konektz/features/conversation/domain/repositories/conversations_repository.dart';

class RestoreConversationUseCase {
  final ConversationsRepository repository;

  RestoreConversationUseCase({ required this.repository});

  Future<void> call(String conversationId) {
    return repository.restoreConversation(conversationId);
  }
}