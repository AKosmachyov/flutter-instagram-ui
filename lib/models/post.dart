import 'package:instagram_clone/models/user.dart';

class Post {
  final String postImage;
  final String caption;
  final User user;

  Post({required this.user, required this.postImage, required this.caption});
}
