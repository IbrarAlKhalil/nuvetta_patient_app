import 'package:nuveta_patient_app/features/messages/data/models/message_model.dart';


abstract class MessageRepository {
  Future<List<ChatModel>> getChats();
  Future<ChatModel> getChatById(String chatId);
  Future<void> sendMessage({
    required String chatId,
    required String message,
  });
  Future<void> markAsRead(String chatId);
}
