import '../../domain/entities/message_entity.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    required super.senderName,
    required super.senderRole,
    required super.senderImage,
    required super.lastMessage,
    required super.lastMessageTime,
    required super.unreadCount,
    required super.messages,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as String,
      senderName: json['senderName'] as String,
      senderRole: json['senderRole'] as String,
      senderImage: json['senderImage'] as String,
      lastMessage: json['lastMessage'] as String,
      lastMessageTime: DateTime.parse(json['lastMessageTime'] as String),
      unreadCount: json['unreadCount'] as int,
      messages: (json['messages'] as List)
          .map((m) => MessageModel.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.sender,
    required super.message,
    required super.timestamp,
    required super.isUser,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      sender: json['sender'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isUser: json['isUser'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sender': sender,
    'message': message,
    'timestamp': timestamp.toIso8601String(),
    'isUser': isUser,
  };
}
