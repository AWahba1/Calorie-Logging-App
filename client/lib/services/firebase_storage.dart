import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class FirebaseStorageService {
  // Uploads an image file to Firebase Storage and returns the download URL
  static Future<String?> uploadImageToFirebase(File imageFile) async {
    DateTime startTime = DateTime.now();

    late Reference storageReference;
    try {
      String fileName = basename(imageFile.path);
      storageReference =
          FirebaseStorage.instance.ref().child('images/$fileName');

      await storageReference.putFile(imageFile);
    } catch (e) {
      return null;
    }
    print("Upload Done!");
    DateTime endTime = DateTime.now();

    print("Upload time: ${endTime.difference(startTime).inSeconds} seconds");

    return storageReference.getDownloadURL();
  }
}
