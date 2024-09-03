import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectionStatus = Connectivity();
  final RxBool isConnected = true.obs;
  final RxBool isSplashScreen = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _connectionStatus.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectionStatus.checkConnectivity();
    } catch (e) {
      print("Couldn't check connectivity status: $e");
      return;
    }
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    print("Connection status: $result");

    switch (result) {
      case ConnectivityResult.none:
        isConnected.value = false;
        if (!isSplashScreen.value) {
          _showNoInternetDialog();
        }
        break;
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        if (!isConnected.value) {
          isConnected.value = true;
          if (!isSplashScreen.value) {
            Get.back(); // Close the dialog if it's open
            _showConnectedSnackbar(
                result == ConnectivityResult.wifi ? "Wifi" : "Data Seluler");
          }
        }
        break;
      default:
        break;
    }
  }

  void _showNoInternetDialog() {
    if (Get.isDialogOpen ?? false) return; // Prevent multiple dialogs

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

  void _showConnectedSnackbar(String connectionType) {
    Get.snackbar(
      "Berhasil Terhubung",
      "Terhubung dengan $connectionType",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void setSplashScreenStatus(bool status) {
    isSplashScreen.value = status;
    if (!status && !isConnected.value) {
      _showNoInternetDialog();
    }
  }
}
