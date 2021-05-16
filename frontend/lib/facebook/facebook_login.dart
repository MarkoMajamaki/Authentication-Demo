import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:frontend/facebook/profile.dart';
import 'package:frontend/facebook/token.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class FacebookLogin {
  final String appId;
  final String appSecret;

  FacebookLogin(this.appId, this.appSecret);

  ///
  /// Get Facebook token
  ///
  Future<Token> getToken() async {
    Stream<String> onCode = await _server();
    String url =
        "https://www.facebook.com/dialog/oauth?client_id=$appId&redirect_uri=http://localhost:8080/&scope=public_profile";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }

    final String code = await onCode.first;
    final http.Response response = await http.get(Uri.parse(
        "https://graph.facebook.com/v2.2/oauth/access_token?client_id=$appId&redirect_uri=http://localhost:8080/&client_secret=$appSecret&code=$code"));
    return new Token.fromMap(jsonDecode(response.body));
  }

  ///
  /// Get public profile
  ///
  Future<Profile> getProfile(Token token) async {
    String _fields = "first_name,last_name,picture,email,id";
    final response = await http.get(Uri.parse(
        "https://graph.facebook.com/v2.8/me?fields=$_fields&access_token=${token.access}"));

    return new Profile.fromMap(jsonDecode(response.body));
  }

  ///
  /// Launch simple server to handle requests
  ///
  Future<Stream<String>> _server() async {
    final StreamController<String> onCode = new StreamController();

    HttpServer server =
        await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);

    server.listen((HttpRequest request) async {
      final String? code = request.uri.queryParameters["code"];

      request.response
        ..statusCode = 200
        ..headers.set("Content-Type", ContentType.html.mimeType)
        ..write("<html><h1>You can now close this window</h1></html>");

      await request.response.close();
      await server.close(force: true);
      if (code != null) {
        onCode.add(code);
      }
      await onCode.close();
    });

    return onCode.stream;
  }
}
