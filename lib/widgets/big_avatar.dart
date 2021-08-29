import 'package:flutter/material.dart';

class BigAvatarWidget extends StatelessWidget {
  final String? url;
  BigAvatarWidget(this.url);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: FadeInImage(
                image: NetworkImage(url ?? ''),
                placeholder: AssetImage("assets/placeholder.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            child: ClipOval(
              child: Container(
                decoration: ShapeDecoration(
                    color: Colors.blueAccent,
                    shape: CircleBorder(
                      side: Divider.createBorderSide(context,
                          width: 2, color: Theme.of(context).cardColor),
                    )),
                padding: EdgeInsets.all(2),
                alignment: Alignment.center,
                child: Icon(
                  Icons.add,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
            right: 0,
            bottom: 0,
          )
        ],
      ),
    );
  }
}
