import '/models/user.dart';
import '/models/post.dart';

class UserPageResponse {
  final User user;
  final UserStats stats;
  final PostsWithPagination posts;

  const UserPageResponse(this.user, this.stats, this.posts);
}

class PostsWithPagination {
  final List<Post> posts;
  final NextPageInfo pageInfo;

  const PostsWithPagination(this.posts, this.pageInfo);
}

class NextPageInfo {
  final bool hasNext;
  final String endCursor;

  const NextPageInfo(this.hasNext, this.endCursor);

  factory NextPageInfo.fromJson(Map<String, dynamic> json) {
    final hasNext = json["has_next_page"] as bool;
    final cursor = json["end_cursor"] as String;

    return NextPageInfo(hasNext, cursor);
  }
}
