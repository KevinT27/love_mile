class ChatUser {
  final String uid;
  final String name;
  final String email;
  final String avatar;
  final String gender;
  late DateTime lastActive;

  ChatUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.avatar,
    required this.gender,
    required this.lastActive,
  });

  factory ChatUser.fromJSON(Map<String, dynamic> _json) {

    return ChatUser(
      uid: _json["uid"] ?? _json["id"],
      name: _json["name"],
      email: _json["email"],
      avatar: _json["avatar"],
      gender: _json["gender"],
      lastActive: DateTime.fromMicrosecondsSinceEpoch(
          _json["last_active"].microsecondsSinceEpoch),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "name": name,
      "last_active": lastActive,
      "avatar": avatar,
    };
  }

  String lastDayActive() {
    return "${lastActive.month}/${lastActive.day}/${lastActive.year}/";
  }

  bool wasRecentlyActive() {
    return DateTime.now().difference(lastActive).inHours < 2;
  }
}
