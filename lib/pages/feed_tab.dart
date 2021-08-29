import 'package:flutter/material.dart';
import '/api/classes.dart';
import '/widgets/post_list.dart';
import '/api/instagramAPI.dart';
import '/models/story.dart';

class FeedTab extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<FeedTab> {
  late Future<PostsWithPagination> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = InstagramAPI().fetchVisualArtsPosts();
  }

  List<Story> _stories = [
    Story(
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "Jazmin"),
    Story(
        "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "Sylvester"),
    Story(
        "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "Lavina"),
    Story(
        "https://images.pexels.com/photos/1124724/pexels-photo-1124724.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "Mckenzie"),
    Story(
        "https://images.pexels.com/photos/1845534/pexels-photo-1845534.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "Buster"),
    Story(
        "https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "Carlie"),
    Story(
        "https://images.pexels.com/photos/762020/pexels-photo-762020.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "Edison"),
    Story(
        "https://images.pexels.com/photos/573299/pexels-photo-573299.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "Flossie"),
    Story(
        "https://images.pexels.com/photos/756453/pexels-photo-756453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "Lindsey"),
    Story(
        "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "Freddy"),
    Story(
        "https://images.pexels.com/photos/1832959/pexels-photo-1832959.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "Litzy")
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PostsWithPagination>(
      future: futurePosts,
      builder: (context, snapshot) {
        List<Widget> content = [
          const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()))
        ];
        if (snapshot.hasData) {
          final pageData = snapshot.data!;
          content = [
            SliverToBoxAdapter(child: Divider()),
            PostListWidget(
              posts: pageData.posts,
              pageInfo: pageData.pageInfo,
              loadMore: (String token) {
                return InstagramAPI().fetchVisualArtsPosts(rankToken: token);
              },
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

    //   return Container(
    //     child: SingleChildScrollView(
    //       child: Column(
    //         children: <Widget>[
    //           Divider(),
    //           Container(
    //             margin: EdgeInsets.symmetric(
    //               horizontal: 20,
    //             ),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: <Widget>[
    //                 Text(
    //                   "Stories",
    //                   style: TextStyle(
    //                     fontSize: 14,
    //                   ),
    //                 ),
    //                 Text(
    //                   "Watch All",
    //                   style: TextStyle(
    //                     fontSize: 14,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           Container(
    //             width: MediaQuery.of(context).size.width,
    //             margin: EdgeInsets.symmetric(
    //               vertical: 10,
    //             ),
    //             height: 110,
    //             child: ListView(
    //               scrollDirection: Axis.horizontal,
    //               shrinkWrap: true,
    //               children: _stories.map((story) {
    //                 return Column(
    //                   children: <Widget>[
    //                     Container(
    //                       margin: EdgeInsets.symmetric(
    //                         horizontal: 15,
    //                       ),
    //                       decoration: BoxDecoration(
    //                         borderRadius: BorderRadius.circular(70),
    //                         border: Border.all(
    //                           width: 3,
    //                           color: Color(0xFF8e44ad),
    //                         ),
    //                       ),
    //                       child: Container(
    //                         padding: EdgeInsets.all(
    //                           2,
    //                         ),
    //                         child: ClipRRect(
    //                           borderRadius: BorderRadius.circular(70),
    //                           child: Image(
    //                             image: NetworkImage(story.image),
    //                             width: 70,
    //                             height: 70,
    //                             fit: BoxFit.cover,
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       height: 10,
    //                     ),
    //                     Text(story.name),
    //                   ],
    //                 );
    //               }).toList(),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
  }
}
