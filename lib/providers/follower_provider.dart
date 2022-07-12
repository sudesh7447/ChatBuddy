import 'package:chat_buddy/models/user_model.dart';
import 'package:flutter/foundation.dart';

class FollowerProvider extends ChangeNotifier {
  List get followers => UserModel.followers;
  // int get followerLength => UserModel.followers.length;

  bool isFollowing(uid) {
    return UserModel.following.contains(uid);
  }

  void addFollower(uid) {
    UserModel.followers.add(uid);

    notifyListeners();
  }

  void deleteFollower(uid) {
    UserModel.followers.removeWhere((element) => element == uid);

    notifyListeners();
  }
}
