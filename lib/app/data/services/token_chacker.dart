import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:get_storage/get_storage.dart';
import 'package:overlay_kit/overlay_kit.dart';

class TokenService {
  Future<bool> checkToken() async {
    OverlayLoadingProgress.stop();
    final token = GetStorage().read('token');
    if (token != null && JwtDecoder.isExpired(token)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        GetStorage().remove('token');
        Get.snackbar('Token Expired', 'Please login again');
        Get.offAllNamed('/login');
      });
      return false;
    }
    return true;
  }
}
