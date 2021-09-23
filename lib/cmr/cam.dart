import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CmKK extends ChangeNotifier {
  File file;

  Future<void> _getIm(ImageSource picker) async {
    final ImagePicker _picker = ImagePicker();
    final XFile image = await _picker.pickImage(source: picker);
    file = File(image.path);
    notifyListeners();
  }

  Future<void> pickCm() async {
    await _getIm(ImageSource.camera);
  }

  Future<void> pickGl() async {
    await _getIm(ImageSource.gallery);
  }

  void removeimage() {
    file = null;
    notifyListeners();
  }

  optionsDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: new Text('Take a picture'),
                    onTap: () async {
                      await pickCm();
                      Navigator.pop(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: new Text('Select from gallery'),
                    onTap: () async {
                      await pickGl();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
