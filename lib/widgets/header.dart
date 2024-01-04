import 'package:flutter/material.dart';
import 'package:my_pup_simple/src/constants/app_colors.dart';

class HeaderWidget extends StatelessWidget {
  final String text;

  const HeaderWidget({Key? key, required this.text}) : super(key: key);

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
