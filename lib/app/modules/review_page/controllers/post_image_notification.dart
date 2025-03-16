import 'dart:isolate';
import 'dart:ui';
import 'package:frontend_waste_management/app/data/services/api_service.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      // Initialize notification
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      // Upload logic here
      final response = await ApiServices().postSampahV2(
        inputData!['url'],
        inputData['data'],
      );

      // Show notification when complete
      await flutterLocalNotificationsPlugin.show(
        0,
        'Upload Complete',
        'Image has been uploaded successfully',
        NotificationDetails(
          android: AndroidNotificationDetails(
            'upload_channel',
            'Upload Notifications',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );

      return true;
    } catch (e) {
      return false;
    }
  });
}
