import './user.dart';

class Post {
  final String postImage;
  final String caption;
  final User user;
  final String date;

  Post(
      {required this.user,
      required this.postImage,
      required this.caption,
      required this.date});
}
