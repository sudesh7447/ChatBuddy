import 'package:flutter/foundation.dart';

class FollowingProvider extends ChangeNotifier {
  final List _following = [];

  List get following => _following;

  void addFollower(uid) {
    _following.add(uid);

    notifyListeners();
  }

  void deleteFollower(uid) {
    _following.removeWhere((element) => element == uid);

    notifyListeners();
  }
}
