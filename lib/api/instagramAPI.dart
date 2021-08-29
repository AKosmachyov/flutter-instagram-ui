import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import '/models/post.dart';
import '/models/user.dart';
import 'classes.dart';

final String _serverPath = 'instagram.com';
final String _serverPathCDN = 'i.instagram.com';

class InstagramAPI {
  static final InstagramAPI _singleton = InstagramAPI._internal();

  factory InstagramAPI() {
    return _singleton;
  }

  InstagramAPI._internal();

  Future<PostsWithPagination> fetchVisualArtsPosts({String? rankToken}) async {
    final url = Uri.https(
      _serverPathCDN,
      'api/v1/directory/visual-arts/media/',
      rankToken == null ? null : {'rank_token': rankToken},
    );
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
    };

    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return parseVisualArtPosts(json);
    } else {
      throw StateError('Unable to fetch posts');
    }
  }

  PostsWithPagination parseVisualArtPosts(Map<String, dynamic> json) {
    final imageList = json['media'] as List<dynamic>;
    final posts = imageList.map((el) {
      final post = el as Map<String, dynamic>;
      final owner = post['user'] as Map<String, dynamic>;
      final postUser = User.fromJson(owner);

      var postDate = (post['taken_at'] as int) * 1000;
      final date = new DateTime.fromMillisecondsSinceEpoch(postDate);
      final dateWithFormat = DateFormat.yMMMMd().format(date);

      var caption = post['caption']['text'] as String;

      var imageConfiguration =
          post['image_versions2']['candidates'] as List<dynamic>;
      var image = imageConfiguration.firstWhere(
          (element) => element['width'] == 750 && element['height'] == 750);

      return Post(
        user: postUser,
        postImage: image['url'] as String,
        caption: caption,
        date: dateWithFormat,
      );
    }).toList();

    final nextPageInfo = NextPageInfo(
      json['more_available'] as bool,
      json['rank_token'] as String,
    );
    return PostsWithPagination(posts, nextPageInfo);
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

    final user = User.fromJson(body);

    final postCount = body['edge_owner_to_timeline_media']['count'].toString();
    final following = body['edge_follow']['count'].toString();
    final followers = body['edge_followed_by']['count'].toString();
    final stats = UserStats(following, postCount, followers);

    final posts = parsePosts(body['edge_owner_to_timeline_media'], user: user);
    return UserPageResponse(user, stats, posts);
  }

  PostsWithPagination parsePosts(Map<String, dynamic> json, {User? user}) {
    final imagePageInfo =
        NextPageInfo.fromJson(json['page_info'] as Map<String, dynamic>);
    final imageList = json['edges'] as List<dynamic>;

    final posts = imageList.map((el) {
      final media = el['node'] as Map<String, dynamic>;
      var caption = '';
      var captionList =
          media['edge_media_to_caption']['edges'] as List<dynamic>;
      if (captionList.isNotEmpty) {
        caption = captionList[0]['node']['text'];
      }
      final mediaUrl = media['display_url'] as String;
      final owner = media['owner'] as Map<String, dynamic>;
      final postUser = user ?? User.fromJson(owner);

      var postDate = (media['taken_at_timestamp'] as int) * 1000;
      final date = new DateTime.fromMillisecondsSinceEpoch(postDate);
      final dateWithFormat = DateFormat.yMMMMd().format(date);
      return Post(
        user: postUser,
        postImage: mediaUrl,
        caption: caption,
        date: dateWithFormat,
      );
    }).toList();

    return PostsWithPagination(posts, imagePageInfo);
  }

  Future<PostsWithPagination> fetchPostWithPagination(
      String id, String after) async {
    final variableField =
        '{"id":"' + id + '","first":12,"after":"' + after + '"}';
    final url = Uri.https(_serverPath, '/graphql/query/', {
      'query_hash': '8c2a529969ee035a5063f2fc8602a0fd',
      'variables': variableField
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
      final media = json['data']['user']['edge_owner_to_timeline_media']
          as Map<String, dynamic>;
      return parsePosts(media);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw StateError('Unable to fetch posts');
    }
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
      final id = info['pk'] as String;
      final username = info['username'] as String;
      final fullName = info['full_name'] as String;
      final userImage = info['profile_pic_url'] as String;
      return User(id: id, name: fullName, nickname: username, image: userImage);
    }).toList();

    return users;
  }
}
