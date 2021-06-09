import 'dart:convert';
import 'dart:io';

import 'package:frontend/core/api.dart';
import 'package:frontend/core/token.dart';
import 'package:frontend/core/user.dart';

import 'package:http/http.dart' as http;

class EmailLoginService {
  ///
  /// Register new user
  ///
  static Future register(String email, String password) async {
    final request = await http.post(
      Uri.parse(registerEmailUrl),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.acceptHeader: "application/json",
      },
      body: json.encode(
        {
          "Email": "$email",
          "Password": "$password",
        },
      ),
    );

    if (request.statusCode != 200) {
      throw request.reasonPhrase ?? "";
    }
  }

  ///
  /// Login with email
  ///
  static Future<User?> login(String email, String password) async {
    final request = await http.post(
      Uri.parse(loginEmailUrl),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.acceptHeader: "application/json",
      },
      body: json.encode(
        {
          "Email": "$email",
          "Password": "$password",
        },
      ),
    );

    if (request.statusCode != 200) {
      throw request.reasonPhrase ?? "";
    }

    // Our system access token
    Token token = Token.fromJson(jsonDecode(request.body));

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
