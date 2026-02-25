import 'package:konektz/features/conversation/domain/repositories/conversations_repository.dart';

class SendMessageUseCase {
  final ConversationsRepository repository;

  SendMessageUseCase({ required this.repository});

  Future<void> call(String conversationId, String content) {
    return repository.sendMessage(conversationId, content);
  }
}
