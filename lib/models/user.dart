class User {
  final String id;
  final String? name;
  final String nickname;
  final String? image;

  User({required this.id, required this.nickname, this.image, this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    final id = json["id"] as String?;
    final pk = json["pk"] as int?;
    final username = json['username'] as String;
    final fullName = json['full_name'] as String?;
    final userImage = json['profile_pic_url'] as String?;
    return User(
      id: id ?? pk.toString(),
      name: fullName,
      nickname: username,
      image: userImage,
    );
  }
}

class UserStats {
  final String following;
  final String posts;
  final String followers;

  UserStats(this.following, this.posts, this.followers);
}
