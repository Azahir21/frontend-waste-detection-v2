import 'package:flutter/material.dart';
import 'package:frontend_waste_management/core/theme/color_theme.dart';
import 'package:frontend_waste_management/core/theme/dimension_theme.dart';
import 'package:frontend_waste_management/core/theme/text_theme.dart';

extension ThemeDataExtended on ThemeData {
  AppDimensionsTheme get appDimensions => extension<AppDimensionsTheme>()!;
  AppColorsTheme get appColors => extension<AppColorsTheme>()!;
  AppTextsTheme get appTexts => extension<AppTextsTheme>()!;
}
