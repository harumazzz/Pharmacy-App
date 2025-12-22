import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  const NotificationHelper._();

  static FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;

  static Future<void> initialize() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final initializationSettings = InitializationSettings(
      android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: const DarwinInitializationSettings(),
      macOS: const DarwinInitializationSettings(),
      linux: LinuxInitializationSettings(
        defaultActionName: '',
        defaultIcon: AssetsLinuxIcon('assets/images/logo.png'),
      ),
      windows: const WindowsInitializationSettings(
        appName: 'Pharmacy App',
        appUserModelId: 'com.example.pharmacy_app',
        guid: '462ebc1c-00e6-4f29-9854-38407451743a',
      ),
    );
    await _flutterLocalNotificationsPlugin!.initialize(initializationSettings);
    return;
  }

  static Future<void> push(final String title, final String description) async {
    await _flutterLocalNotificationsPlugin!.show(
      DateTime.now().millisecondsSinceEpoch % 0x80000000,
      title,
      description,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'com.example.pharmacy_app.notification_channel.main',
          'Main',
        ),
        iOS: DarwinNotificationDetails(),
        macOS: DarwinNotificationDetails(),
        linux: LinuxNotificationDetails(),
        windows: WindowsNotificationDetails(),
      ),
    );
    return;
  }
}
