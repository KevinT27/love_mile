//Packages
// ignore_for_file: avoid_print, constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Models
import '../models/chat_message.dart';

const String USER_COLLECTION = "Users";
const String POOL_COLLECTION = "Pool";
const String CHAT_COLLECTION = "Chats";
const String MESSAGES_COLLECTION = "messages";

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseService();

  Future<void> createUser(String _uid, String _email, String _name,
      String _gender, String avatar) async {
    try {
      await _db.collection(USER_COLLECTION).doc(_uid).set(
        {
          "email": _email,
          "avatar": avatar,
          "last_active": DateTime.now().toUtc(),
          "name": _name,
          "searchingYN": false,
          "gender": _gender,
          "lng": 0.00,
          "lat": 0.00
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentSnapshot> getUser(String _uid) async {
    return _db.collection(USER_COLLECTION).doc(_uid).get();
  }

  Future<QuerySnapshot> getUsers({String? name}) {
    Query _query = _db.collection(USER_COLLECTION);
    if (name != null) {
      _query = _query
          .where("name", isGreaterThanOrEqualTo: name)
          .where("name", isLessThanOrEqualTo: name + "z");
    }
    return _query.get();
  }

  Stream<QuerySnapshot> getChatsForUser(String _uid) {
    return _db
        .collection(CHAT_COLLECTION)
        .where('members', arrayContains: _uid)
        .snapshots();
  }

  Future<QuerySnapshot> getLastMessageForChat(String _chatID) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(_chatID)
        .collection(MESSAGES_COLLECTION)
        .orderBy("sent_time", descending: true)
        .limit(1)
        .get();
  }

  Stream<QuerySnapshot> streamMessagesForChat(String _chatID) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(_chatID)
        .collection(MESSAGES_COLLECTION)
        .orderBy("sent_time", descending: false)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamChat(String _chatID) {
    return _db.collection(CHAT_COLLECTION).doc(_chatID).snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getChat(String _chatId) {
    return _db.collection(CHAT_COLLECTION).doc(_chatId).get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUserDoc(String _uid) {
    return _db.collection(USER_COLLECTION).doc(_uid).snapshots();
  }

  Future<void> addMessageToChat(String _chatID, ChatMessage _message) async {
    try {
      await _db
          .collection(CHAT_COLLECTION)
          .doc(_chatID)
          .collection(MESSAGES_COLLECTION)
          .add(
            _message.toJson(),
          );
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateChatData(
      String _chatID, Map<String, dynamic> _data) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(_chatID).update(_data);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUserLastSeenTime(String _uid) async {
    try {
      await _db.collection(USER_COLLECTION).doc(_uid).update(
        {
          "last_active": DateTime.now().toUtc(),
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteChat(String _chatID) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(_chatID).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentReference?> createChat(Map<String, dynamic> _data) async {
    try {
      DocumentReference _chat =
          await _db.collection(CHAT_COLLECTION).add(_data);
      return _chat;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<DocumentReference?> makeUserSearchable(
      String uid, Map<String, dynamic> _geoData) async {
    try {
      await _db
          .collection(USER_COLLECTION)
          .doc(uid)
          .update({..._geoData, "searchingYN": true});
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<void> makeUserNotSearchable(String uid) async {
    try {
      await _db
          .collection(USER_COLLECTION)
          .doc(uid)
          .update({"searchingYN": false});
    } catch (e) {
      print(e);
    }
  }

  Future<void> deactivateUserSearching(String uid) async {
    try {



      await _db
          .collection(USER_COLLECTION)
          .doc(uid)
          .update({"searchingYN": false, "chatID": null});
    } catch (e) {
      print(e);
    }
  }

  Future<void> closeChat(String uid) async {
    try {



      await _db
          .collection(CHAT_COLLECTION)
          .doc(uid)
          .update({"closed": true});
    } catch (e) {
      print(e);
    }
  }
}
