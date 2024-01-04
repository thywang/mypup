import 'package:flutter/material.dart';
import 'package:my_pup_simple/src/constants/app_sizes.dart';
import 'package:my_pup_simple/src/constants/app_colors.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.p8),
          ),
          foregroundColor: Colors.white,
          backgroundColor: mainAppColor,
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p32,
            vertical: Sizes.p12,
          ),
        ),
        onPressed: onClicked,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p8),
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      );
}
