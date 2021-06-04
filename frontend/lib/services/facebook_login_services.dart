import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:frontend/core/api.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:frontend/core/user.dart';

class FacebookLoginService {
  ///
  /// Authenticate with facebook
  ///
  static Future<User> login() async {
    final LoginResult result = await FacebookAuth.instance.login(
      loginBehavior: LoginBehavior.webOnly,
    );

    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;

      final params = {
        "Token": "${accessToken.token}",
      };

      final body = json.encode(params);

      try {
        HttpClient client = new HttpClient();
        client.badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);

        final request = await client.postUrl(Uri.parse(loginFacebookUrl));
        request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
        request.headers.set(HttpHeaders.acceptHeader, "application/json");
        request.write(body);

        HttpClientResponse response = await request.close();

        if (response.statusCode == 400) {
          throw response.reasonPhrase;
        }
      } on Exception catch (_) {
        print(_.toString());
      }

      final userData = await FacebookAuth.instance.getUserData();
      _FacebookUser user = _FacebookUser.fromMap(userData);

      return User(
        user.id,
        user.name,
        user.email,
        user.picture != null ? user.picture!.data.url : null,
      );
    } else {
      throw "Login failed!";
    }
  }

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
