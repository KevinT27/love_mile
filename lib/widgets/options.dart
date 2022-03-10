import 'package:flutter/material.dart';



class Options extends StatefulWidget {
  final Function(String) onChanged;

  const Options({Key? key, required this.onChanged}) : super(key: key);

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  String? _character = "male";
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ListTile(
            title: const Text('Male'),
            leading: Radio<String>(
              value: "male",
              groupValue: _character,
              onChanged: (_value) => {
                setState(() {
                  _character = _value;
                }),
                widget.onChanged(_value!)
              }
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: const Text('Female'),
            leading: Radio<String>(
              activeColor: const Color(0xFFEA49A4),
              value: "female",
              groupValue: _character,
              onChanged: (_value) => {
                setState(() {
                  _character = _value;
                }),
                widget.onChanged(_value!)
              },
            ),
          ),
        ),
      ],
    );
  }
}
