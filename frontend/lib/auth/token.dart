class Token {
  final String accessToken;
  final String tokenType;
  final num expiresIn;

  Token.fromMap(Map<String, dynamic> json)
      : accessToken = json["access_token"],
        tokenType = json["token_type"],
        expiresIn = json["expires_in"];
}
