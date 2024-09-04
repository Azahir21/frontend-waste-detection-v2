import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    if (_arguments != null) {
      _currentPageNotifier.value = 3 - 1;
      _pageController = PageController(initialPage: 3 - 1);
      firstIndex = false;
      lastIndex = true;
    } else {
      _pageController = PageController();
      firstIndex = true;
      lastIndex = false;
    }
    print("locale 3 : ${Get.locale}");
    Get.updateLocale(Get.locale!);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  final _firstIndex = true.obs;
  final _lastIndex = false.obs;
  final _currentPageNotifier = ValueNotifier<int>(0);
  late var _pageController = PageController();
  final _arguments = Get.arguments;

  int get arguments => _arguments;

  ValueNotifier<int> get currentPageNotifier => _currentPageNotifier;
  set currentPageNotifier(ValueNotifier<int> value) {
    _currentPageNotifier.value = value.value;
  }

  bool get firstIndex => _firstIndex.value;
  set firstIndex(bool value) => _firstIndex.value = value;

  bool get lastIndex => _lastIndex.value;
  set lastIndex(bool value) => _lastIndex.value = value;

  PageController get pageController => _pageController;

  double getStringWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.width;
  }

  void skipToEnd(int length) {
    _currentPageNotifier.value = length - 1;
    _pageController.jumpToPage(length - 1);
  }

  void goToNextPage() {
    _currentPageNotifier.value += 1;
    _pageController.jumpToPage(currentPageNotifier.value);
  }

  void onPageChanged(int index, int length) {
    _currentPageNotifier.value = index;
    firstIndex = index == 0;
    lastIndex = length == index + 1;
  }
}
