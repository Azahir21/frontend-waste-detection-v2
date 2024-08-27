import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/history/controllers/history_controller.dart';
import 'package:get/get.dart';

class LargeScreenHistoryView extends GetView<HistoryController> {
  const LargeScreenHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("history is working on Large screen"),
      ),
    );
  }
}
