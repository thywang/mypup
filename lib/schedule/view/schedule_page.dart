import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_pup_simple/schedule/controller/task_controller.dart';
import 'package:my_pup_simple/schedule/model/task.dart';
import 'package:my_pup_simple/schedule/view/edit_schedule_page.dart';
import 'package:my_pup_simple/src/constants/app_colors.dart';
import 'package:my_pup_simple/src/constants/app_sizes.dart';
import 'package:my_pup_simple/widgets/subheader.dart';
import 'package:path_provider/path_provider.dart';

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
  int _selectedDay = 0;
  final PageController _pageController = PageController(viewportFraction: 0.5);
  final _taskController = Get.put(TaskController());

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
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.download, color: mainAppColor),
                      onPressed: _downloadTasks,
                    ),
                    IconButton(
                      icon: Icon(Icons.upload, color: mainAppColor),
                      onPressed: _uploadTasks,
                    ),
                  ],
                ),
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
                  onPressed: () async {
                    await Get.to<EditSchedulePage>(
                      EditSchedulePage(selectedDay: _selectedDay),
                    );
                    // refetch all tasks
                    await _taskController.getTasks();
                  },
                ),
              ],
            ),
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
                  _selectedDay = page;
                }),
                children: <Widget>[
                  for (final (index, day) in daysOfTheWeek.indexed) ...[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDay = index;
                        });
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOut,
                        );
                      },
                      child: Opacity(
                        opacity: index == _selectedDay ? 1.0 : 0.5,
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
            gapH24,
            _listTasks(),
          ],
        ),
      ),
    );
  }

  Widget _listTasks() {
    return Expanded(
      child: Obx(
        () {
          // Filter tasks based on the selected day
          final filteredTasks = _taskController.taskList
              .where((task) => task.selectedDays.contains(_selectedDay))
              .toList()
            ..sort((task1, task2) {
              final timeFormat = DateFormat('h:mm a');
              final parsedStartTime1 = timeFormat.parse(task1.startTime);
              final parsedStartTime2 = timeFormat.parse(task2.startTime);
              return parsedStartTime1.compareTo(parsedStartTime2);
            });

          if (filteredTasks.isEmpty) {
            return const Center(child: Text('No tasks for today.'));
          }

          return ListView.separated(
            itemBuilder: (context, index) {
              final task = filteredTasks[index];
              return ListTile(
                onTap: () {
                  _showTaskActionsBottomSheet(
                    context,
                    filteredTasks[index],
                  );
                },
                tileColor: cardColors[task.color],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Sizes.p16),
                ),
                title: Padding(
                  padding: const EdgeInsets.only(
                    top: Sizes.p12,
                    bottom: Sizes.p8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          color: titleTextColorLight,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      gapH8,
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: titleTextColorLight,
                            size: 18,
                          ),
                          gapW8,
                          Text(
                            '${task.startTime} - ${task.endTime}',
                            style: TextStyle(
                              color: titleTextColorLight,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(
                    bottom: Sizes.p8,
                  ),
                  child: Text(
                    task.note,
                    style: TextStyle(
                      color: titleTextColorLight,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => gapH16,
            itemCount: filteredTasks.length,
          );
        },
      ),
    );
  }

  Future<void> _showTaskActionsBottomSheet(
      BuildContext context, Task task) async {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child: Center(
            child: Column(
              children: [
                gapH16,
                SizedBox(
                  height: 6,
                  width: 120,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(Sizes.p12),
                    ),
                  ),
                ),
                gapH32,
                _taskActionButton(
                  label: 'Edit Task',
                  onTap: () async {
                    // close bottom sheet
                    Navigator.pop(context);
                    await Get.to<EditSchedulePage>(
                      EditSchedulePage(
                        selectedDay: _selectedDay,
                        task: task,
                      ),
                    );
                    // refetch all tasks
                    await _taskController.getTasks();
                  },
                  color: mainAppColor,
                ),
                gapH16,
                _taskActionButton(
                  label: 'Delete Task',
                  onTap: () {
                    _taskController
                      ..deleteTask(id: task.id!)
                      ..getTasks();
                    Get.back<SchedulePage>();
                  },
                  color: Colors.red,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _taskActionButton({
    required String label,
    required void Function() onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p16), // Add space on the left and right
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(Sizes.p16),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: Sizes.p12,
              bottom: Sizes.p12,
            ),
            child: Center(
              // Center the text inside the button
              child: Text(
                label,
                style: TextStyle(
                  color: titleTextColorLight,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _downloadTasks() async {
    final tasks = _taskController.taskList;
    final tasksJson = tasks.map((task) => task.toJson()).toList();

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/tasks.json');
    await file.writeAsString(tasksJson.toString());

    // notify user
    Get.snackbar(
      'Tasks Downloaded',
      'Tasks have been downloaded to ${file.path}',
      snackPosition: SnackPosition.BOTTOM,
      duration: null, // wait for user to dismiss
    );
  }

  Future<void> _uploadTasks() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null || result.files.single.path == null) {
      return;
    }

    final file = File(result.files.single.path!);
    final tasksJson = await file.readAsString();

    final tasks = (jsonDecode(tasksJson) as List<dynamic>)
        .map(
          (json) => Task.fromJson(json as Map<String, dynamic>),
        )
        .toList();

    // add tasks to database
    for (final task in tasks) {
      await _taskController.addTask(task: task);
    }
    await _taskController.getTasks();

    // notify user
    Get.snackbar(
      'Tasks Uploaded',
      'Tasks uploaded successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
