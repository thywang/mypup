import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_pup_simple/src/constants/app_colors.dart';

class ProfileWidget extends StatelessWidget {

  const ProfileWidget(
      {required this.imagePath, required this.isEdit, required this.onClicked, super.key,});
  final String imagePath;
  final bool isEdit;
  final VoidCallback onClicked;

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
          image: imagePath.isEmpty
              ? const AssetImage('assets/puppy.jpeg')
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
