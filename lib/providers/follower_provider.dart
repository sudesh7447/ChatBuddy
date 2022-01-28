import 'package:flutter/foundation.dart';

class FollowerProvider extends ChangeNotifier {
  final List _followers = [];

  List get followers => _followers;

  void addFollower(uid) {
    _followers.add(uid);

    notifyListeners();
  }

  void deleteFollower(uid) {
    _followers.removeWhere((element) => element == uid);

    notifyListeners();
  }
}
