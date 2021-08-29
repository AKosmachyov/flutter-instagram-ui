import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '/api/classes.dart';
import '/widgets/post.dart';
import '/models/post.dart';

class PostListWidget extends StatefulWidget {
  final List<Post> posts;
  final NextPageInfo? pageInfo;
  final Future<PostsWithPagination> Function(String nextCursor)? loadMore;

  PostListWidget({
    Key? key,
    required this.posts,
    this.pageInfo,
    this.loadMore,
  }) : super(key: key);

  @override
  _PostListWidgetState createState() => _PostListWidgetState();
}

class _PostListWidgetState extends State<PostListWidget> {
  List<Post> renderPosts = [];
  String? nextCursor;

  @override
  void initState() {
    renderPosts.addAll(widget.posts);
    nextCursor = widget.pageInfo?.endCursor ?? null;
    super.initState();
  }

  _fetchNextPage() {
    if (nextCursor == null && widget.loadMore != null) {
      return;
    }

    widget.loadMore!(nextCursor!).then(
      (value) => setState(() {
        renderPosts.addAll(value.posts);
        nextCursor = value.pageInfo.endCursor;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    int itemCount = renderPosts.length;
    if (nextCursor != null) {
      itemCount += 1;
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int i) {
          if (i >= renderPosts.length) {
            _fetchNextPage();
            return Container(
              padding: const EdgeInsets.all(16),
              child: const Center(
                child: const CircularProgressIndicator(),
              ),
            );
          }

          return PostWidget(renderPosts[i]);
        },
        childCount: itemCount,
      ),
    );
  }
}
