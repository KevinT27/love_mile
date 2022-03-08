//Packages


import 'package:flutter/material.dart';
import 'package:love_mile/widgets/logo_dart.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

//Widgets
import '../widgets/custom_input.dart';
import '../widgets/rounded_button.dart';

//Providers
import '../providers/authentication_provider.dart';

//Services
import '../services/navigation_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late NavigationService _navigation;

  final _loginFormKey = GlobalKey<FormState>();

  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _navigation = GetIt.instance.get<NavigationService>();
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
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
            const Logo(),
            SizedBox(
              height: _deviceHeight * 0.04,
            ),
            _loginForm(),
            SizedBox(
              height: _deviceHeight * 0.05,
            ),
            SizedBox(
              height: _deviceHeight * 0.02,
            ),
          ],
        ),
      ),
    );
  }



  Widget _loginForm() {
    return SizedBox(
      height: _deviceHeight * 0.42,
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
            SizedBox(height: _deviceHeight * 0.025),
            CustomTextFormField(
                onSaved: (_value) {
                  setState(() {
                    _password = _value;
                  });
                },
                regEx: r".{8,}",
                hintText: "Password",
                obscureText: true),
            SizedBox(height: _deviceHeight * 0.025),
            RoundedButton(
              name: "Login",
              height: _deviceHeight * 0.07,
              width: _deviceWidth * 0.9,
              onPressed: () {
                if (_loginFormKey.currentState!.validate()) {
                  _loginFormKey.currentState!.save();
                  _auth.loginUsingEmailAndPassword(_email!, _password!);
                }
              },
            ),
            SizedBox(height: _deviceHeight * 0.01),
            const Divider(
              height: 4,
              color: Colors.black,
            ),
            SizedBox(height: _deviceHeight * 0.01),
            RoundedButton(
                name: "Register",
                height: _deviceHeight * 0.08,
                width: _deviceWidth * 0.9,
                isInverted: true,
                onPressed: () {
                  _navigation.navigateToRoute("/register");
                }),
          ],
        ),
      ),
    );
  }


}
