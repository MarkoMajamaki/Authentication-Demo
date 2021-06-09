import 'dart:core';
import 'dart:io';

import 'package:flutter/foundation.dart';

String get baseUrl {
  // Jos K8S nii tällöin api-auth!
  if (kIsWeb) {
    return "https://localhost:5001";
  } else if (Platform.isAndroid) {
    return "https://10.0.2.2:5001";
  } else {
    return "https://localhost:5001";
  }
}

final String loginEmailUrl = "$baseUrl/auth/login";
final String registerEmailUrl = "$baseUrl/auth/register";
final String registerEmailAdminUrl = "$baseUrl/auth/register-admin";
final String loginFacebookUrl = "$baseUrl/auth/login-facebook";
final String loginGoogleUrl = "$baseUrl/auth/login-google";
