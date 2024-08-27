import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/notification/views/largescreen_notification_view.dart';
import 'package:frontend_waste_management/app/modules/notification/views/smallscreen_notification_view.dart';

import 'package:get/get.dart';

import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return SmallScreenNotificationView();
        } else {
          return LargeScreenNotificationView();
        }
      }),
    );
  }
}
