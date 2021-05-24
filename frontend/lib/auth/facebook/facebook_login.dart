import 'dart:async';
import 'dart:convert';

import 'package:frontend/auth/auth_service.dart';
import 'package:frontend/auth/facebook/profile.dart';
import 'package:frontend/auth/login_base.dart';
import 'package:frontend/auth/token.dart';
import 'package:frontend/auth/user.dart';
import 'package:http/http.dart' as http;

class FacebookLogin extends LoginBase {
  String _authUrl = "https://www.facebook.com/dialog/oauth";
  String _redirectUrl = "http://localhost:8080/";
  String _scope = "public_profile";
  String _profileUrl = "https://graph.facebook.com/v2.8/me";
  String _state = "fbAuth";
  String _accessTokenUrl =
      "https://graph.facebook.com/v10.0/oauth/access_token";

  AuthService _authService = AuthService();

  FacebookLogin(appId, appSecret)
      : super(
          appId = appId,
          appSecret = appSecret,
        );

  ///
  /// Authenticate with facebook
  ///
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
    Profile facebookProfile = await _getProfile(token.accessToken);

    return User(
        facebookProfile.id,
        "$facebookProfile.firstName $facebookProfile.lastName",
        facebookProfile.email,
        facebookProfile.picture.data.url);
  }

  ///
  /// Exchange code to access token
  ///
  Future<Token> getToken(String code) async {
    // Exchanging Code for an Access Token
    String url = "$_accessTokenUrl"
        "?client_id=$appId"
        "&redirect_uri=$_redirectUrl"
        "&client_secret=$appSecret"
        "&code=$code";

    final response = await http.get(Uri.parse(url));

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
        "?access_token=$accessToken"
        "&fields=first_name,last_name,picture,email,id";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return new Profile.fromMap(jsonDecode(response.body));
    } else {
      throw response.body.toString();
    }
  }
}
