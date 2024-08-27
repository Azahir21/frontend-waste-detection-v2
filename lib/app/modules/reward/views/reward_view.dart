import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/reward/views/largescreen_reward_view.dart';
import 'package:frontend_waste_management/app/modules/reward/views/smallscreen_reward_view.dart';

import 'package:get/get.dart';

import '../controllers/reward_controller.dart';

class RewardView extends GetView<RewardController> {
  const RewardView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return SmallScreenRewardView();
        } else {
          return LargeScreenRewardView();
        }
      }),
    );
  }
}
