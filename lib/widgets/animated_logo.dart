import 'package:flutter/material.dart';

class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({Key? key}) : super(key: key);

  @override
  _AnimatedLogoState createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo> with TickerProviderStateMixin {
AnimationController? motionController;
Animation? motionAnimation;
double size = 20;
@override
  void initState() {
  super.initState();

  motionController = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
    lowerBound: 0.5,
  );

  motionAnimation = CurvedAnimation(
    parent: motionController!,
    curve: Curves.ease,
  );

  motionController!.forward();
  motionController!.addStatusListener((status) {
    setState(() {
      if (status == AnimationStatus.completed) {
        motionController!.reverse();
      } else if (status == AnimationStatus.dismissed) {
        motionController!.forward();
      }
    });
  });

  motionController!.addListener(() {
    setState(() {
      size = motionController!.value * 250;
    });
  });
  // motionController.repeat();
}

@override
void dispose() {
  motionController!.dispose();
  super.dispose();
}

@override
Widget build(BuildContext context) {
  return  // This trailing comma makes auto-formatting nicer for build methods.
  Column(
      children: <Widget>[
  Center(
  child: SizedBox(
      child: Stack(children: <Widget>[
      Center(
      child: SizedBox(
      child: Image.asset("assets/images/logo.png"),
  height: size,
  ),
  ),
  ]),
  height: 250,
  ),)],);
}
}
