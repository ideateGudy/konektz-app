import 'package:konektz/features/conversation/domain/entities/conversation_entities.dart';

class ConversationModel extends ConversationEntity {
  ConversationModel({
    required super.id,
    required super.participantId,
    required super.participantName,
    required super.lastMessage,
    required super.lastMessageTime,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['conversationId'],
      participantId: json['participantId'],
      participantName: json['participantName'],
      lastMessage: json['lastMessage'],
      lastMessageTime: DateTime.parse(json['lastMessageTime']),
    );
  }
}
