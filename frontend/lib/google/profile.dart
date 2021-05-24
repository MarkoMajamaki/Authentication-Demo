class Profile {
  final String id;
  final String email;
  final String name;
  final String pictureUrl;

  Profile.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        name = json["name"],
        email = json["email"],
        pictureUrl = json["picture"];
}
