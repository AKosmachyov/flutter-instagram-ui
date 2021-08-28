import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '/api/classes.dart';
import '/api/instagramAPI.dart';
import '/models/user.dart';
import '/widgets/big_avatar.dart';
import '/widgets/post_list.dart';

class UserPage extends StatefulWidget {
  final String nickname;
  final bool withNavigation;

  const UserPage(
      {Key? key, required this.nickname, this.withNavigation = false})
      : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late Future<UserPageResponse> futurePageContent;

  @override
  void initState() {
    super.initState();
    futurePageContent = InstagramAPI().fetchUserPosts(widget.nickname);
  }

  @override
  Widget build(BuildContext context) {
    return widget.withNavigation
        ? Scaffold(
            backgroundColor: Color(0xFFEEEEEE),
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              elevation: 0,
              backgroundColor: Color(0xFFEEEEEE),
              brightness: Brightness.light,
              centerTitle: true,
              title: Text(
                widget.nickname,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            body: builPageBody(),
          )
        : builPageBody();
  }

  Widget builPageBody() {
    return FutureBuilder<UserPageResponse>(
      future: futurePageContent,
      builder: (context, snapshot) {
        List<Widget> content = [
          const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()))
        ];
        if (snapshot.hasData) {
          final pageData = snapshot.data!;
          content = [
            SliverList(
                delegate: SliverChildListDelegate(
              [
                Divider(),
                buildUserInfo(pageData.user, pageData.stats),
              ],
            )),
            PostListWidget(
              posts: pageData.posts.posts,
              pageInfo: pageData.posts.pageInfo,
            ),
          ];
        } else if (snapshot.hasError) {
          content = [
            SliverToBoxAdapter(
                child: Center(child: Text(snapshot.error.toString())))
          ];
        }

        return CustomScrollView(
          slivers: content,
        );
      },
    );
  }

  Widget buildUserInfo(User user, UserStats stats) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              BigAvatarWidget(user.image),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  user.name ?? user.nickname,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              )
            ],
          ),
          Expanded(
              child: Container(
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                Expanded(
                    child: ColumnTextWidget(
                  title: stats.posts,
                  content: 'Post',
                )),
                Expanded(
                    child: ColumnTextWidget(
                  title: stats.followers,
                  content: 'Followers',
                )),
                Expanded(
                  child: ColumnTextWidget(
                    title: stats.following,
                    content: 'Following',
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
    //   Container(
    //     width: double.infinity,
    //     padding: EdgeInsets.symmetric(
    //       horizontal: 16,
    //     ),
    //     child: Text('Mastering B&W: The Art of B&W \nEditor: @dangngocduc Mod: @dangngocduc @dangngocduc \nFounder: @dangngocduc',
    //       style: Theme.of(context).textTheme.bodyText1,),
    //   )
    // );
  }
}

class ColumnTextWidget extends StatelessWidget {
  final String title;
  final String content;

  ColumnTextWidget({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .subtitle2
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          Padding(
            padding: EdgeInsets.only(top: 2),
            child: Text(
              content,
              style:
                  Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 13),
            ),
          )
        ],
      ),
    );
  }
}
