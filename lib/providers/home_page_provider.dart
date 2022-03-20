import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:love_mile/models/chat_user.dart';
import 'package:love_mile/pages/chat_page.dart';
import 'package:love_mile/providers/authentication_provider.dart';
import 'package:love_mile/services/database_service.dart';
import 'package:love_mile/services/location_service.dart';
import 'package:love_mile/services/network_service.dart';

import '../models/chat.dart';
import '../services/navigation_service.dart';

class HomePageProvider extends ChangeNotifier {
  final AuthenticationProvider _auth;

  late LocationService _location;
  late DatabaseService _database;
  late NetworkService _network;
  late NavigationService _navigation;

  late StreamSubscription _userStream;

  String foundChat = "";
  bool isLoading = false;

  HomePageProvider(this._auth) {
    _location = GetIt.instance.get<LocationService>();
    _database = GetIt.instance.get<DatabaseService>();
    _network = GetIt.instance.get<NetworkService>();
    _navigation = GetIt.instance.get<NavigationService>();
    startUserSearching();
  }

  void startUserSearching() async {
    isLoading = true;
    notifyListeners();
    await setUserInSearchMode();
    listenToUserChanges();
  }

  void listenToUserChanges() {
    try {
      _userStream = _database.streamUserDoc(_auth.user.uid).listen(
        (_snapshot) async {
          Map<String, dynamic> _userData = _snapshot.data()!;

          if (_userData['chatID'] != null) {
            // chat foudn
            print('chat found');
            final chatID = _userData['chatID'];
            final _chatSnapshot = await _database.getChat(chatID);

            Map<String, dynamic> _chatData = _chatSnapshot.data()!;

            _chatData["id"] = chatID;

            Chat _chat = Chat.fromJSON(_chatData);

            _navigation.navigateToPage(ChatPage(chat: _chat));
          }

          if (_userData['searchingYN'] == false) {
            isLoading = false;
            notifyListeners();
            return;
          }
        },
      );
    } catch (e) {
      print("Error getting messages.");
      print(e);
    }
  }

  Future<DocumentReference<Object?>?> setUserInSearchMode() async {
    // get current position
    final currentPosition = await _location.determinePosition();

    // set user is searching flag on database and send the location
    DocumentReference<Object?>? _doc =
        await _database.makeUserSearchable(_auth.user.uid, {
      "lng": currentPosition.longitude,
      "lat": currentPosition.latitude,
    });

    return _doc;
  }
}
