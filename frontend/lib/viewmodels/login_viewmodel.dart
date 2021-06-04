import 'package:frontend/services/facebook_login_services.dart';
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
        user.name,
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
        user.name,
        user.email,
        user.pictureUri,
        "google",
      ),
    );
  }
}
