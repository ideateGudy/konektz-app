
import 'package:konektz/features/conversation/domain/repositories/conversations_repository.dart';

class DeleteConversationUseCase {
  final ConversationsRepository repository;

  DeleteConversationUseCase({ required this.repository});

  Future<void> call(String conversationId) {
    return repository.deleteConversation(conversationId);
  }
}