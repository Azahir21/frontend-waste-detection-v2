import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/notification/controllers/notification_controller.dart';
import 'package:get/get.dart';

class LargeScreenNotificationView extends GetView<NotificationController> {
  const LargeScreenNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Notification is working on Large screen"),
      ),
    );
  }
}
