import 'package:frontend/core/token.dart';

class User {
  final String id;
  final String? userName;
  final String email;
  final String? pictureUri;

  Token? token;

  User(
      {required this.id,
      required this.email,
      this.userName,
      this.pictureUri,
      this.token});
}
