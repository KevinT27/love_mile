import 'package:flutter/material.dart';

enum SingingCharacter { male, female }

class Options extends StatefulWidget {
  const Options({Key? key}) : super(key: key);

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  SingingCharacter? _character = SingingCharacter.male;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ListTile(
            title: const Text('Male'),
            leading: Radio<SingingCharacter>(
              value: SingingCharacter.male,
              groupValue: _character,
              onChanged: (SingingCharacter? value) {
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: const Text('Female'),
            leading: Radio<SingingCharacter>(
              activeColor: const Color(0xFFEA49A4),
              value: SingingCharacter.female,
              groupValue: _character,
              onChanged: (SingingCharacter? value) {
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
