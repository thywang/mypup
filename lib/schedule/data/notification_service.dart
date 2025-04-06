import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:my_pup_simple/schedule/model/task.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotification() async {
    await _configureLocalTimezone();

    // notifications for iOS
    final initializationSettingsDarwin = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    // notifications for Android
    const initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final initializationSettings = InitializationSettings(
      iOS: initializationSettingsDarwin,
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: notificationTapBackground,
    );
  }

  Future<void> scheduleTaskNotifications(Task task) async {
    final timeFormat = DateFormat('h:mm a');
    for (final day in task.selectedDays) {
      final parsedStartTime = timeFormat.parse(task.startTime);
      final notificationTime = parsedStartTime.subtract(
        Duration(
          minutes: task.remind,
        ),
      );
      await scheduleNotification(
        hour: notificationTime.hour,
        minutes: notificationTime.minute,
        task: task,
        weekday: day + 1, // selectedDays is 0-indexed
      );
    }
  }

  /// Gets the notification ID for a task based on its ID and the weekday.
  int _getNotificationId({
    required int taskId,
    required int weekday,
  }) {
    return taskId * 10 + weekday;
  }

  Future<void> scheduleNotification({
    required int hour,
    required int minutes,
    required Task task,
    required int weekday,
  }) async {
    final scheduled = _calculateNotificationDateTime(
      hour: hour,
      minutes: minutes,
      weekday: weekday,
    );
    final notificationId =
        _getNotificationId(taskId: task.id!, weekday: weekday);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      task.title,
      task.note,
      scheduled,
      const NotificationDetails(
        iOS: DarwinNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exact,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  Future<void> cancelNotifications({
    required int taskId,
    required List<int> selectedDays,
  }) async {
    for (final day in selectedDays) {
      final notificationId = _getNotificationId(
        taskId: taskId,
        weekday: day + 1, // selectedDays is 0-indexed
      );
      await flutterLocalNotificationsPlugin.cancel(notificationId);
    }
  }

  tz.TZDateTime _calculateNotificationDateTime({
    required int hour,
    required int minutes,
    required int weekday,
  }) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minutes,
    );

    while (scheduled.weekday != weekday) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 7));
    }

    return scheduled;
  }

  Future<void> _configureLocalTimezone() async {
    tz.initializeTimeZones();
    final timezone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezone));
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    await Get.dialog(
      const Text('Welcome to MyPuppy!'),
    );
  }

  @pragma('vm:entry-point')
  void notificationTapBackground(NotificationResponse notificationResponse) {
    debugPrint('notification(${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with'
        ' payload: ${notificationResponse.payload}');
    if (notificationResponse.input?.isNotEmpty ?? false) {
      debugPrint(
          'notification action tapped with input: ${notificationResponse.input}');
    }
  }
}
