class Profile {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final Picture picture;

  Profile.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        firstName = json["first_name"],
        lastName = json["last_name"],
        email = json["email"],
        picture = Picture.fromMap(json["picture"]);
}

class Picture {
  final Data data;
  Picture.fromMap(Map<String, dynamic> json)
      : data = Data.fromMap(json["data"]);
}

class Data {
  final int height;
  final int width;
  final String url;
  final bool isSilhouette;

  Data.fromMap(Map<String, dynamic> json)
      : height = json["height"],
        width = json["width"],
        url = json["url"],
        isSilhouette = json["is_silhouette"];
}
