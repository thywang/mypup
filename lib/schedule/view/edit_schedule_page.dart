import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:my_pup_simple/src/constants/app_colors.dart';
import 'package:my_pup_simple/src/constants/app_sizes.dart';
import 'package:my_pup_simple/widgets/button.dart';
import 'package:my_pup_simple/widgets/subheader.dart';
import 'package:my_pup_simple/widgets/text_field.dart';

class EditSchedulePage extends StatefulWidget {
  const EditSchedulePage({super.key});

  @override
  State<EditSchedulePage> createState() => _EditSchedulePageState();
}

class _EditSchedulePageState extends State<EditSchedulePage> {
  final today = DateTime.now();
  var _startTime = DateFormat('h:mm a').format(DateTime.now());
  var _endTime =
      DateFormat('h:mm a').format(DateTime.now().add(const Duration(hours: 1)));

  // reminder in minutes
  var _selectRemind = 5;
  List<int> remindList = [5, 10, 15, 20];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          alignment: Alignment.centerLeft,
          onPressed: () {
            // Navigate back to the previous screen by popping the current route
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p32),
        child: Column(
          children: [
            const SubHeaderWidget(text: 'Add Task'),
            gapH24,
            TextFieldWidget(
              label: 'Title',
              hint: 'Enter your title',
              onChanged: (title) => {},
            ),
            gapH24,
            TextFieldWidget(
              label: 'Note',
              hint: 'Enter your note',
              onChanged: (note) => {},
            ),
            gapH24,
            Row(
              children: [
                Expanded(
                  child: TextFieldWidget(
                    label: 'Start Time',
                    hint: _startTime,
                    trailingWidget: IconButton(
                      onPressed: () async =>
                          _getTimeFromUser(isStartTime: true),
                      iconSize: Sizes.p32,
                      icon: Icon(
                        Icons.access_time_rounded,
                        color: mainAppColor,
                      ),
                    ),
                  ),
                ),
                gapW12,
                Expanded(
                  child: TextFieldWidget(
                    label: 'End Time',
                    hint: _endTime,
                    trailingWidget: IconButton(
                      onPressed: () async =>
                          _getTimeFromUser(isStartTime: false),
                      iconSize: Sizes.p32,
                      icon: Icon(
                        Icons.access_time_rounded,
                        color: mainAppColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            gapH24,
            TextFieldWidget(
              label: 'Reminder',
              hint: '$_selectRemind minutes before',
              trailingWidget: DropdownButton(
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: grayTextColor,
                ),
                iconSize: Sizes.p32,
                underline: Container(
                  height: 0,
                ),
                items: remindList.map<DropdownMenuItem<String>>((int value) {
                  return DropdownMenuItem(
                    value: value.toString(),
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue == null) return;
                  setState(() {
                    _selectRemind = int.parse(newValue);
                  });
                },
              ),
            ),
            gapH24,
            ButtonWidget(
              text: 'Create Task',
              onClicked: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getTimeFromUser({required bool isStartTime}) async {
    final pickedTime = await _showTimePicker(isStartTime: isStartTime);
    if (pickedTime == null) {
      debugPrint('Time cancelled');
      return;
    }
    final formattedTime = pickedTime.format(context);
    if (isStartTime) {
      setState(() {
        _startTime = formattedTime;
      });
    } else {
      setState(() {
        _endTime = formattedTime;
      });
    }
  }

  Future<TimeOfDay?> _showTimePicker({required bool isStartTime}) {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        // _startTime example format is 12:30 PM
        hour: isStartTime
            ? int.parse(_startTime.split(':')[0])
            : int.parse(_endTime.split(':')[0]),
        minute: isStartTime
            ? int.parse(_startTime.split(':')[1].split(' ')[0])
            : int.parse(_endTime.split(':')[1].split(' ')[0]),
      ),
    );
  }
}
