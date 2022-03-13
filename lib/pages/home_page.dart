//Packages
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:love_mile/models/chat.dart';
import 'package:love_mile/pages/chats_page.dart';

// Services
import 'package:love_mile/services/database_service.dart';
import 'package:love_mile/services/location_service.dart';
import 'package:love_mile/services/network_service.dart';
import 'package:provider/provider.dart';

// Providers
import '../providers/authentication_provider.dart';

// Widgets
import 'package:love_mile/widgets/animated_logo.dart';
import 'package:love_mile/widgets/emoji.dart';
import 'package:love_mile/widgets/logo_dart.dart';

import '../services/navigation_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  late NavigationService _navigation;
  late LocationService _location;
  late DatabaseService _database;
  late NetworkService _network;

  late AuthenticationProvider _auth;

  @override
  void initState() {
    super.initState();

    _navigation = GetIt.instance.get<NavigationService>();
    _location = GetIt.instance.get<LocationService>();
    _database = GetIt.instance.get<DatabaseService>();
    _network = GetIt.instance.get<NetworkService>();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _database.deactivateUserSearching(_auth.user.uid);
  }

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);
    _location.determinePosition().then((position) async {
      DocumentReference? _doc =
          await _database.makeUserSearchable(_auth.user.uid, {
        "lng": position.longitude,
        "lat": position.latitude,
      });

      // TODO: listen for user changes on pool
      final response = await _network.fetchData(
          "https://us-central1-love-mile.cloudfunctions.net/findUserToChat");

      if(response.statusCode == 200) {

      } else {
        throw Exception('Faled to execute the findUserToChat');
      }

    });
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: Column(
            children: [
              _headerArea(),
              _scanner(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerArea() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [Logo(isStacked: true), Emoji()],
    );
  }

  Widget _scanner() {
    return Column(
      children: const [
        AnimatedLogo(),
        Text(
          "Scanning your area...",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: EdgeInsets.all(30.0),
          child: Text(
            "You know you're in love when you can't fall asleep because reality is finally better than your dreams.",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w300),
          ),
        )
      ],
    );
  }
}
