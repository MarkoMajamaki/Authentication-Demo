import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GoogleLoginButton extends StatefulWidget {
  final String text;
  final Function pressed;

  GoogleLoginButton({
    Key? key,
    required this.text,
    required this.pressed,
  }) : super(key: key);

  @override
  _GoogleLoginButtonState createState() => _GoogleLoginButtonState();
}

class _GoogleLoginButtonState extends State<GoogleLoginButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => widget.pressed(),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 24,
                height: 24,
                child: Image(
                  image: AssetImage("images/google_logo.png"),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  widget.text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
