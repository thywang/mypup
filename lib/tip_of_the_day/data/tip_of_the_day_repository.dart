import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:my_pup_simple/puppy_profile/data/puppy_preferences.dart';
import 'package:my_pup_simple/tip/model/tip.dart';

class TipOfTheDayRepository {
  final puppy = PuppyPreferences.getMyPuppy();

  Future<String> getTipOfTheDay() async {
    try {
      final description = PuppyPreferences.getTipIfNotExpired();
      if (description.isNotEmpty) {
        return description;
      } else {
        await fetchAndCacheTipOfTheDay();
        return PuppyPreferences.getTipIfNotExpired();
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<String> fetchAndCacheTipOfTheDay() async {
    debugPrint('fetchAndCacheTipOfTheDay');
    try {
      final db = FirebaseFirestore.instance;
      final tips = db.collection('generalTips');
      final key = tips.doc().id;
      String description;
      var snapshot = await tips
          .withConverter(
            fromFirestore: Tip.fromFirestore,
            toFirestore: (Tip tip, _) => tip.toFirestore(),
          )
          .where(puppy.growthStage, isEqualTo: true)
          .where(FieldPath.documentId, isGreaterThanOrEqualTo: key)
          .limit(1)
          .get();
      if (snapshot.size > 0) {
        description = snapshot.docs[0].data().description;
      } else {
        snapshot = await tips
            .withConverter(
              fromFirestore: Tip.fromFirestore,
              toFirestore: (Tip tip, _) => tip.toFirestore(),
            )
            .where(puppy.growthStage, isEqualTo: true)
            .where(FieldPath.documentId, isGreaterThanOrEqualTo: key)
            .limit(1)
            .get();
        if (snapshot.size > 0) {
          description = snapshot.docs[0].data().description;
        } else {
          description = 'Check out the personalized tips in Tips for You.';
        }
      }

      final isSaved = await PuppyPreferences.saveTipOfTheDay(
        description,
        const Duration(days: 1),
      );

      if (isSaved) {
        return description;
      } else {
        throw Exception('Failed to cache tip of the day.');
      }
    } catch (e) {
      return 'Error fetching Tip of the Day.';
    }
  }
}
