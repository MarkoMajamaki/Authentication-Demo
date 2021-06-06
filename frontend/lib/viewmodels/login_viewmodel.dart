import 'package:frontend/services/email_login_service.dart';
import 'package:frontend/services/facebook_login_service.dart';
import 'package:frontend/services/google_login_service.dart';
import 'package:frontend/core/user.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:frontend/services/servicelocator.dart';
import 'package:frontend/views/profile_view.dart';

class LoginViewModel {
  NavigationService _navigationService = serviceLocator<NavigationService>();

  ///
  /// Login with Facebook
  ///
  void loginFacebook() async {
    User? user = await FacebookLoginService.login();

    if (user == null) {
      return;
    }

    _navigationService.navigate(
      ProfileView.route,
      arguments: ProfileViewArgs(
        user.userName,
        user.email,
        user.pictureUri,
        "facebook",
      ),
    );
  }

  ///
  /// Login with Google
  ///
  void loginGoogle() async {
    User? user = await GoogleLoginService.login();

    if (user == null) {
      return;
    }

    _navigationService.navigate(
      ProfileView.route,
      arguments: ProfileViewArgs(
        user.userName,
        user.email,
        user.pictureUri,
        "google",
      ),
    );
  }

  ///
  /// Login with email
  ///
  void loginWithEmail(String email, String password) async {
    User? user = await EmailLoginService.login(email, password);

    if (user == null) {
      return;
    }

    _navigationService.navigate(
      ProfileView.route,
      arguments: ProfileViewArgs(
        user.userName,
        user.email,
        user.pictureUri,
        "email",
      ),
    );
  }

  ///
  /// Register with email
  ///
  void registerWithEmail(String email, String password) async {
    await EmailLoginService.register(email, password);
    User? user = await EmailLoginService.login(email, password);

    if (user == null) {
      return;
    }

    _navigationService.navigate(
      ProfileView.route,
      arguments: ProfileViewArgs(
        user.userName,
        user.email,
        user.pictureUri,
        "email",
      ),
    );
  }
}
