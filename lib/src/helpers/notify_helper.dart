import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // notifications for iOS
  Future<void> initializeNotification() async {
    tz.initializeTimeZones();

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

  Future<void> displayNotification({
    required String title,
    required String body,
  }) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  Future<void> scheduledNotification({
    required String title,
    required String body,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(
        // TODO: replace with passed datetime
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        tz.local,
      ),
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
    );
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
    // ignore: avoid_print
    print('notification(${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with'
        ' payload: ${notificationResponse.payload}');
    if (notificationResponse.input?.isNotEmpty ?? false) {
      // ignore: avoid_print
      print(
          'notification action tapped with input: ${notificationResponse.input}');
    }
  }
}
