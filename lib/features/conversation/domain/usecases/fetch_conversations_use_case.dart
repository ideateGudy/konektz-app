import 'package:konektz/features/conversation/domain/entities/conversation_entities.dart';
import 'package:konektz/features/conversation/domain/repositories/conversations_repository.dart';

class FetchConversationsUseCase {
  final ConversationsRepository repository;

  FetchConversationsUseCase({ required this.repository});

  Future<List<ConversationEntity>> call() {
    return repository.fetchConversations();
  }
}