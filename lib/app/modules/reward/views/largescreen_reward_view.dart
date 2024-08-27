import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/reward/controllers/reward_controller.dart';
import 'package:get/get.dart';

class LargeScreenRewardView extends GetView<RewardController> {
  const LargeScreenRewardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("reward is working on Large screen"),
      ),
    );
  }
}
