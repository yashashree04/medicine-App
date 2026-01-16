import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings);

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _initialized = true;
  }

  
  Future<void> showTestNotification() async {
    await init();

    await _plugin.show(
      999,
      'Test Notification',
      'If you see this, notifications work',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test Channel',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

 
  Future<void> scheduleNotification(
      int id, String title, DateTime time) async {
    await init();

   
    if (time.isBefore(DateTime.now())) {
      time = time.add(const Duration(days: 1));
    }

    final tz.TZDateTime scheduledTime =
        tz.TZDateTime.now(tz.local).add(
      time.difference(DateTime.now()),
    );

    print('🔔 Medicine scheduled at: $scheduledTime');

    await _plugin.zonedSchedule(
      id,
      'Medicine Reminder',
      'Time to take your $title',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medicine_channel',
          'Medicine Reminders',
          channelDescription: 'Reminds you to take medicine',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }
  Future<void> requestExactAlarmPermission() async {
  if (Platform.isAndroid) {
    const platform = MethodChannel('exact_alarm_permission');
    try {
      await platform.invokeMethod('requestExactAlarm');
    } catch (e) {
      debugPrint('Exact alarm permission error: $e');
    }
  }
}

}
