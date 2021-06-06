import 'package:flutter/material.dart';
import 'package:frontend/services/servicelocator.dart';
import 'package:frontend/viewmodels/login_viewmodel.dart';
import 'package:frontend/widgets/facebook_login_button.dart';
import 'package:frontend/widgets/google_login_button.dart';

enum LoginViewModes { Login, Signin }

class LoginView extends StatefulWidget {
  static String route = "LoginView";
  LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  LoginViewModes _mode = LoginViewModes.Login;
  LoginViewModel _viewModel = serviceLocator<LoginViewModel>();

  late TextEditingController _loginEmailTextController;
  late TextEditingController _loginPasswordTextController;

  late TextEditingController _registerEmailTextController;
  late TextEditingController _registerPasswordTextController;

  @override
  void initState() {
    super.initState();
    _loginEmailTextController = TextEditingController();
    _loginPasswordTextController = TextEditingController();
    _registerEmailTextController = TextEditingController();
    _registerPasswordTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: _mode == LoginViewModes.Login ? _loginView() : _signinView(),
        ),
      ),
    );
  }

  ///
  /// Create login view
  ///
  Widget _loginView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Log In",
          style: _createTitleStyle(),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account?",
              style: _createSubTitleStyle(),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _mode = LoginViewModes.Signin;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Sign Up",
                  style: _createSubTitleStyle(),
                ),
              ),
            ),
          ],
        ),
        Container(height: 40),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: TextField(
                        controller: _loginEmailTextController,
                        decoration: _textFieldDecoration("Email"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: TextField(
                        controller: _loginPasswordTextController,
                        obscureText: true,
                        decoration: _textFieldDecoration("Password"),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        _viewModel.loginWithEmail(
                          _loginEmailTextController.text,
                          _loginPasswordTextController.text,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text("Log In"),
                      ),
                    ),
                  ],
                ),
              ),
              VerticalDivider(
                thickness: 1,
                width: 80,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: FacebookLoginButton(
                        text: "Login with Facebook",
                        pressed: () => _viewModel.loginFacebook(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 24),
                      child: GoogleLoginButton(
                        text: "Login with Google",
                        pressed: () => _viewModel.loginGoogle(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  ///
  /// Create sign in view
  ///
  Widget _signinView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Sign Up",
          style: _createTitleStyle(),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have an account?",
              style: _createSubTitleStyle(),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _mode = LoginViewModes.Login;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Log In",
                  style: _createSubTitleStyle(),
                ),
              ),
            ),
          ],
        ),
        Container(height: 40),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: TextField(
                        controller: _registerEmailTextController,
                        decoration: _textFieldDecoration("Email"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: TextField(
                        decoration: _textFieldDecoration("Type email again"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: TextField(
                        controller: _registerPasswordTextController,
                        obscureText: true,
                        decoration: _textFieldDecoration("Password"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: TextField(
                        obscureText: true,
                        decoration: _textFieldDecoration("Type password again"),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        _viewModel.registerWithEmail(
                          _registerEmailTextController.text,
                          _registerPasswordTextController.text,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text("Sign Up"),
                      ),
                    ),
                  ],
                ),
              ),
              VerticalDivider(
                thickness: 1,
                width: 80,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: FacebookLoginButton(
                        text: "Continue with Facebook",
                        pressed: () => _viewModel.loginFacebook(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 24),
                      child: GoogleLoginButton(
                        text: "Continue with Google",
                        pressed: () => _viewModel.loginGoogle(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  ///
  /// Input style
  ///
  InputDecoration _textFieldDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    );
  }

  ///
  /// Title style
  ///
  TextStyle _createTitleStyle() {
    return TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.bold,
    );
  }

  ///
  /// Sub title style
  ///
  TextStyle _createSubTitleStyle() {
    return TextStyle(
      fontSize: 16,
    );
  }
}
