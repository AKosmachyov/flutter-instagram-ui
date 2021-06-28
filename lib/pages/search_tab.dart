import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram_clone/instagramAPI.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/pages/user_page.dart';
import 'package:instagram_clone/widgets/user_row.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  late StreamController<List<User>> _userSearchStream;
  late String _terms = '';

  @override
  void initState() {
    super.initState();
    _userSearchStream = StreamController<List<User>>();
  }

  void _search(String terms) {
    setState(() {
      _terms = terms;
    });
    if (terms.length > 2) {
      InstagramAPI()
          .search(terms)
          .then((value) => _userSearchStream.add(value));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildFloatingSearchBar(),
    );
  }

  Widget _buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: 'Search...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        _search(query);
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
              color: Colors.white,
              elevation: 4.0,
              child: StreamBuilder<List<User>>(
                stream: _userSearchStream.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: snapshot.data!
                            .map((e) => buildRowResult(e))
                            .toList());
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  if (_terms.length < 2) {
                    return Center();
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )),
        );
      },
    );
  }

  Widget buildRowResult(User user) {
    return GestureDetector(
      child: UserRowWidget(user),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserPage(
                nickname: user.nickname,
                withNavigation: true,
              ),
            ));
      },
    );
  }
}
