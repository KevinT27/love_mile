
import '../models/chat_user.dart';
import '../models/chat_message.dart';

class Chat {
  final String id;
  List<ChatUser> members;
  List<ChatMessage> messages;

  Chat({required this.id, required this.members, required this.messages});

  factory Chat.fromJSON(Map<String, dynamic> _json) {


    List<ChatUser> members = List<ChatUser>.from(
        _json["members"].map((jsonMember) => ChatUser.fromJSON(jsonMember)));

    return Chat(id: _json["id"], members: members, messages: []);
  }
}
