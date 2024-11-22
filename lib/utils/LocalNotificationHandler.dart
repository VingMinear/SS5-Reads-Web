import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ReceivedNotification {
  ReceivedNotification({
    required this.title,
    required this.body,
    required this.payload,
  });

  final String? title;
  final String? body;
  final String? payload;
}

int _i = 0;
final _localNotifications = FlutterLocalNotificationsPlugin();

class LocalNotificationHandler {
  static const _iOS = DarwinInitializationSettings();
  static const _android = AndroidInitializationSettings('@drawable/app_logo');
  static const _iosDetail = DarwinNotificationDetails(
    presentSound: true,
    presentAlert: true,
    presentBadge: true,
    badgeNumber: 0,
  );
  static const _andriodDetail = AndroidNotificationDetails(
    'high_importance_channel',
    'Fashion Store',
    playSound: true,
    importance: Importance.max,
    priority: Priority.high,
    icon: '@drawable/app_logo',
    channelShowBadge: true,
    largeIcon: DrawableResourceAndroidBitmap('app_logo'),
  );

  static Future initLocalNotification() async {
    const settings = InitializationSettings(android: _android, iOS: _iOS);
    await _localNotifications.initialize(settings);
  }

  static Future showBigNotification({required ReceivedNotification msg}) async {
    await _localNotifications.show(
      _i++,
      msg.title,
      msg.body,
      payload: msg.payload,
      _notificationDetail(),
    );
  }

  static NotificationDetails _notificationDetail() =>
      const NotificationDetails(android: _andriodDetail, iOS: _iosDetail);
}
