import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final bool isStacked;

  const Logo({
    Key? key,
    this.isStacked = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isStacked ? _stackedLogo(context) : _defaultLogo(context) ;
  }

  Widget _defaultLogo(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          width: 300,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/logo.png'),
            ),
          ),
        ),
        Text(
          "Love Mile",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Theme.of(context).textTheme.headline4?.fontSize),
        ),
      ],
    );
  }

  Widget _stackedLogo(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 75),
          child: Image.asset(
            'assets/images/logo.png',
            height: 70,
            width: 70,
            fit: BoxFit.cover,
          ),
        ),
        const Text("Love Mile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
      ],
    );
  }
}
