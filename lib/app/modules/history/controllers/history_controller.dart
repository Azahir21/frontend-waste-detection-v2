import 'package:frontend_waste_management/app/data/models/sampah_model.dart';
import 'package:frontend_waste_management/app/data/services/api_service.dart';
import 'package:frontend_waste_management/app/data/services/token_chacker.dart';
import 'package:frontend_waste_management/core/values/const.dart';
import 'package:get/get.dart';

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
      sampahs.value = parseSampah(response);
      // sort by capture time
      sampahs.sort((a, b) => b.captureTime!.compareTo(a.captureTime!));
      return sampahs;
    } catch (e) {
      Get.snackbar('History Error', 'Failed to get history. Please try again.');
      throw ('History error: $e');
    }
  }
}
