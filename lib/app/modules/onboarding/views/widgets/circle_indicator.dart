import 'package:flutter/material.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class CircleIndicator extends StatelessWidget {
  const CircleIndicator({
    super.key,
    required this.currentPageNotifier,
  });
  final ValueNotifier<int> currentPageNotifier;

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).appColors;
    return CirclePageIndicator(
      size: 8.0,
      selectedSize: 8.0,
      dotColor: color.iconDisable,
      selectedDotColor: color.iconDefault,
      itemCount: 3,
      currentPageNotifier: currentPageNotifier,
    );
  }
}
