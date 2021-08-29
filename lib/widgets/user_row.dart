import 'package:flutter/widgets.dart';
import '/widgets/small_avatar.dart';
import '/models/user.dart';

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
              SmallAvatarWidget(user.image),
              SizedBox(
                width: 10,
              ),
              Text(user.nickname),
            ],
          )
        ]);
  }
}
