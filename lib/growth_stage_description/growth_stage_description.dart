import 'package:flutter/material.dart';
import 'package:my_pup_simple/puppy_profile/data/puppy_preferences.dart';
import 'package:my_pup_simple/src/constants/app_colors.dart';
import 'package:my_pup_simple/src/constants/app_sizes.dart';
import 'package:my_pup_simple/src/constants/maps.dart';

class GrowthStageDescription extends StatelessWidget {
  const GrowthStageDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final puppy = PuppyPreferences.getMyPuppy();

    return ListTile(
      tileColor: mainAppColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.p16),
      ),
      title: Padding(
        padding: const EdgeInsets.only(
          top: Sizes.p12,
          bottom: Sizes.p12,
        ),
        child: Text(
          Maps.growthStageDescriptions[puppy.growthStage]?.first ?? 'infancy',
          style: TextStyle(
            color: titleTextColorLight,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(
          bottom: Sizes.p8,
        ),
        child: Text(
          Maps.growthStageDescriptions[puppy.growthStage]?.last ??
              Maps.growthStageDescriptions.entries.first.value.last,
          style: TextStyle(
            color: titleTextColorLight,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
