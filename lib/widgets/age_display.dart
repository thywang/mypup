import 'package:flutter/material.dart';
import 'package:my_pup_simple/src/constants/app_sizes.dart';
import 'package:my_pup_simple/src/helpers/calculate_time_between.dart';

class AgeDisplay extends StatelessWidget {
  final String birthdate;

  const AgeDisplay({
    Key? key,
    required this.birthdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeSince =
        CalculateTimeBetween.monthsWeeksDaysSince(DateTime.parse(birthdate));
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildAgeComponent(context, '${timeSince[0]}', 'Months'),
          buildDivider(),
          buildAgeComponent(context, '${timeSince[1]}', 'Weeks'),
          buildDivider(),
          buildAgeComponent(context, '${timeSince[2]}', 'Days'),
        ],
      ),
    );
  }

  Widget buildDivider() => const SizedBox(height: 24, child: VerticalDivider());
  Widget buildAgeComponent(BuildContext context, String value, String text) =>
      SizedBox(
        width: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            gapH2,
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
}
