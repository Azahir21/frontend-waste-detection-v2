import 'dart:convert';
import 'package:frontend_waste_management/app/data/models/sampah_detail_model.dart';
import 'package:frontend_waste_management/app/data/services/api_service.dart';
import 'package:frontend_waste_management/app/data/services/simply_translate.dart';
import 'package:frontend_waste_management/app/data/services/token_chacker.dart';
import 'package:frontend_waste_management/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management/core/values/const.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReportDetailController extends GetxController {
  //TODO: Implement ReportDetailController
  final reportDetail = SampahDetail().obs;
  final reportId = Get.arguments;
  final isLoading = false.obs;
  final _tokenService = TokenService();

  @override
  void onInit() {
    super.onInit();
    getReportDetail();
  }

  Future<void> getReportDetail() async {
    if (!await _tokenService.checkToken()) {
      return;
    }
    isLoading.value = true;
    final response =
        await ApiServices().get(UrlConstants.userSampah + "/$reportId");
    if (response.statusCode != 200) {
      var message = await translate(jsonDecode(response.body)['detail']);
      showFailedSnackbar(
        AppLocalizations.of(Get.context!)!.report_detail_error,
        message,
      );
      throw ('Report Detail error: ${response.body}');
    }
    reportDetail.value = parseSampahDetailSingle(response.body);
    for (var detectedObject in reportDetail.value.countedObjects!) {
      detectedObject.name = await translate(detectedObject.name!);
    }
    isLoading.value = false;
  }
}
