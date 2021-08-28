class User {
  final String id;
  final String? name;
  final String nickname;
  final String image;

  User(
      {required this.id,
      required this.nickname,
      required this.image,
      this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    final id = json["id"] as String;
    final username = json['username'] as String;
    final fullName = json['full_name'] as String?;
    final userImage = json['profile_pic_url'] as String? ??
        'https://instagram.fmsq2-1.fna.fbcdn.net/v/t51.2885-19/s150x150/94206726_531697684176564_7933252994592669696_n.jpg?_nc_ht=instagram.fmsq2-1.fna.fbcdn.net&_nc_ohc=x5a23r6gICMAX8UXI2t&edm=AGW0Xe4BAAAA&ccb=7-4&oh=df77651cec7e6e6a0c27ba0ec3a7535a&oe=6131519C&_nc_sid=acd11b';
    return User(
      id: id,
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
