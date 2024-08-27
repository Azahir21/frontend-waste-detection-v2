import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/history/views/largescreen_history_view.dart';
import 'package:frontend_waste_management/app/modules/history/views/smallscreen_history_view.dart';

import 'package:get/get.dart';

import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return SmallScreenHistoryView();
        } else {
          return LargeScreenHistoryView();
        }
      }),
    );
  }
}
