import 'dart:core';
import 'dart:io';

String get baseUrl {
  if (Platform.isAndroid) {
    return "https://10.0.2.2:8004";
  } else {
    return "https://localhost:8004";
  }
}

final String loginEmailUrl = "$baseUrl/auth/login";
final String registerEmailUrl = "$baseUrl/auth/register";
final String registerEmailAdminUrl = "$baseUrl/auth/register-admin";
final String loginFacebookUrl = "$baseUrl/auth/login-facebook";
final String loginGoogleUrl = "$baseUrl/auth/login-google";
