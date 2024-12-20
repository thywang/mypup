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

  Future<void> deleteTask({required int id}) async {
    await DBHelper.deleteTask(id: id);
    await _notificationService.cancelNotification(id);
  }

  Future<void> updateTask({required Task task}) async {
    await DBHelper.updateTask(task);
    // cancel existing notifications
    await _notificationService.cancelNotification(task.id!);
    // schedule new notifications
    unawaited(
      Future.microtask(
        () => _notificationService.scheduleTaskNotifications(task),
      ),
    );
  }
}
