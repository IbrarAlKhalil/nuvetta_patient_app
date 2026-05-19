import 'package:nuveta_patient_app/core/mock/mock_data.dart';
import '../../domain/repositories/message_repository.dart';
import '../models/message_model.dart';

class MessageRepositoryImpl implements MessageRepository {
  @override
  Future<List<ChatModel>> getChats() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final mockData = MockDataGenerator.generateMessages();
    return mockData.map((data) {
      final messages = (data['messages'] as List)
          .map((m) => MessageModel.fromJson(m as Map<String, dynamic>))
          .toList();
      return ChatModel(
        id: data['id'] as String,
        senderName: data['senderName'] as String,
        senderRole: data['senderRole'] as String,
        senderImage: data['senderImage'] as String,
        lastMessage: data['lastMessage'] as String,
        lastMessageTime: data['lastMessageTime'] as DateTime,
        unreadCount: data['unreadCount'] as int,
        messages: messages,
      );
    }).toList();
  }

  @override
  Future<ChatModel> getChatById(String chatId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final chats = await getChats();
    return chats.firstWhere((c) => c.id == chatId);
  }

  @override
  Future<void> sendMessage({
    required String chatId,
    required String message,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock successful send
  }

  @override
  Future<void> markAsRead(String chatId) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
