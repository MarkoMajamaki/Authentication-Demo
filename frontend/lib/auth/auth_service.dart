import 'dart:async';
import 'dart:io';

import 'package:frontend/auth/token.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthService {
  ///
  /// Get token
  ///
  Future<Token> getToken({
    required String authUrl,
    required String appId,
    required String appSecret,
    required String redirectUrl,
    required String scope,
    required String state,
  }) async {
    Stream<String> onCode = await _server();

    String url = "$authUrl"
        "?client_id=$appId"
        "&redirect_uri=$redirectUrl"
        "&scope=$scope"
        "&response_type=token"
        '&state=$state';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }

    final String code = await onCode.first;
    return Token("null", "null", 1);
    /*
    final http.Response response = await http.get(Uri.parse(
        "https://graph.facebook.com/v2.2/oauth/access_token?client_id=$appId&redirect_uri=http://localhost:8080/&client_secret=$appSecret&code=$code"));
    return new Token.fromMap(jsonDecode(response.body));
    */
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
        await onCode.close();
      }
    });

    return onCode.stream;
  }
}
