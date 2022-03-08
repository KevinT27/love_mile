//Packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:love_mile/pages/chats_page.dart';
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
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _navigation = GetIt.instance.get<NavigationService>();

    Future.delayed(const Duration(seconds: 3),() {
      _navigation.navigateToPage(const ChatsPage());
    });

  }


  @override
  Widget build(BuildContext context) {
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

  Widget _headerArea () {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Logo(isStacked: true),
          Emoji()],
    );
  }

  Widget _scanner () {
    return Column(
      children: const [
       AnimatedLogo(),
        Text("Scanning your area...", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
        Padding(
          padding: EdgeInsets.all(30.0),
          child: Text("You know you're in love when you can't fall asleep because reality is finally better than your dreams.", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w300),),
        )
      ],
    );

  }
}
