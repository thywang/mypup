import 'package:flutter/material.dart';
import 'package:my_pup_simple/puppy_profile/data/puppy_preferences.dart';
import 'package:my_pup_simple/src/constants/app_colors.dart';
import 'package:my_pup_simple/src/constants/app_sizes.dart';
import 'package:my_pup_simple/tip_of_the_day/data/tip_of_the_day_repository.dart';

class TipOfTheDay extends StatefulWidget {
  const TipOfTheDay({super.key});

  @override
  State<TipOfTheDay> createState() => _TipOfTheDayState();
}

class _TipOfTheDayState extends State<TipOfTheDay> {
  final puppy = PuppyPreferences.getMyPuppy();
  String tipOfTheDayDescription = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    tipOfTheDayDescription = await TipOfTheDayRepository().getTipOfTheDay();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
          'Tip of the Day',
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
          tipOfTheDayDescription,
          style: TextStyle(
            color: titleTextColorLight,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
