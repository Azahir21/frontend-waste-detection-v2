import 'package:frontend_waste_management/core/values/const.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecycleController extends GetxController {
  //TODO: Implement RecycleController
  final arguments = Get.arguments;
  var recommendation = ''.obs;
  var isLoading = true.obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchRecommendation(arguments);
    print(recommendation.value);
  }

  Future<void> fetchRecommendation(String wasteType) async {
    try {
      isLoading.value = true;
      String language = GetStorage().read("language");
      if (language == "id") {
        language = "Indonesian";
      } else if (language == "ja") {
        language = "Japanese";
      } else {
        language = "English";
      }
      final response = await http.post(
        Uri.parse(Key.link),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Key.apiKey}',
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
    } catch (e) {
      isLoading.value = false;
      recommendation.value = "Error occurred: $e";
    }
  }
}
