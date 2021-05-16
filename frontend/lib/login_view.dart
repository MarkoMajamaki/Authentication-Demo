import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:frontend/facebook/profile.dart';
import 'package:frontend/profile_view.dart';
import 'facebook/facebook_login.dart';
import 'facebook/token.dart';

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

    Token token = await fb.getToken();
    Profile profile = await fb.getProfile(token);

    Navigator.pushNamed(
      context,
      ProfileView.route,
      arguments: ProfileViewArgs(
        profile.firstName,
        profile.lastName,
        profile.email,
        profile.picture.data.url,
      ),
    );
  }

  void _loginGoogle() {}

  void _loginApple() {}
}
