import 'package:get/get.dart';
import 'package:my_pup_simple/schedule/data/db_helper.dart';
import 'package:my_pup_simple/schedule/model/task.dart';

class TaskController extends GetxController {
  final taskList = <Task>[].obs;

  @override
  void onReady() {
    super.onReady();
    // fetch tasks
    getTasks();
  }

  Future<int> addTask({required Task task}) async {
    return DBHelper.addTask(task);
  }

  Future<void> getTasks() async {
    final tasks = await DBHelper.getTasks();
    taskList.assignAll(tasks);
  }

  void deleteTask({required int id}) {
   DBHelper.deleteTask(id: id);
  }

  Future<void> updateTask({required Task task}) async {
    await DBHelper.updateTask(task);
  }
}
