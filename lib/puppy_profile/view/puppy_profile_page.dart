import 'package:flutter/material.dart';
import 'package:my_pup_simple/puppy_profile/puppy_profile.dart';
import 'package:my_pup_simple/src/constants/app_sizes.dart';
import 'package:my_pup_simple/puppy_profile/data/puppy_preferences.dart';
import 'package:my_pup_simple/widgets/profile.dart';
import 'package:my_pup_simple/widgets/age_display.dart';

class PuppyProfilePage extends StatefulWidget {
  const PuppyProfilePage({Key? key}) : super(key: key);

  @override
  State<PuppyProfilePage> createState() => _PuppyProfilePageState();
}

class _PuppyProfilePageState extends State<PuppyProfilePage> {
  @override
  Widget build(BuildContext context) {
    final puppy = PuppyPreferences.getMyPuppy();

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: puppy.imagePath,
            isEdit: false,
            onClicked: () async {
              await Navigator.of(context).push(
                MaterialPageRoute<dynamic>(
                  builder: (context) => const EditPuppyProfilePage(),
                ),
              );
              setState(() {});
            },
          ),
          gapH24,
          Text(
            puppy.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          gapH24,
          AgeDisplay(birthdate: puppy.birthdate),
        ],
      ),
    );
  }
}
