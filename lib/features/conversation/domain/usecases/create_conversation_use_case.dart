import 'package:konektz/features/conversation/domain/repositories/conversations_repository.dart';

class CreateConversationUseCase {
  final ConversationsRepository repository;

  CreateConversationUseCase({required this.repository});

  /// Returns the ID of the created (or already-existing) conversation.
  Future<String> call(String participantId) {
    return repository.createConversation(participantId);
  }
}
