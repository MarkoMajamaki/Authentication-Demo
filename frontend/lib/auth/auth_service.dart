import 'dart:async';
import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class AuthService {
  static HttpServer? _server;

  ///
  /// Get code by authenticating
  ///
  Future<String> getCode({
    required String authUrl,
    required String appId,
    required String appSecret,
    required String redirectUrl,
    required String scope,
    required String state,
  }) async {
    Stream<String> codeStrem = await _createServer();

    String url = "$authUrl"
        "?client_id=$appId"
        "&redirect_uri=$redirectUrl"
        "&scope=$scope"
        "&response_type=code"
        "&state=$state";

    String fixedUrl = Uri.parse(url).toString();

    if (await canLaunch(fixedUrl)) {
      await launch(fixedUrl);
    } else {
      throw 'Could not launch $url';
    }

    // Await to get code from redirect
    return await codeStrem.first;
  }

  ///
  /// Launch simple server to handle requests
  ///
  Future<Stream<String>> _createServer() async {
    final StreamController<String> codeController = new StreamController();

    if (_server == null) {
      _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);

      _server!.listen((HttpRequest request) async {
        // Get code from query parameters
        final String? code = request.uri.queryParameters["code"];

        // Show correct message in redirect page depending loging success
        String loginMessage;
        if (code != null) {
          loginMessage = "Login successful! You can now close this window";
        } else {
          loginMessage = "Login failed! You can now close this window";
        }

        // Form html page resopnse
        request.response
          ..statusCode = 200
          ..headers.set("Content-Type", ContentType.html.mimeType)
          ..write("<html><h1>$loginMessage<h1></html>");

        // ??
        await request.response.close();

        // Close localhost server
        await _server!.close(force: true);
        _server = null;

        if (code != null) {
          codeController.add(code);
        }
        await codeController.close();
      });
    }

    return codeController.stream;
  }
}
