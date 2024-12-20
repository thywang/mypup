import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_pup_simple/schedule/controller/task_controller.dart';
import 'package:my_pup_simple/schedule/model/task.dart';
import 'package:my_pup_simple/schedule/schedule.dart';
import 'package:my_pup_simple/src/constants/app_colors.dart';
import 'package:my_pup_simple/src/constants/app_sizes.dart';
import 'package:my_pup_simple/widgets/button.dart';
import 'package:my_pup_simple/widgets/days_checkbox_row.dart';
import 'package:my_pup_simple/widgets/subheader.dart';
import 'package:my_pup_simple/widgets/text_field.dart';

class EditSchedulePage extends StatefulWidget {
  const EditSchedulePage({required this.selectedDay, this.task, super.key});
  final int selectedDay;
  final Task? task;

  @override
  State<EditSchedulePage> createState() => _EditSchedulePageState();
}

class _EditSchedulePageState extends State<EditSchedulePage> {
  final TaskController _taskController = Get.put(TaskController());
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  var _startTime = DateFormat('h:mm a').format(DateTime.now());
  var _endTime =
      DateFormat('h:mm a').format(DateTime.now().add(const Duration(hours: 1)));

  // reminder in minutes
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];

  // selected color index
  int _selectedColor = 0;

  // selected days to repeat
  List<bool> _selectedDays = List.generate(7, (index) => false);

  @override
  void initState() {
    super.initState();

    // preselect the current day for the task
    _selectedDays[widget.selectedDay] = true;
    if (widget.task != null) {
      final task = widget.task!;
      _titleController.text = task.title;
      _noteController.text = task.note;
      _startTime = task.startTime;
      _endTime = task.endTime;
      _selectedRemind = task.remind;
      _selectedColor = task.color;
      for (final dayIndex in task.selectedDays) {
        _selectedDays[dayIndex] = true;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          alignment: Alignment.centerLeft,
          onPressed: () {
            Get.back<SchedulePage>();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p32),
          child: Column(
            children: [
              SubHeaderWidget(
                text: widget.task == null ? 'Add Task' : 'Edit Task',
              ),
              gapH24,
              TextFieldWidget(
                label: 'Title',
                hint: 'Enter your title',
                controller: _titleController,
                onChanged: (title) => {},
              ),
              gapH24,
              TextFieldWidget(
                label: 'Note',
                hint: 'Enter your note',
                controller: _noteController,
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
                label: 'Remind',
                hint: '$_selectedRemind minutes before',
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
                      _selectedRemind = int.parse(newValue);
                    });
                  },
                ),
              ),
              gapH24,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Repeat',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  gapH8,
                  // List of checkboxes for each day of the week
                  DaysCheckboxRow(
                    selectedDays: _selectedDays,
                    onChanged: (newSelectedDays) => setState(() {
                      _selectedDays = newSelectedDays;
                    }),
                  ),
                ],
              ),
              gapH24,
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Color',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      gapH8,
                      Wrap(
                        spacing: Sizes.p12,
                        children: List<Widget>.generate(
                          cardColors.length,
                          (index) => GestureDetector(
                            onTap: () => setState(() {
                              _selectedColor = index;
                            }),
                            child: CircleAvatar(
                              radius: Sizes.p16,
                              backgroundColor: cardColors[index],
                              child: _selectedColor == index
                                  ? const Icon(
                                      Icons.done,
                                      color: Colors.white,
                                      size: Sizes.p16,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              gapH24,
              ButtonWidget(
                text: widget.task == null ? 'Create Task' : 'Update Task',
                onClicked: _saveTask,
              ),
            ],
          ),
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

  void _saveTask() {
    // validate data first
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        _snackBar(
          label: 'Title is required',
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // parse start and end times as date time objects to compare
    final timeFormat = DateFormat('h:mm a');
    final parsedStartTime = timeFormat.parse(_startTime);
    final parsedEndTime = timeFormat.parse(_endTime);

    if (!parsedStartTime.isBefore(parsedEndTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        _snackBar(
          label: 'Start time must be before end time',
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    
    // make sure at least one day is selected
    if (!_selectedDays.contains(true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        _snackBar(
          label: 'Select at least one day to repeat',
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (widget.task == null) {
      // add task to database
      _addTaskToDb();
      final selectedDays = _selectedDays
          .asMap()
          .entries
          .where((entry) => entry.value)
          .map((entry) => daysOfTheWeek[entry.key])
          .toList();
      debugPrint(
        'add to $selectedDays',
      );
    } else {
      // update task
      _updateTask();
    }
    Get.back<SchedulePage>();
  }

  SnackBar _snackBar({required String label, required Color backgroundColor}) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(label),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> _addTaskToDb() async {
    final id = await _taskController.addTask(
      task: Task(
        title: _titleController.text,
        note: _noteController.text,
        startTime: _startTime,
        endTime: _endTime,
        selectedDays: _selectedDays
            .asMap()
            .entries
            .where((entry) => entry.value)
            .map((entry) => entry.key)
            .toList(),
        remind: _selectedRemind,
        color: _selectedColor,
      ),
    );
    debugPrint('task $id created');
  }

  Future<void> _updateTask() async {
    await _taskController.updateTask(
      task: Task(
        id: widget.task?.id,
        title: _titleController.text,
        note: _noteController.text,
        startTime: _startTime,
        endTime: _endTime,
        selectedDays: _selectedDays
            .asMap()
            .entries
            .where((entry) => entry.value)
            .map((entry) => entry.key)
            .toList(),
        remind: _selectedRemind,
        color: _selectedColor,
      ),
    );
    debugPrint('task ${widget.task?.id} updated');
  }
}
