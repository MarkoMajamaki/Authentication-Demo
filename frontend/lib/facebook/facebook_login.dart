import 'dart:async';
import 'dart:convert';

import 'package:frontend/auth/auth_service.dart';
import 'package:frontend/auth/login_base.dart';
import 'package:frontend/auth/token.dart';
import 'package:frontend/auth/user.dart';
import 'package:frontend/facebook/profile.dart';
import 'package:http/http.dart' as http;

class FacebookLogin extends LoginBase {
  String _baseAuthUrl = "https://www.facebook.com/dialog/oauth";
  String _redirectUrl = "http://localhost:8080/";
  String _scope = "public_profile";
  String _baseProfileUrl = "https://graph.facebook.com/v2.8/me";
  String _state = "fbAuth";

  AuthService _authService = AuthService();

  FacebookLogin(appId, appSecret)
      : super(
          appId = appId,
          appSecret = appSecret,
        );

  ///
  /// Authenticate with facebook
  ///
  Future<User> authenticate() async {
    Token token = await _authService.getToken(
      authUrl: _baseAuthUrl,
      appId: appId,
      appSecret: appSecret,
      redirectUrl: _redirectUrl,
      scope: _scope,
      state: _state,
    );

    Profile facebookProfile = await _getProfile(token);

    return User(
        facebookProfile.id,
        facebookProfile.firstName,
        facebookProfile.lastName,
        facebookProfile.email,
        facebookProfile.picture.data.url);
  }

  ///
  /// Get public profile
  ///
  Future<Profile> _getProfile(Token token) async {
    final String profileUrl = "$_baseProfileUrl"
        "?access_token=$token.access"
        "&fields=first_name,last_name,picture,email,id";

    final response = await http.get(Uri.parse(profileUrl));

    return new Profile.fromMap(jsonDecode(response.body));
  }
}
