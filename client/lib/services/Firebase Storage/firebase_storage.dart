import 'dart:io';
import 'package:client/services/Firebase%20Storage/image_processing.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class FirebaseStorageService {
  // Uploads an image file to Firebase Storage and returns the download URL
  static Future<String?> uploadImageToFirebase(File imageFile) async {
    DateTime startTime = DateTime.now();

    late Reference storageReference;
    try {
      final resizedFile = await ImageProcessor.resizeImage(imageFile);
      String fileName = basename(imageFile.path);
      storageReference =
          FirebaseStorage.instance.ref().child('images/$fileName');

      final fileToUpload = resizedFile ?? imageFile;
      await storageReference.putFile(fileToUpload);
    } catch (e) {
      print(e);
      return null;
    }
    print("Upload Done!");
    DateTime endTime = DateTime.now();

    print("Upload time: ${endTime.difference(startTime).inSeconds} seconds");

    return storageReference.getDownloadURL();
  }
}
