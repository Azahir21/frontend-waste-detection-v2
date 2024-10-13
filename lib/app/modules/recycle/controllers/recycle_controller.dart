import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management/core/values/const.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecycleController extends GetxController {
  //TODO: Implement RecycleController
  final arguments = Get.arguments;
  var recommendation = ''.obs;
  var isLoading = true.obs;

  @override
  void onInit() async {
    super.onInit();
    // await fetchRecommendation(arguments);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchRecommendation(arguments);
      checkAndShowSnackbar();
    });
  }

  Future<void> fetchRecommendation(String wasteType) async {
    try {
      isLoading.value = true;
      String language = GetStorage().read("language");
      if (language == "id") {
        language = "Indonesian";
      } else if (language == "ja") {
        language = "English";
      } else {
        language = "English";
      }
      final response = await http.post(
        Uri.parse(Keys.link),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Keys.apiKey}',
        },
        body: jsonEncode({
          "model": "gpt-4o-mini",
          "max_completion_tokens": 2048,
          "messages": [
            {"role": "system", "content": "You are a recycling expert."},
            {
              "role": "user",
              "content":
                  "Provide me with a creative recycling recommendations for a $wasteType. For each recommendation, include the following:\n\nName of the project:\nTools and materials:\nStep-by-step instructions:\n\ngive response in ${language} language."
            }
          ]
        }),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String reply = data['choices'][0]['message']['content'];
        recommendation.value = reply;
      } else {
        recommendation.value = "Failed to fetch recommendations.";
      }
      isLoading.value = false;
      print(GetStorage().read("language"));
    } catch (e) {
      isLoading.value = false;
      recommendation.value = "Error occurred: $e";
    }
  }

  void checkAndShowSnackbar() {
    if (GetStorage().read("language") == 'ja') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.overlayContext != null) {
          showFailedSnackbar(
              AppLocalizations.of(Get.context!)!.feature_under_development,
              AppLocalizations.of(Get.context!)!.recycle_feature_message);
        } else {
          print("Overlay context is not available");
        }
      });
    }
  }
}
