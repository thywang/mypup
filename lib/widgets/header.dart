import 'package:flutter/material.dart';
import 'package:my_pup_simple/src/constants/app_colors.dart';

class HeaderWidget extends StatelessWidget {

  const HeaderWidget({required this.text, super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            color: titleTextColor,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}
