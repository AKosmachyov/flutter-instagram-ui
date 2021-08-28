import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/post.dart';

class PostWidget extends StatelessWidget {
  PostWidget(this.post);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image(
                        image: NetworkImage(post.user.image),
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(post.user.nickname),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.more_horiz_outlined),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          FadeInImage(
            image: NetworkImage(post.postImage),
            placeholder: AssetImage("assets/placeholder.png"),
            width: MediaQuery.of(context).size.width,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: Icon(FontAwesomeIcons.heart),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(FontAwesomeIcons.comment),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(FontAwesomeIcons.paperPlane),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(FontAwesomeIcons.bookmark),
              ),
            ],
          ),

          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   margin: EdgeInsets.symmetric(
          //     horizontal: 14,
          //   ),
          //   child: RichText(
          //     softWrap: true,
          //     overflow: TextOverflow.visible,
          //     text: TextSpan(
          //       children: [
          //         TextSpan(
          //           text: "Liked By ",
          //           style: TextStyle(color: Colors.black),
          //         ),
          //         TextSpan(
          //           text: "Sigmund,",
          //           style: TextStyle(
          //               fontWeight: FontWeight.bold, color: Colors.black),
          //         ),
          //         TextSpan(
          //           text: " Yessenia,",
          //           style: TextStyle(
          //               fontWeight: FontWeight.bold, color: Colors.black),
          //         ),
          //         TextSpan(
          //           text: " Dayana",
          //           style: TextStyle(
          //               fontWeight: FontWeight.bold, color: Colors.black),
          //         ),
          //         TextSpan(
          //           text: " and",
          //           style: TextStyle(
          //             color: Colors.black,
          //           ),
          //         ),
          //         TextSpan(
          //           text: " 1263 others",
          //           style: TextStyle(
          //               fontWeight: FontWeight.bold, color: Colors.black),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          // caption
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 5,
            ),
            child: RichText(
              softWrap: true,
              overflow: TextOverflow.visible,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: post.user.nickname,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  TextSpan(
                    text: " ${post.caption}",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),

          // post date
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 14,
            ),
            alignment: Alignment.topLeft,
            child: Text(
              post.date,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
