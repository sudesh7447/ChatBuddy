import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseUpload {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: 'error while upload ${e.message}');
      return null;
    }
  }
}

class FirebaseStorageMethods {
  Future<void> deleteImage(imageUrl) async {
    if (imageUrl != '') {
      Reference reference = FirebaseStorage.instance.refFromURL(imageUrl);

      print(reference.fullPath);

      await reference.delete();

      print('Image deleted successfully');
    }
  }
}
