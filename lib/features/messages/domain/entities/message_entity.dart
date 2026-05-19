class ChatEntity {
  final String id;
  final String senderName;
  final String senderRole;
  final String senderImage;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final List<MessageEntity> messages;

  const ChatEntity({
    required this.id,
    required this.senderName,
    required this.senderRole,
    required this.senderImage,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.messages,
  });
}

class MessageEntity {
  final String id;
  final String sender;
  final String message;
  final DateTime timestamp;
  final bool isUser;

  const MessageEntity({
    required this.id,
    required this.sender,
    required this.message,
    required this.timestamp,
    required this.isUser,
  });
}
