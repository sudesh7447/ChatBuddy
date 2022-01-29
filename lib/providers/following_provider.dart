import 'package:chat_buddy/models/user_model.dart';
import 'package:flutter/foundation.dart';

class FollowingProvider extends ChangeNotifier {
  List get following => UserModel.following;
  int get followingLength => UserModel.following.length;

  void addFollowing(uid) {
    UserModel.following.add(uid);

    notifyListeners();
  }

  void deleteFollowing(uid) {
    UserModel.following.removeWhere((element) => element == uid);

    notifyListeners();
  }
}
