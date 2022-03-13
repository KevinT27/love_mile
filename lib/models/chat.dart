import '../models/chat_user.dart';
import '../models/chat_message.dart';

class Chat {
  final String uid;
  final ChatUser user1;
  final ChatUser user2;
  List<ChatMessage> messages;

  Chat({
    required this.uid,
    required this.user1,
    required this.user2,
    required this.messages
  })
