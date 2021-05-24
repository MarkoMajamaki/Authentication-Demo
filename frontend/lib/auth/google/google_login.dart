import 'dart:convert';

import 'package:frontend/auth/auth_service.dart';
import 'package:frontend/auth/google/profile.dart';
import 'package:frontend/auth/login_base.dart';
import 'package:frontend/auth/token.dart';
import 'package:frontend/auth/user.dart';

import 'package:http/http.dart' as http;

class GoogleLogin extends LoginBase {
  String _authUrl = "https://accounts.google.com/o/oauth2/v2/auth";
  String _redirectUrl = "http://localhost:8080/";
  String _state = "googleAuth";
  String _accessTokenUrl = "https://oauth2.googleapis.com/token";

  String _scope =
      "https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email";
  String _profileUrl = "https://www.googleapis.com/oauth2/v1/userinfo";

  AuthService _authService = AuthService();

  GoogleLogin(String appId, String appSecret) : super(appId, appSecret);

  @override
  Future<User> authenticate() async {
    String code = await _authService.getCode(
      authUrl: _authUrl,
      appId: appId,
      appSecret: appSecret,
      redirectUrl: _redirectUrl,
      scope: _scope,
      state: _state,
    );

    Token token = await getToken(code);
    Profile googleProfile = await _getProfile(token.accessToken);

    return User(
      googleProfile.id,
      googleProfile.name,
      googleProfile.email,
      googleProfile.pictureUrl,
    );
  }

  ///
  /// Exchange code to access token
  ///
  Future<Token> getToken(String code) async {
    // Exchanging Code for an Access Token
    String url = "$_accessTokenUrl"
        "?code=$code"
        "&client_id=$appId"
        "&client_secret=$appSecret"
        "&redirect_uri=$_redirectUrl"
        "&grant_type=authorization_code";

    final response = await http.post(Uri.parse(url));

    if (response.statusCode == 200) {
      return Token.fromMap(jsonDecode(response.body));
    } else {
      throw response.body.toString();
    }
  }

  ///
  /// Get public profile
  ///
  Future<Profile> _getProfile(String accessToken) async {
    String url = "$_profileUrl"
        "?alt=json"
        "&access_token=$accessToken";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return new Profile.fromMap(jsonDecode(response.body));
    } else {
      throw response.body.toString();
    }
  }
}
