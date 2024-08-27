import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/account_setting/controllers/account_setting_controller.dart';
import 'package:get/get.dart';

class LargeScreenAccountSettingView extends GetView<AccountSettingController> {
  const LargeScreenAccountSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Account setting is working on large screen"),
      ),
    );
  }
}
