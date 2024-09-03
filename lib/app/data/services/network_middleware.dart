import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityMiddleware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) {
    _checkConnectivity();
    return super.onPageCalled(page);
  }

  void _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Get.defaultDialog(
        title: 'Jaringan Bermasalah',
        middleText:
            'Tidak terhubung ke internet, tolong periksa kembali jaringan Anda untuk melanjutkan',
        onWillPop: () async => false,
        titleStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Colors.red,
        ),
        middleTextStyle: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        barrierDismissible: false,
      );
    }
  }
}
