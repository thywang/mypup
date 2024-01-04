import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_pup_simple/puppy_profile/model/puppy.dart';
import 'package:my_pup_simple/src/constants/strings.dart';

class PuppyPreferences {
  static late SharedPreferences _preferences;
  static const myPuppy = Puppy(
    imagePath: '',
    name: 'Miki',
    owner: 'Tim',
    birthdate: '2023-11-24',
    ageInWeeks: 8,
    growthStage: 'infancy',
  );

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<dynamic> setMyPuppy(Puppy puppy) async {
    final json = jsonEncode(puppy.toJson());

    await _preferences.setString(Strings.keyPuppy, json);
  }

  static Puppy getMyPuppy() {
    final json = _preferences.getString(Strings.keyPuppy);

    return json == null
        ? myPuppy
        : Puppy.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  static Future<bool> saveTipOfTheDay(
    String description,
    Duration expirationDuration,
  ) async {
    try {
      final expirationTime = DateTime.now().add(expirationDuration);

      await _preferences.setString(Strings.keyTipOfTheDay, description);
      await _preferences.setString(
        Strings.keyExpirationTime,
        expirationTime.toIso8601String(),
      );
      print('Tip of the day saved to Shared preferences.');
      return true;
    } catch (e) {
      print('Error saving tip of the day to SharedPreferences: $e');
      return false;
    }
  }

  static String getTipIfNotExpired() {
    try {
      final tipOfTheDay = _preferences.getString(Strings.keyTipOfTheDay);
      final expirationTimeStr =
          _preferences.getString(Strings.keyExpirationTime);

      if (tipOfTheDay == null || expirationTimeStr == null) {
        print('No data or expiration time found in SharedPreferences.');
        return '';
      }

      final expirationTime = DateTime.parse(expirationTimeStr);

      if (expirationTime.isAfter(DateTime.now())) {
        print('Tip of the day has not expired.');
        // The data has not expired.
        return tipOfTheDay;
      } else {
        // Data has expired. Remove it from SharedPreferences.
        _preferences
          ..remove(Strings.keyTipOfTheDay)
          ..remove(Strings.keyExpirationTime);
        print('Tip of the day has expired. Removed from SharedPreferences.');
        return '';
      }
    } catch (e) {
      print('Error retrieving tip from SharedPreferences: $e');
      return '';
    }
  }

  void clearTipOfTheDay() {
    try {
      _preferences
        ..remove(Strings.keyTipOfTheDay)
        ..remove(Strings.keyExpirationTime);
      print('Tip cleared from SharedPreferences.');
    } catch (e) {
      print('Error clearing tip from SharedPreferences: $e');
    }
  }
}
