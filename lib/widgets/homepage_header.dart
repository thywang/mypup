import 'package:flutter/material.dart';
import 'package:my_pup_simple/puppy_profile/data/puppy_preferences.dart';
import 'package:my_pup_simple/src/constants/app_colors.dart';
import 'package:my_pup_simple/src/constants/app_sizes.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final puppy = PuppyPreferences.getMyPuppy();

    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  'Hello, ${puppy.owner}.',
                  style: TextStyle(
                    color: titleTextColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Roboto',
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          gapH20,
          Row(
            children: [
              Flexible(
                child: Text(
                  'Your pup ${puppy.name} is ${puppy.ageInWeeks} weeks old.',
                  style: TextStyle(
                    color: titleTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
