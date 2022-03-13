// ignore_for_file: avoid_print

import 'dart:async';

//Packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Services
import '../services/database_service.dart';

//Providers
import '../providers/authentication_provider.dart';

//Models
import '../models/chat.dart';
import '../models/chat_message.dart';
import '../models/chat_user.dart';

class ChatsPageProvider extends ChangeNotifier {
  final AuthenticationProvider _auth;

  late DatabaseService _db;

  List<Chat>? chats;

  late StreamSubscription _chatsStream;

  ChatsPageProvider(this._auth) {
    _db = GetIt.instance.get<DatabaseService>();
    getChats();
  }

  @override
  void dispose() {
    _chatsStream.cancel();
    super.dispose();
  }

  void getChats() async {
    try {

    } catch (e) {
      print("Error getting chats.");
      print(e);
    }
  }
}
