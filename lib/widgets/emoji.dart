import 'package:flutter/material.dart';

class Emoji extends StatelessWidget {
  String avatar;

  Emoji({Key? key, required this.avatar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset("assets/images/avatar_emojis/$avatar.png", height: 70,
      width: 70);
  }
}
