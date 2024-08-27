import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/login/views/largescreen_login_view.dart';
import 'package:frontend_waste_management/app/modules/login/views/smallscreen_login_view.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return SmallScreenLoginView();
        } else {
          return LargeScreenLoginView();
        }
      }),
    );
  }
}
