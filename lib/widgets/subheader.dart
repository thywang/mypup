import 'package:flutter/material.dart';
import 'package:my_pup_simple/src/constants/app_colors.dart';

class SubHeaderWidget extends StatelessWidget {

  const SubHeaderWidget({required this.text, this.lightMode = true, super.key});
  final String text;
  final bool lightMode;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            color: lightMode ? titleTextColor : titleTextColorLight,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}
