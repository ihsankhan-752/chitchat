import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class storageServices {
  Future<String> uploadPhoto(File? image) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = await storage.ref().child(DateTime.now().millisecondsSinceEpoch.toString());
    await reference.putFile(image!);
    String url = await reference.getDownloadURL();
    return url;
  }
}
