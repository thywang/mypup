import 'package:flutter/material.dart';
import 'package:my_pup_simple/growth_stage_description/growth_stage_description.dart';
import 'package:my_pup_simple/puppy_profile/data/puppy_preferences.dart';
import 'package:my_pup_simple/src/constants/app_colors.dart';
import 'package:my_pup_simple/src/constants/app_sizes.dart';
import 'package:my_pup_simple/widgets/card.dart';
import 'package:my_pup_simple/widgets/homepage_header.dart';
import 'package:my_pup_simple/tip/tip.dart';
import 'package:my_pup_simple/tip_of_the_day/tip_of_the_day.dart';
import 'package:my_pup_simple/widgets/subheader.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

Map<String, List<Object>> tipCategories = {
  'General': [generalColor, Icons.pets],
  'Training': [trainingColor, Icons.record_voice_over],
  'Health': [healthColor, Icons.favorite],
  'Games': [gameColor, Icons.sports_baseball],
};

class _DashboardPageState extends State<DashboardPage> {
  final puppy = PuppyPreferences.getMyPuppy();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Sizes.p32),
        child: Column(
          children: <Widget>[
            const HomeHeaderWidget(),
            gapH32,
            const GrowthStageDescription(),
            gapH16,
            const TipOfTheDay(),
            gapH32,
            const SubHeaderWidget(
              text: 'Tips for You',
            ),
            gapH12,
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final tipCategory in tipCategories.entries) ...[
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<dynamic>(
                            builder: (context) => TipPage(
                              name: tipCategory.key,
                              mainColor: tipCategory.value.first as Color,
                            ),
                          ),
                        );
                      },
                      child: CustomCard(
                        name: tipCategory.key,
                        mainColor: tipCategory.value.first as Color,
                        iconData: tipCategory.value.last as IconData,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
