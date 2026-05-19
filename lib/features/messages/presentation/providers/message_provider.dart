import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nuveta_patient_app/features/messages/data/repositories/message_repository_impl.dart';
import 'package:nuveta_patient_app/features/messages/domain/repositories/message_repository.dart';


final messageRepositoryProvider = Provider<MessageRepository>((ref) {
  return MessageRepositoryImpl();
});

final chatsProvider = FutureProvider((ref) async {
  final repository = ref.watch(messageRepositoryProvider);
  return repository.getChats();
});

final chatDetailProvider = FutureProvider.family<dynamic, String>((ref, chatId) async {
  final repository = ref.watch(messageRepositoryProvider);
  return repository.getChatById(chatId);
});
