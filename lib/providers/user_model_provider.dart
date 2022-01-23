import 'package:chat_buddy/models/user_model.dart';
import 'package:flutter/foundation.dart';

class UserModelProvider extends ChangeNotifier {
  // String _name = UserModel.fullName.toString();
  // String _bio = UserModel.bio.toString();
  // String _imageUrl = UserModel.imageUrl.toString();

  String get fullName => UserModel.fullName.toString();
  String get bio => UserModel.bio.toString();
  String get imageUrl => UserModel.imageUrl.toString();
  String get dob => UserModel.dob.toString();

  void updateName(newName) {
    UserModel.fullName = newName;

    notifyListeners();
  }

  void updateBio(newBio) {
    UserModel.bio = newBio;

    notifyListeners();
  }

  void updateImageUrl(newImageUrl) {
    UserModel.imageUrl = newImageUrl;

    notifyListeners();
  }

  void updateDob(newDob) {
    UserModel.dob = newDob;

    notifyListeners();
  }
}
