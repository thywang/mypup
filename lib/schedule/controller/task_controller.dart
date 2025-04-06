import 'dart:async';

import 'package:get/get.dart';
import 'package:my_pup_simple/schedule/data/db_helper.dart';
import 'package:my_pup_simple/schedule/data/notification_service.dart';
import 'package:my_pup_simple/schedule/model/task.dart';

class TaskController extends GetxController {
  final taskList = <Task>[].obs;
  final NotificationService _notificationService =
      Get.find<NotificationService>();

  @override
  void onReady() {
    super.onReady();
    // fetch tasks
    getTasks();
  }

  Future<int> addTask({required Task task}) async {
    final id = await DBHelper.addTask(task);
    final newTask = Task(
      id: id,
      title: task.title,
      note: task.note,
      startTime: task.startTime,
      endTime: task.endTime,
      selectedDays: task.selectedDays,
      remind: task.remind,
      color: task.color,
    );
    unawaited(
      Future.microtask(
        () => _notificationService.scheduleTaskNotifications(newTask),
      ),
    );
    return id;
  }

  Future<void> getTasks() async {
    final tasks = await DBHelper.getTasks();
    taskList.assignAll(tasks);
  }

  Future<void> deleteTask({required Task task}) async {
    final taskId = task.id!;
    final selectedDays = task.selectedDays;
    await DBHelper.deleteTask(id: taskId);
    await _notificationService.cancelNotifications(
      taskId: taskId,
      selectedDays: selectedDays,
    );
  }

  Future<Task?> updateTask({required Task task}) async {
    // get the existing task from the database
    final existingTask = await DBHelper.getTask(id: task.id!);
    if (existingTask == null) {
      return null;
    }
    // cancel existing notifications using existing task's selected days
    await _notificationService.cancelNotifications(
      taskId: task.id!,
      selectedDays: existingTask.selectedDays,
    );
    await DBHelper.updateTask(task);
    // schedule new notifications
    unawaited(
      Future.microtask(
        () => _notificationService.scheduleTaskNotifications(task),
      ),
    );
    return task;
  }
}
