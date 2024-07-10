
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:uts_mobile/models/schedule_model.dart';

import 'config_notify_helper.dart';

class NotificationHelper with AwesomeNotifications {
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    // log('Notification created, n: $receivedNotification');
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    // log('Notification displayed, n: $receivedNotification');
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    // log('Notification dismissed, n: $receivedAction');
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    // log('Notification action received, n: $receivedAction');
  }

  static Future checkNotificationPermission(String key) async {
    final bool isAllowed = await AwesomeNotifications().isNotificationAllowed();

    if (isAllowed) {
      return;
    }

    await AwesomeNotifications().requestPermissionToSendNotifications(
      channelKey: key,
      permissions: [
        NotificationPermission.Alert,
        NotificationPermission.Badge,
        NotificationPermission.Sound,
        NotificationPermission.Vibration,
      ],
    );
  }

  static Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  static Future<void> createScheduledNotification(
    ScheduleItemModel schedule,
  ) async {
    await configureLocalTimeZone();

    final location = tz.local;
    final now = tz.TZDateTime.now(location);

    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final DateFormat timeFormat = DateFormat('HH:mm');

    final DateTime scheduleDate = dateFormat.parse(schedule.tanggal);
    final DateTime scheduleStartTime = timeFormat.parse(schedule.waktu);

    final scheduleTzStartTime = tz.TZDateTime(
      location,
      scheduleDate.year,
      scheduleDate.month,
      scheduleDate.day,
      scheduleStartTime.hour,
      scheduleStartTime.minute,
    );

    if (scheduleTzStartTime.isBefore(now)) {
      // log('Error: Scheduled time is in the past');
      return;
    }

    final payload = {
      'id': schedule.id,
      'userId': schedule.userId,
    };

    int uniqueId = DateTime.now().millisecondsSinceEpoch.remainder(100000);

    try {
      final notification = NotificationContent(
        id: uniqueId,
        channelKey: channelScheduleKey,
        title: "Schedule Reminder",
        body: "Schedule ${schedule.catatan} is to start now!",
        payload: payload,
      );

      final scheduleNotif = NotificationCalendar.fromDate(
        date: scheduleTzStartTime,
        allowWhileIdle: true,
        repeats: true,
        preciseAlarm: true,
      );

      await AwesomeNotifications().createNotification(
        content: notification,
        schedule: scheduleNotif,
      );

      // log('Scheduled notification created with ID: $uniqueId');
    } catch (e) {
      // log('Error creating notification: $e');
    }
  }

  static Future<void> cancelScheduledNotification(int id) async {
    try {
      await AwesomeNotifications().cancel(id);
      // log('Scheduled notification with ID: $id has been cancelled'); 
    } catch (e) {
      // log('Error cancelling notification: $e');
    }
  }

  static Future<void> cancelAllScheduledNotifications() async {
    try {
      await AwesomeNotifications().cancelAllSchedules();
      // log('All scheduled notifications have been cancelled');
    } catch (e) {
      // log('Error cancelling all notifications: $e');
    }
  }
}
