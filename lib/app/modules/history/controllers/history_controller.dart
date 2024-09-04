import 'dart:convert';
import 'package:frontend_waste_management/app/data/models/sampah_model.dart';
import 'package:frontend_waste_management/app/data/services/api_service.dart';
import 'package:frontend_waste_management/app/data/services/simply_translate.dart';
import 'package:frontend_waste_management/app/data/services/token_chacker.dart';
import 'package:frontend_waste_management/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management/core/values/const.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryController extends GetxController {
  //TODO: Implement HistoryController
  final RxBool isLoading = false.obs;
  final RxList<Sampah> sampahs = <Sampah>[].obs;
  final _tokenService = TokenService();

  @override
  void onInit() async {
    super.onInit();
    await fetchData();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    if (!await _tokenService.checkToken()) {
      return;
    }
    await getHistory();
    isLoading.value = false;
    return Future.value();
  }

  Future<List<Sampah>> getHistory() async {
    try {
      sampahs.refresh();
      final response = await ApiServices().get(UrlConstants.userSampah);
      if (response.statusCode != 200) {
        var message = await translate(jsonDecode(response.body)['detail']);
        showFailedSnackbar(
          AppLocalizations.of(Get.context!)!.history_error,
          message,
        );
      }
      sampahs.value = parseSampah(response.body);
      sampahs.sort((a, b) => b.captureTime!.compareTo(a.captureTime!));
      return sampahs;
    } catch (e) {
      throw ('${AppLocalizations.of(Get.context!)!.history_error}: $e');
    }
  }
}
