import 'package:frontend/core/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginService {
  static GoogleSignIn _googleSignIn = GoogleSignIn();

  ///
  /// Login
  ///
  static Future<User> login() async {
    GoogleSignInAccount? account = await _googleSignIn.signIn();

    if (account == null) {
      throw "Login failed!";
    }

    // GoogleSignInAuthentication auth = await account.authentication;
    // auth.accessToken;

    return User(
      account.id,
      account.displayName,
      account.email,
      account.photoUrl,
    );
  }

  ///
  /// Logout
  ///
  static Future logOut() async {
    return await _googleSignIn.disconnect();
  }
}
