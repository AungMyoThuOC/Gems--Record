// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable, must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

picker() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
  final XFile? images = await _picker.pickVideo(source: ImageSource.gallery);
}

String ubuntuFamily = "Ubuntu";

void showToast(BuildContext context, String massage) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      duration: (const Duration(seconds: 1)),
      content: Text(massage),
    ),
  );
}

class PreviewImageDialog extends StatelessWidget {
  String imagePath;
  PreviewImageDialog({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InteractiveViewer(
        minScale: 1,
        maxScale: 10,
        child: Image.file(
          File(imagePath),
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

errorTextWidget(errorText) {
  return Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 8),
    child: Text(
      errorText,
      style: TextStyle(
        color: Colors.red,
        fontFamily: ubuntuFamily,
      ),
    ),
  );
}
