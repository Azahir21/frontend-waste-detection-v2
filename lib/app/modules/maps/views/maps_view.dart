import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/maps/views/largescreen_maps_view.dart';
import 'package:frontend_waste_management/app/modules/maps/views/smallscreen_maps_view.dart';

import 'package:get/get.dart';

import '../controllers/maps_controller.dart';

class MapsView extends GetView<MapsController> {
  const MapsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return SmallScreenMapsView();
        } else {
          return LargeScreenMapsView();
        }
      }),
    );
  }
}
