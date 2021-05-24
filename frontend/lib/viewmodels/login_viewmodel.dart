import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/auth/facebook/facebook_login.dart';
import 'package:frontend/auth/google/google_login.dart';
import 'package:frontend/auth/user.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:frontend/services/servicelocator.dart';
import 'package:frontend/views/profile_view.dart';

class LoginViewModel {
  NavigationService _navigationService = serviceLocator<NavigationService>();

  ///
  /// Login with Facebook
  ///
  void loginFacebook() async {
    FacebookLogin fb = FacebookLogin(
      env["Facebook_AppId"]!,
      env["Facebook_AppSecret"]!,
    );

    User user = await fb.authenticate();

    _navigationService.navigate(
      ProfileView.route,
      arguments: ProfileViewArgs(
        user.name,
        user.email,
        user.pictureUri,
      ),
    );
  }

  ///
  /// Login with Google
  ///
  void loginGoogle() async {
    GoogleLogin gl = GoogleLogin(
      env["Google_ClientId"]!,
      env["Google_ClientSecret"]!,
    );

    User user = await gl.authenticate();

    _navigationService.navigate(
      ProfileView.route,
      arguments: ProfileViewArgs(
        user.name,
        user.email,
        user.pictureUri,
      ),
    );
  }
}
