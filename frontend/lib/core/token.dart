class Token {
  final String userId;
  final String token;
  final DateTime expiration;

  Token({required this.userId, required this.token, required this.expiration});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      userId: json["userId"],
      token: json["token"],
      expiration: DateTime.parse(json["expiration"]),
    );
  }
}
