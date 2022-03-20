import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Services
import 'package:love_mile/services/database_service.dart';
import 'package:love_mile/services/location_service.dart';
import 'package:love_mile/services/network_service.dart';
import 'package:love_mile/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

// Providers
import '../providers/authentication_provider.dart';
import '../providers/home_page_provider.dart';

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
  late double _deviceHeight;
  late double _deviceWidth;

  late NavigationService _navigation;
  late LocationService _location;
  late DatabaseService _database;
  late NetworkService _network;

  late AuthenticationProvider _auth;
  late HomePageProvider _home;

  late HomePageProvider _pageProvider;

  String _foundChat = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _navigation = GetIt.instance.get<NavigationService>();
    _database = GetIt.instance.get<DatabaseService>();
    _network = GetIt.instance.get<NetworkService>();
  }

  @override
  void dispose() {
    super.dispose();

    _database.deactivateUserSearching(_auth.user.uid);
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomePageProvider>(
          create: (_) => HomePageProvider(_auth),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(builder: (BuildContext _context) {
      _pageProvider = _context.watch<HomePageProvider>();
      _foundChat = _pageProvider.foundChat;
      _isLoading = _pageProvider.isLoading;
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(11.0),
            child: Column(
              children: [
                _headerArea(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: _deviceHeight * 0.5,
                      child: () {
                        if (_isLoading) {
                          return _scanner();
                        } else {
                          return notFoundInfo();
                        }
                      }(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _headerArea() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Logo(isStacked: true),
        logoutButton(),
      ],
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
        ),
      ],
    );
  }

  Widget notFoundInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RoundedButton(
            name: "Another try?",
            height: _deviceHeight * 0.065,
            width: _deviceWidth * 0.65,
            onPressed: _pageProvider.startUserSearching),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            "Enable auto search",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget logoutButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: TextButton(
          onPressed: () {
            _auth.logout();
          },
          child: const Text(
            "Logout",
            style:
                TextStyle(fontSize: 17, color: Color(0xFFDB06A6), height: 1.5),
          )),
    );
  }
}
