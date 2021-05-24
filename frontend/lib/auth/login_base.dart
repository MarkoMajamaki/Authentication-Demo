import 'package:frontend/auth/user.dart';

abstract class LoginBase {
  final String appId;
  final String appSecret;

  LoginBase(this.appId, this.appSecret);

  Future<User> authenticate();
}
