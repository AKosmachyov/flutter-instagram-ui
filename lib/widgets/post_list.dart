import 'package:flutter/widgets.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/widgets/post.dart';

class PostListWidget extends StatelessWidget {
  final List<Post> posts;

  PostListWidget(this.posts);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: posts.length,
        itemBuilder: (ctx, i) {
          return PostWidget(posts[i]);
        },
      ),
    );
  }
}
