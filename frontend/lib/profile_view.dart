import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileView extends StatefulWidget {
  static const route = '/ProfileView';
  ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ProfileViewArgs;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Image.network(
                args.pictureUrl,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text("${args.firstName} ${args.lastName}"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: Text("${args.email}"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: ElevatedButton(
                onPressed: _logout,
                child: Text("Logout"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///
  /// Logout
  ///
  void _logout() {}
}

class ProfileViewArgs {
  final String firstName;
  final String lastName;
  final String email;
  final String pictureUrl;

  ProfileViewArgs(this.firstName, this.lastName, this.email, this.pictureUrl);
}
