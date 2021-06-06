import 'dart:convert';
import 'dart:io';

import 'package:frontend/core/api.dart';
import 'package:frontend/core/token.dart';
import 'package:frontend/core/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginService {
  static GoogleSignIn _googleSignIn = GoogleSignIn();

  ///
  /// Login with Google authentication
  ///
  static Future<User> login() async {
    GoogleSignInAccount? account = await _googleSignIn.signIn();

    if (account == null) {
      throw "Login failed!";
    }

    GoogleSignInAuthentication auth = await account.authentication;

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

    final request = await client.postUrl(Uri.parse(loginGoogleUrl));
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
    request.headers.set(HttpHeaders.acceptHeader, "application/json");
    request.write(json.encode({
      "Token": "${auth.idToken}",
    }));

    HttpClientResponse response = await request.close();

    if (response.statusCode != 200) {
      throw response.reasonPhrase;
    }

    // Parse our system access token
    String tokenJson = await response.transform(utf8.decoder).join();
    Token token = Token.fromJson(jsonDecode(tokenJson));

    return User(
      id: token.userId,
      userName: account.displayName,
      email: account.email,
      pictureUri: account.photoUrl,
    );
  }

  ///
  /// Logout
  ///
  static Future logOut() async {
    return await _googleSignIn.disconnect();
  }
}
