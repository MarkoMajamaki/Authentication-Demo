import 'dart:convert';
import 'dart:io';

import 'package:frontend/core/api.dart';
import 'package:frontend/core/token.dart';
import 'package:frontend/core/user.dart';

class EmailLoginService {
  ///
  /// Register new user
  ///
  static Future register(String email, String password) async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

    final body = json.encode({
      "Email": "$email",
      "Password": "$password",
    });

    final request = await client.postUrl(Uri.parse(registerEmailUrl));
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
    request.headers.set(HttpHeaders.acceptHeader, "application/json");
    request.write(body);

    HttpClientResponse response = await request.close();

    if (response.statusCode != 200) {
      throw response.reasonPhrase;
    }
  }

  ///
  /// Login with email
  ///
  static Future<User> login(String email, String password) async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

    final body = json.encode({
      "Email": "$email",
      "Password": "$password",
    });

    final request = await client.postUrl(Uri.parse(loginEmailUrl));
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
    request.headers.set(HttpHeaders.acceptHeader, "application/json");
    request.write(body);

    HttpClientResponse response = await request.close();

    if (response.statusCode != 200) {
      throw response.reasonPhrase;
    }

    String tokenJson = await response.transform(utf8.decoder).join();
    Token token = Token.fromJson(jsonDecode(tokenJson));

    return User(
      id: token.userId,
      email: email,
      token: token,
    );
  }

  ///
  /// Logout
  ///
  static Future logout() {
    throw "Not implemented!";
  }
}
