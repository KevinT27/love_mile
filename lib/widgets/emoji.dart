import 'package:flutter/material.dart';

class Emoji extends StatelessWidget {
  const Emoji({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset("assets/images/avatar_emojis/male_blonde.png", height: 70,
      width: 70);
  }
}
