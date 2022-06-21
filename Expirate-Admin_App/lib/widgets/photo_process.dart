import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class PhotoProcessHome extends StatefulWidget {
  const PhotoProcessHome({Key? key}) : super(key: key);

  @override
  State<PhotoProcessHome> createState() => _PhotoProcessHomeState();
}

class _PhotoProcessHomeState extends State<PhotoProcessHome> {
  File? _choosenPhoto;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircleAvatar(
        child: Text("Photo"),
        radius: 65,
      ),
    );
  }
}

