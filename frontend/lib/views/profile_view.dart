import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/services/google_login_service.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:frontend/services/servicelocator.dart';

class ProfileView extends StatefulWidget {
  static const route = '/ProfileView';
  ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  NavigationService _navigationService = serviceLocator<NavigationService>();

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
                args.pictureUrl!,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text("${args.name}"),
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
  void _logout() {
    final args = ModalRoute.of(context)!.settings.arguments as ProfileViewArgs;

    if (args.providerCode == "google") {
      GoogleLoginService.logOut();
    }

    _navigationService.goBack();
  }
}

class ProfileViewArgs {
  final String? name;
  final String email;
  final String? pictureUrl;
  final String providerCode;

  ProfileViewArgs(this.name, this.email, this.pictureUrl, this.providerCode);
}
