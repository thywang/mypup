import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_pup_simple/src/constants/app_sizes.dart';
import 'package:my_pup_simple/src/constants/app_colors.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final bool isEdit;
  final VoidCallback onClicked;

  const ProfileWidget(
      {Key? key,
      required this.imagePath,
      required this.isEdit,
      required this.onClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(bottom: 0, right: 4, child: buildEditIcon(mainAppColor)),
        ],
      ),
    );
  }

  Widget buildImage() {
    final imgFile = File(imagePath);
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: imgFile == null
              ? AssetImage(imagePath)
              : FileImage(imgFile) as ImageProvider,
          fit: BoxFit.cover,
          width: 150,
          height: 150,
          child: InkWell(onTap: onClicked),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => CircleAvatar(
        radius: 22,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 20,
          backgroundColor: color,
          child: isEdit
              ? const Icon(Icons.camera_alt, size: 20)
              : const Icon(Icons.edit, size: 20),
        ),
      );
}
