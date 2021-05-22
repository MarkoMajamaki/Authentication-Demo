import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/auth/user.dart';

import 'package:frontend/profile_view.dart';
import 'facebook/facebook_login.dart';

class LoginView extends StatefulWidget {
  LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _loginFacebook,
                child: Text("Login with Facebook"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: ElevatedButton(
                  onPressed: _loginGoogle,
                  child: Text("Login with Google"),
                ),
              ),
              ElevatedButton(
                onPressed: _loginApple,
                child: Text("Login with Apple"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  /// Login with facebook
  ///
  void _loginFacebook() async {
    FacebookLogin fb = FacebookLogin(
      env["Facebook_AppId"]!,
      env["Facebook_AppSecret"]!,
    );

    User user = await fb.authenticate();

    Navigator.pushNamed(
      context,
      ProfileView.route,
      arguments: ProfileViewArgs(
        user.firstName,
        user.lastName,
        user.email,
        user.pictureUri,
      ),
    );
  }

  void _loginGoogle() {}

  void _loginApple() {}
}
