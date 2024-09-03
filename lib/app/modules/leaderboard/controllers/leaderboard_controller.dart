import 'dart:convert';

import 'package:frontend_waste_management/app/data/models/leaderboard_model.dart';
import 'package:frontend_waste_management/app/data/services/api_service.dart';
import 'package:frontend_waste_management/app/data/services/token_chacker.dart';
import 'package:frontend_waste_management/core/values/const.dart';
import 'package:get/get.dart';

class LeaderboardController extends GetxController {
  //TODO: Implement LeaderboardController
  final RxBool isLoading = false.obs;
  final RxList<Leaderboard> show = <Leaderboard>[].obs;
  final RxList<Leaderboard> weekly = <Leaderboard>[].obs;
  final RxList<Leaderboard> monthly = <Leaderboard>[].obs;
  final RxList<Leaderboard> allTime = <Leaderboard>[].obs;
  final _tokenService = TokenService();

  @override
  void onInit() async {
    super.onInit();
    await fetchData();
    show.value = weekly;
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    if (!await _tokenService.checkToken()) {
      return;
    }
    await getWeekly();
    await getMonthly();
    await getAllTime();
    isLoading.value = false;
    return Future.value();
  }

  Future<List<Leaderboard>> getWeekly() async {
    try {
      final response = await ApiServices().get(UrlConstants.weeklyPoint);
      if (response.statusCode != 200) {
        Get.snackbar('Leaderboard Error', jsonDecode(response.body)['detail']);
        throw ('Leaderboard weekly error: ${response.body}');
      }
      Leaderboards leaderboards = Leaderboards.fromRawJson(response.body);
      weekly.value = leaderboards.leaderboards;
      return weekly;
    } catch (e) {
      Get.snackbar('Leaderboard Error',
          'Failed to get weekly leaderboard. Please try again.');
      throw ('Leaderboard weekly error: $e');
    }
  }

  Future<List<Leaderboard>> getMonthly() async {
    try {
      final response = await ApiServices().get(UrlConstants.monthlyPoint);
      if (response.statusCode != 200) {
        Get.snackbar('Leaderboard Error', jsonDecode(response.body)['detail']);
        throw ('Leaderboard monthly error: ${response.body}');
      }
      Leaderboards leaderboards = Leaderboards.fromRawJson(response.body);
      monthly.value = leaderboards.leaderboards;
      return monthly;
    } catch (e) {
      Get.snackbar('Leaderboard Error',
          'Failed to monthly leaderboard. Please try again.');
      throw ('Leaderboard monthly error: $e');
    }
  }

  Future<List<Leaderboard>> getAllTime() async {
    try {
      final response = await ApiServices().get(UrlConstants.allTimePoint);
      if (response.statusCode != 200) {
        Get.snackbar('Leaderboard Error', jsonDecode(response.body)['detail']);
        throw ('Leaderboard alltime error: ${response.body}');
      }
      Leaderboards leaderboards = Leaderboards.fromRawJson(response.body);
      allTime.value = leaderboards.leaderboards;
      return allTime;
    } catch (e) {
      Get.snackbar('Leaderboard Error',
          'Failed to alltime leaderboard. Please try again.');
      throw ('Leaderboard alltime error: $e');
    }
  }
}
