import 'package:get/get.dart';
import 'package:my_pup_simple/schedule/data/db_helper.dart';
import 'package:my_pup_simple/schedule/model/task.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  Future<int> addTask({required Task task}) async {
    return DBHelper.addTask(task);
  }
}
