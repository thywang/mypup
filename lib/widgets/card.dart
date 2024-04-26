import 'package:flutter/material.dart';
import 'package:my_pup_simple/src/constants/app_colors.dart';
import 'package:my_pup_simple/src/constants/app_sizes.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    required this.name, required this.mainColor, required this.iconData, super.key,
  });

  final String name;
  final Color mainColor;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.p32),
      ),
      color: mainColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(
            width: 200,
            height: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    left: Sizes.p16,
                  ),
                  child: Icon(
                    iconData,
                    color: titleTextColorLight,
                    size: Sizes.p32,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(
                    Sizes.p16,
                  ),
                  child: Text(
                    name,
                    style: TextStyle(
                      color: titleTextColorLight,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Roboto',
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
