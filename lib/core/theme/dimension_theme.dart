import 'dart:ui';

import 'package:flutter/material.dart';

class AppDimensionsTheme extends ThemeExtension<AppDimensionsTheme> {
  final double radiusHelpIndication;
  final EdgeInsets paddingHelpIndication;

  const AppDimensionsTheme._internal({
    required this.radiusHelpIndication,
    required this.paddingHelpIndication,
  });

  factory AppDimensionsTheme.main(FlutterView flutterView) =>
      AppDimensionsTheme._internal(
        radiusHelpIndication: flutterView.isRegularSmartphoneOrLess
            ? 8
            : 16, // <- responsive here!
        paddingHelpIndication:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      );

  @override
  ThemeExtension<AppDimensionsTheme> copyWith() {
    return AppDimensionsTheme._internal(
      radiusHelpIndication: radiusHelpIndication,
      paddingHelpIndication: paddingHelpIndication,
    );
  }

  @override
  ThemeExtension<AppDimensionsTheme> lerp(
          covariant ThemeExtension<AppDimensionsTheme>? other, double t) =>
      this;
}

extension FlutterViewExtended on FlutterView {
  static const double responsive360 = 360;
  static const double responsive480 = 480;
  static const double responsive600 = 600;
  static const double responsive800 = 800;
  static const double responsive900 = 900;
  static const double responsive1200 = 1200;

  double get logicalWidth => physicalSize.width / devicePixelRatio;
  double get logicalHeight => physicalSize.height / devicePixelRatio;
  double get logicalWidthSA =>
      (physicalSize.width - padding.left - padding.right) / devicePixelRatio;
  double get logicalHeightSA =>
      (physicalSize.height - padding.top - padding.bottom) / devicePixelRatio;

  bool get isSmallSmartphone {
    if (logicalWidthSA < logicalHeightSA) {
      return (logicalWidthSA <= responsive360 ||
          logicalHeightSA <= responsive600);
    } else {
      return (logicalWidthSA <= responsive600 ||
          logicalHeightSA <= responsive360);
    }
  }

  bool get isRegularSmartphoneOrLess {
    if (logicalWidthSA < logicalHeightSA) {
      return (logicalWidthSA <= responsive480 ||
          logicalHeightSA <= responsive800);
    } else {
      return (logicalWidthSA <= responsive800 ||
          logicalHeightSA <= responsive480);
    }
  }

  bool get isSmallTabletOrLess {
    if (logicalWidthSA < logicalHeightSA) {
      return (logicalWidthSA <= responsive600 ||
          logicalHeightSA <= responsive900);
    } else {
      return (logicalWidthSA <= responsive900 ||
          logicalHeightSA <= responsive600);
    }
  }

  bool get isRegularTabletOrLess {
    if (logicalWidthSA < logicalHeightSA) {
      return (logicalWidthSA <= responsive800 ||
          logicalHeightSA <= responsive1200);
    } else {
      return (logicalWidthSA <= responsive1200 ||
          logicalHeightSA <= responsive800);
    }
  }
}
