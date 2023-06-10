import 'dart:io';

import 'package:image/image.dart' as img;

class ImageProcessor {
  static Future<File?> resizeImage(File file) async {
    try {
      final image = img.decodeImage(await file.readAsBytes());
      final resizedImage = img.copyResize(image!, width: 250, height: 250);

      final resizedFile = File(file.path);
      resizedFile.writeAsBytesSync(img.encodeJpg(resizedImage, quality: 100));

      print("Success");
      return resizedFile;
    } catch (exception) {
      return null;
    }
  }
}
