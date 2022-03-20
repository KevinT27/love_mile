//Packages
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:love_mile/widgets/options.dart';
import 'package:provider/provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

//Services
import '../services/media_service.dart';
import '../services/database_service.dart';
import '../services/cloud_storage_service.dart';

//Widgets
import '../widgets/custom_input.dart';
import '../widgets/rounded_button.dart';
import '../widgets/rounded_image.dart';

//Providers
import '../providers/authentication_provider.dart';

enum GenderCharacter { male, female }

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late DatabaseService _db;
  late CloudStorageService _cloudStorage;

  String? _email;
  String? _password;
  String? _name;
  String? _gender = "male";
  String? _avatar = 'male_blonde';

  final _registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);
    _db = GetIt.instance.get<DatabaseService>();
    _cloudStorage = GetIt.instance.get<CloudStorageService>();
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.03,
          vertical: _deviceHeight * 0.02,
        ),
        height: _deviceHeight * 0.98,
        width: _deviceWidth * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _profileImageField(),
            SizedBox(
              height: _deviceHeight * 0.05,
            ),
            _registerForm(),
            SizedBox(
              height: _deviceHeight * 0.05,
            ),
            _registerButton(),
            SizedBox(
              height: _deviceHeight * 0.02,
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileImageField() {
    return GestureDetector(
      onTap: () {
        showMaterialModalBottomSheet(
            context: context, builder: (context) => _emojiBottomSheet());
      },
      child: RoundedImage(
        key: UniqueKey(),
        imagePath: 'assets/images/avatar_emojis/$_avatar.png',
        size: _deviceHeight * 0.15,
      ),
    );
  }

  Widget _registerForm() {
    return SizedBox(
      height: _deviceHeight * 0.45,
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Gender",
              style: TextStyle(fontSize: 17.5),
            ),
            Options(
              onChanged: (_value) {
                setState(() {
                  _gender = _value;
                  _avatar = _gender == 'male' ? 'male_blonde' : 'female_blonde';
                });
              },
            ),
            SizedBox(
              height: _deviceHeight * 0.02,
            ),
            CustomTextFormField(
                onSaved: (_value) {
                  setState(() {
                    _name = _value;
                  });
                },
                regEx: r'.{8,}',
                hintText: "Name",
                obscureText: false),
            SizedBox(
              height: _deviceHeight * 0.01,
            ),
            CustomTextFormField(
                onSaved: (_value) {
                  setState(() {
                    _email = _value;
                  });
                },
                regEx:
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                hintText: "Email",
                obscureText: false),
            SizedBox(
              height: _deviceHeight * 0.01,
            ),
            CustomTextFormField(
                onSaved: (_value) {
                  setState(() {
                    _password = _value;
                  });
                },
                regEx: r".{8,}",
                hintText: "Password",
                obscureText: true),
          ],
        ),
      ),
    );
  }

  Widget _registerButton() {
    return RoundedButton(
      name: "Register",
      height: _deviceHeight * 0.065,
      width: _deviceWidth * 0.65,
      onPressed: () async {
        if (_registerFormKey.currentState!.validate()) {
          _registerFormKey.currentState!.save();
          String? _uid = await _auth.registerUserUsingEmailAndPassword(
              _email!, _password!);


          await _db.createUser(_uid!, _email!, _name!, _gender!, _avatar!);

          await _auth.loginUsingEmailAndPassword(_email!, _password!);
        }
      },
    );
  }

  Widget _emojiBottomSheet() {
    const maleAvatars = ["male_blonde", "male_dark_blonde"];
    const femaleAvatars = ["female_blonde", "female_black", "female_brown"];

    final avatarsShowing = _gender == "male" ? maleAvatars : femaleAvatars;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Text(
              "Select your avatar",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              children: avatarsShowing
                  .map(
                    (avatar) => RoundedImage(

                      key: UniqueKey(),
                      size: _deviceHeight * 0.15,
                      imagePath: 'assets/images/avatar_emojis/$avatar.png',
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
