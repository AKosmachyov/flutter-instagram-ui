import 'package:flutter/material.dart';

class SmallAvatarWidget extends StatelessWidget {
  final String? url;
  SmallAvatarWidget(this.url);

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return CircleAvatar(
        backgroundImage: AssetImage("assets/placeholder.png"),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: FadeInImage(
        image: NetworkImage(url!),
        placeholder: AssetImage("assets/placeholder.png"),
        width: 40,
        height: 40,
        fit: BoxFit.cover,
      ),
    );
  }
}
