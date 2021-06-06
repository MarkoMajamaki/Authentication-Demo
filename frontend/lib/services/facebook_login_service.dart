import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:frontend/core/api.dart';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:frontend/core/token.dart';
import 'package:frontend/core/user.dart';

class FacebookLoginService {
  ///
  /// Login with Facebook authentication
  ///
  static Future<User> login() async {
    final LoginResult result = await FacebookAuth.instance.login(
      loginBehavior: LoginBehavior.webOnly,
    );

    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;

      HttpClient client = new HttpClient();
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

      final request = await client.postUrl(Uri.parse(loginFacebookUrl));
      request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
      request.headers.set(HttpHeaders.acceptHeader, "application/json");
      request.write(json.encode({
        "Token": "${accessToken.token}",
      }));

      HttpClientResponse response = await request.close();

      if (response.statusCode != 200) {
        throw response.reasonPhrase;
      }

      // Parse our system access token
      String tokenJson = await response.transform(utf8.decoder).join();
      Token token = Token.fromJson(jsonDecode(tokenJson));

      // Get facebook user data
      final userData = await FacebookAuth.instance.getUserData();
      _FacebookUser facebookUser = _FacebookUser.fromMap(userData);

      return User(
        id: token.userId,
        email: facebookUser.email,
        userName: facebookUser.name,
        pictureUri: facebookUser.picture != null
            ? facebookUser.picture!.data.url
            : null,
      );
    } else {
      throw "Login failed!";
    }
  }

  ///
  /// Logout from Facebook auth
  ///
  static Future logout() async {
    await FacebookAuth.instance.logOut();
  }
}

class _FacebookUser {
  final String id;
  final String name;
  final String email;
  final _Picture? picture;

  _FacebookUser.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        name = json["name"],
        email = json["email"],
        picture = json.containsKey("picture")
            ? _Picture.fromMap(Map<String, dynamic>.from(json["picture"]))
            : null;
}

class _Picture {
  final _Data data;
  _Picture.fromMap(Map<String, dynamic> json)
      : data = _Data.fromMap(Map<String, dynamic>.from(json["data"]));
}

class _Data {
  final int height;
  final int width;
  final String url;
  final bool isSilhouette;

  _Data.fromMap(Map<String, dynamic> json)
      : height = json["height"],
        width = json["width"],
        url = json["url"],
        isSilhouette = json["is_silhouette"];
}
