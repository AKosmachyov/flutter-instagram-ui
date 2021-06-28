import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:instagram_clone/models/post.dart';

import 'models/user.dart';

final String _serverPath = 'www.instagram.com';

class InstagramAPI {
  static final InstagramAPI _singleton = InstagramAPI._internal();

  factory InstagramAPI() {
    return _singleton;
  }

  InstagramAPI._internal();

  Future<List<Post>> fetchPosts() async {
    final url = Uri.https(_serverPath, '/p/CIWBNp_pDUf', {'__a': '1'});
    // return [];
    final Map<String, String> headers = {
      "accept": "*/*",
      "accept-language": "en-GB,en-US;q=0.9,en;q=0.8,ru;q=0.7",
      "cache-control": "no-cache",
      "pragma": "no-cache",
      "sec-fetch-dest": "empty",
      "sec-fetch-mode": "cors",
      "sec-fetch-site": "same-origin",
      "x-ig-app-id": "1217981644879628",
      "x-ig-www-claim": "hmac.AR3MPxXjUimvDTcb0qs9jxYifzSTVF49sxCV2NyqcG2OB-Cn",
      "x-requested-with": "XMLHttpRequest"
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return _parsePostList(json);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    return [];
  }

  List<Post> _parsePostList(Map<String, dynamic> json) {
    final media = json['graphql']['shortcode_media'] as Map<String, dynamic>;
    final mediaUrl = media['display_url'] as String;

    final owner = media['owner'] as Map<String, dynamic>;
    final username = owner['username'] as String;
    final fullName = owner['full_name'] as String;
    final userImage = owner['profile_pic_url'] as String;
    final user = User(name: fullName, nickname: username, image: userImage);

    var caption = '';
    var captionNode = media['edge_media_to_caption']['edges'][0];
    if (captionNode != null) {
      caption = captionNode['node']['text'];
    }
    final post = Post(user: user, postImage: mediaUrl, caption: caption);

    return [post];
  }

  Future<UserPageResponse> fetchUserPosts(String nickname) async {
    final url = Uri.https(_serverPath, nickname, {'__a': '1'});

    final Map<String, String> headers = {
      "accept": "*/*",
      "accept-language": "en-GB,en-US;q=0.9,en;q=0.8,ru;q=0.7",
      "cache-control": "no-cache",
      "pragma": "no-cache",
      "sec-fetch-dest": "empty",
      "sec-fetch-mode": "cors",
      "sec-fetch-site": "same-origin",
      "x-ig-app-id": "1217981644879628",
      "x-ig-www-claim": "hmac.AR3MPxXjUimvDTcb0qs9jxYifzSTVF49sxCV2NyqcG2OB-Cn",
      "x-requested-with": "XMLHttpRequest"
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return _parseUserPage(json);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw StateError('Unable to fetch user page');
    }
  }

  UserPageResponse _parseUserPage(Map<String, dynamic> json) {
    final body = json['graphql']['user'] as Map<String, dynamic>;

    final username = body['username'] as String;
    final fullName = body['full_name'] as String;
    final userImage = body['profile_pic_url'] as String;
    final user = User(name: fullName, nickname: username, image: userImage);

    final postCount = body['edge_owner_to_timeline_media']['count'].toString();
    final following = body['edge_follow']['count'].toString();
    final followers = body['edge_followed_by']['count'].toString();
    final stats = UserStats(following, postCount, followers);

    final mediaList =
        body['edge_owner_to_timeline_media']['edges'] as List<dynamic>;

    final posts = mediaList.map((el) {
      final media = el['node'] as Map<String, dynamic>;
      var caption = '';
      var captionList =
          media['edge_media_to_caption']['edges'] as List<dynamic>;
      if (captionList.isNotEmpty) {
        caption = captionList[0]['node']['text'];
      }
      final mediaUrl = media['display_url'] as String;
      return Post(user: user, postImage: mediaUrl, caption: caption);
    }).toList();
    return UserPageResponse(user, posts, stats);
  }

  Future<List<User>> search(String query) async {
    final url = Uri.https(_serverPath, 'web/search/topsearch/', {
      'context': 'blended',
      'query': query,
      'rank_token': '0.9319969569010897',
      'include_reel': 'true'
    });

    final Map<String, String> headers = {
      "accept": "*/*",
      "accept-language": "en-GB,en-US;q=0.9,en;q=0.8,ru;q=0.7",
      "cache-control": "no-cache",
      "pragma": "no-cache",
      "sec-fetch-dest": "empty",
      "sec-fetch-mode": "cors",
      "sec-fetch-site": "same-origin",
      "x-ig-app-id": "1217981644879628",
      "x-ig-www-claim": "hmac.AR3MPxXjUimvDTcb0qs9jxYifzSTVF49sxCV2NyqcG2OB-Cn",
      "x-requested-with": "XMLHttpRequest"
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return _parseUserSearch(json);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw StateError('Unable to fetch user page');
    }
  }

  List<User> _parseUserSearch(Map<String, dynamic> json) {
    final body = json['users'] as List<dynamic>;

    final users = body.map((el) {
      final info = el['user'] as Map<String, dynamic>;
      final username = info['username'] as String;
      final fullName = info['full_name'] as String;
      final userImage = info['profile_pic_url'] as String;
      return User(name: fullName, nickname: username, image: userImage);
    }).toList();

    return users;
  }
}

class UserPageResponse {
  final User user;
  final List<Post> posts;
  final UserStats stats;

  UserPageResponse(this.user, this.posts, this.stats);
}
