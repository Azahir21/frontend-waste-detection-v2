import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/register/controllers/register_controller.dart';
import 'package:frontend_waste_management/app/modules/register/views/largescreen_register_view.dart';
import 'package:frontend_waste_management/app/modules/register/views/smallscreen_register_view.dart';

import 'package:get/get.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return SmallScreenRegisterView();
        } else {
          return LargeScreenregisterView();
        }
      }),
    );
  }
}
