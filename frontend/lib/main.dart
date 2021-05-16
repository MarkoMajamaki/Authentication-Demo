import 'package:flutter/material.dart';
import 'package:frontend/login_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/profile_view.dart';

void main() async {
  await load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        ProfileView.route: (context) => ProfileView(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Authentication-Demo',
      home: LoginView(),
    );
  }
}
