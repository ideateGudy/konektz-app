class ConversationEntity {
  final String id;
  final String participantId;
  final String participantName;
  final String lastMessage;
  final DateTime lastMessageTime;

  ConversationEntity({
    required this.id,
    required this.participantId,
    required this.participantName,
    required this.lastMessage,
    required this.lastMessageTime,
  });
}