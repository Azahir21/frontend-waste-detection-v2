import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/recycle/controllers/recycle_controller.dart';
import 'package:get/get.dart';

class LargeScreenRecycleView extends GetView<RecycleController> {
  const LargeScreenRecycleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("recycle is working on large screen"),
      ),
    );
  }
}
