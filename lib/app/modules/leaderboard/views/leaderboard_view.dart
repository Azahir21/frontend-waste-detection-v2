import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/leaderboard/views/largescreen_leaderboard_view.dart';
import 'package:frontend_waste_management/app/modules/leaderboard/views/smallscreen_leaderboard_view.dart';

import 'package:get/get.dart';

import '../controllers/leaderboard_controller.dart';

class LeaderboardView extends GetView<LeaderboardController> {
  const LeaderboardView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return SmallScreenLeaderboardView();
        } else {
          return LargeScreenLeaderboardView();
        }
      }),
    );
  }
}
