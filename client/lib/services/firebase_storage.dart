import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class FirebaseStorageService {
  // Uploads an image file to Firebase Storage and returns the download URL
  static Future<String?> uploadImage(File imageFile) async {
    String fileName = basename(imageFile.path);

    Reference storageReference =
        FirebaseStorage.instance.ref().child('images/$fileName');

    try {
      await storageReference.putFile(imageFile);
    } catch (e) {
      return null;
    }
    print("Upload Done!");
    return storageReference.getDownloadURL();
  }
}
