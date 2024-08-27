import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/account_setting/views/largescreen_account_setting_view.dart';
import 'package:frontend_waste_management/app/modules/account_setting/views/smallscreen_account_setting_view.dart';

import 'package:get/get.dart';

import '../controllers/account_setting_controller.dart';

class AccountSettingView extends GetView<AccountSettingController> {
  const AccountSettingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return SmallScreenAccountSettingView();
        } else {
          return LargeScreenAccountSettingView();
        }
      }),
    );
  }
}
