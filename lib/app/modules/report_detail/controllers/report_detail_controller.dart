import 'package:frontend_waste_management/app/data/models/sampah_detail_model.dart';
import 'package:frontend_waste_management/app/data/services/api_service.dart';
import 'package:frontend_waste_management/core/values/const.dart';
import 'package:get/get.dart';

class ReportDetailController extends GetxController {
  //TODO: Implement ReportDetailController
  final reportDetail = SampahDetail().obs;
  final reportId = Get.arguments;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getReportDetail();
  }

  Future<void> getReportDetail() async {
    isLoading.value = true;
    final response =
        await ApiServices().get(UrlConstants.userSampah + "/$reportId");
    reportDetail.value = parseSampahDetailSingle(response);
    print(reportDetail.value.image);
    isLoading.value = false;
  }
}
