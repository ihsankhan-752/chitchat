import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ImageController extends ChangeNotifier {
  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  uploadImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    _selectedImage = File(pickedFile!.path);
    notifyListeners();
  }
}
