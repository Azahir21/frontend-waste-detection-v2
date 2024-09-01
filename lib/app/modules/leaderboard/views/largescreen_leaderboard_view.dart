import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/leaderboard/controllers/leaderboard_controller.dart';
import 'package:get/get.dart';

class LargeScreenLeaderboardView extends GetView<LeaderboardController> {
  const LargeScreenLeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('LargeScreenLeaderboardView is working',
          style: TextStyle(fontSize: 20)),
    );
  }
}
