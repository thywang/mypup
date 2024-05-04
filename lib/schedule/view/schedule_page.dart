import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_pup_simple/schedule/view/edit_schedule_page.dart';
import 'package:my_pup_simple/src/constants/app_colors.dart';
import 'package:my_pup_simple/src/constants/app_sizes.dart';

import 'package:my_pup_simple/src/app/view/app.dart';
import 'package:my_pup_simple/src/helpers/notify_helper.dart';
import 'package:my_pup_simple/widgets/subheader.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

List<String> daysOfTheWeek = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

class _SchedulePageState extends State<SchedulePage> {
  NotifyHelper? notifyHelper;
  int _selectedIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.5);

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper
      ?..initializeNotification()
      ..requestIOSPermissions();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        toolbarHeight: 80,
        actions: <Widget>[
          TextButton.icon(
            label: const Text(
              'Add Task',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            icon: Icon(
              Icons.add,
              color: mainAppColor,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<dynamic>(
                  builder: (context) => const EditSchedulePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: Sizes.p12, right: Sizes.p12),
        child: Column(
          children: [
            SizedBox(
              height: 70,
              child: PageView(
                padEnds: false,
                controller: _pageController,
                onPageChanged: (page) => setState(() {
                  _selectedIndex = page;
                  print(daysOfTheWeek[_selectedIndex]);
                }),
                children: <Widget>[
                  for (final (index, day) in daysOfTheWeek.indexed) ...[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOut,
                        );
                      },
                      child: Opacity(
                        opacity: index == _selectedIndex ? 1.0 : 0.5,
                        child: ColoredBox(
                          color: mainAppColor,
                          child: Padding(
                            padding: const EdgeInsets.all(Sizes.p12),
                            child: SubHeaderWidget(
                              text: day,
                              lightMode: false,
                            ),
                          ),
                        ),
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
    // return GestureDetector(
    //   child: const SizedBox(
    //     child: Text(
    //       'schedule',
    //       selectionColor: Colors.lightBlueAccent,
    //     ),
    //   ),
    //   onTap: () {
    //     notifyHelper?.scheduledNotification(
    //       title: 'schedule',
    //       body: 'this is a notification',
    //     );
    //   },
    // );
  }
}
