class User {
  final String name;
  final String nickname;
  final String image;

  User({required this.name, required this.nickname, required this.image});
}

class UserStats {
  final String following;
  final String posts;
  final String followers;

  UserStats(this.following, this.posts, this.followers);
}
