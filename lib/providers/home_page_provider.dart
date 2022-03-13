import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:love_mile/models/chat_user.dart';
import 'package:love_mile/providers/authentication_provider.dart';
import 'package:love_mile/services/database_service.dart';
import 'package:love_mile/services/location_service.dart';
import 'package:love_mile/services/network_service.dart';

class HomePageProvider extends ChangeNotifier {
  final AuthenticationProvider _auth;

  late LocationService _location;
  late DatabaseService _database;
  late NetworkService _network;

  String foundChat = "";
  bool isLoading = false;

  HomePageProvider(this._auth) {
    _location = GetIt.instance.get<LocationService>();
    _database = GetIt.instance.get<DatabaseService>();
    _network = GetIt.instance.get<NetworkService>();

    startUserSearching();
  }

  void startUserSearching() async {
    isLoading = true;
    notifyListeners();
    setUserInSearchMode().then((_) {
      checkIfFitUserFound();
    });
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

  void checkIfFitUserFound() async {
    isLoading = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 3), () async {
      try {
        for (int i = 0; i <= 10;) {
          // send http request if fitting user is available.
          final response = await _network.fetchData(
              'https://us-central1-love-mile.cloudfunctions.net/findUserToChat?uid=${_auth.user.uid}');

          // check if the the response is 200
          if (response.statusCode == 200) {
            // decode json body
            Map decodedBody = await jsonDecode(response.body);

            // if the body contains notfoundYN there is still no searching result for the user
            if (!decodedBody.containsKey("notfoundYN")) {
              // get chat body -> convert  user1 and user2 to User class
              print(decodedBody["user1"]["last_active"]);
              ChatUser userOne = ChatUser.fromJSON({
                ...decodedBody["user1"],
                "last_active": DateTime.parse(
                    decodedBody["user1"]["last_active"]["_seconds"].toString())
              });
              ChatUser userTwo = ChatUser.fromJSON({
                ...decodedBody["user2"],
                "last_active": DateTime.parse(
                    decodedBody["user2"]["last_active"]["_seconds"].toString())
              });

              // TODO: navigate to chat page and pass the new chat as argument

            }

            // still no user found - set isLoading false to indicate that there is currently no one in the range.F
            if (i >= 10) {
              isLoading = false;
              foundChat = "";
              notifyListeners();
            }
          } else {
            throw Exception('Failed to execute the findUserToChat');
          }

          i++;
        }

        await _database.makeUserNotSearchable(_auth.user.uid);
      } catch (e) {
        print(e);
        isLoading = false;
        foundChat = "";
        notifyListeners();
      }
    });
  }
}
