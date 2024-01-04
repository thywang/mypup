import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_pup_simple/puppy_profile/data/puppy_preferences.dart';
import 'package:my_pup_simple/src/constants/app_sizes.dart';
import 'package:my_pup_simple/src/constants/app_colors.dart';
import 'package:my_pup_simple/src/constants/strings.dart';
import 'package:my_pup_simple/tip/tip.dart';
import 'package:my_pup_simple/tip/model/tip.dart';
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

  // Future<String> getTipOfTheDay() async {
  //   try {
  //     final db = FirebaseFirestore.instance;
  //     final tips = db.collection('generalTips');
  //     final key = tips.doc().id;
  //     String description;
  //     var snapshot = await tips
  //         .withConverter(
  //           fromFirestore: Tip.fromFirestore,
  //           toFirestore: (Tip tip, _) => tip.toFirestore(),
  //         )
  //         .where(puppy.growthStage, isEqualTo: true)
  //         .where(FieldPath.documentId, isGreaterThanOrEqualTo: key)
  //         .limit(1)
  //         .get();
  //     if (snapshot.size > 0) {
  //       description = snapshot.docs[0].data().description;
  //     } else {
  //       snapshot = await tips
  //           .withConverter(
  //             fromFirestore: Tip.fromFirestore,
  //             toFirestore: (Tip tip, _) => tip.toFirestore(),
  //           )
  //           .where(puppy.growthStage, isEqualTo: true)
  //           .where(FieldPath.documentId, isGreaterThanOrEqualTo: key)
  //           .limit(1)
  //           .get();
  //       if (snapshot.size > 0) {
  //         description = snapshot.docs[0].data().description;
  //       } else {
  //         description = 'Check out the personalized tips in Tips for You.';
  //       }
  //     }
  //     return description;
  //   } catch (e) {
  //     return 'Error fetching Tip of the Day.';
  //   }
  // }

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
