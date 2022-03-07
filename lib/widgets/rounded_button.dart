import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String name;
  final double height;
  final double width;
  final Function onPressed;
  final bool isInverted;

  // ignore: use_key_in_widget_constructors
  const RoundedButton(
      {required this.name,
      required this.height,
      required this.width,
      required this.onPressed,
      this.isInverted = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height * 0.25),
          border: !isInverted
              ? null
              : Border.all(width: 2, color: const Color(0xFFEA49A4)),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              !isInverted ? const Color(0xFFEA49A4) : Colors.white,
              !isInverted ? const Color(0xFFDB06A6) : Colors.white,
            ],
          )),
      child: TextButton(
        onPressed: () => onPressed(),
        child: Text(
          name,
          style: TextStyle(
              fontSize: 22,
              color: !isInverted ? Colors.white : const Color(0xFFDB06A6),
              height: 1.5),
        ),
      ),
    );
  }
}
