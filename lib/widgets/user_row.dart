import 'package:flutter/widgets.dart';
import 'package:instagram_clone/models/user.dart';

class UserRowWidget extends StatelessWidget {
  final User user;

  UserRowWidget(this.user);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image(
                  image: NetworkImage(user.image),
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(user.nickname),
            ],
          )
        ]);
  }
}
