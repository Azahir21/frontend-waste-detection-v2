import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/maps/controllers/maps_controller.dart';
import 'package:get/get.dart';

class LargeScreenMapsView extends GetView<MapsController> {
  const LargeScreenMapsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("maps is working on Large screen"),
      ),
    );
  }
}
