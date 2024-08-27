import 'package:flutter/material.dart';

class AppColorsTheme extends ThemeExtension<AppColorsTheme> {
  // reference colors:
  static const _grey = Color(0xFFA0B7B0);
  static const _green = Color(0xFF17C690);
  static const _teal = Color(0xFF9DA4B1);
  static const _red = Color(0xFFED4E52);
  static const _darkgreen = Color(0xFF114C3A);
  static const _paleblue = Color(0xFFE8F9F4);
  static const _lightgrayblue = Color(0xffE8EEEC);

  // actual colors used throughout the app:
  final LinearGradient backgroundGradient;
  final Color backgroundDefault;
  final Color backgroundInput;
  final Color snackbarValidation;
  final Color snackbarError;
  final Color textPrimary;
  final Color textButton;
  final Color textSecondary;
  final Color textDisabled;
  final Color backgroundActionPrimary;
  final Color backgroundActionPrimaryDisabled;
  final Color backgroundActionSecondary;
  final Color backgroundActionSecondaryDisabled;
  final Color backgroundActionIconPrimary;
  final Color backgroundActionIconPrimaryDisable;
  final Color backgroundActionIconSecondary;
  final Color backgroundActionIconSecondaryDisabled;
  final Color iconDefault;
  final Color iconActivate;
  final Color iconDisable;
  final Color iconDefaultReversed;
  final Color formFieldBorder;

  // private constructor (use factories below instead):
  const AppColorsTheme._internal({
    required this.backgroundGradient,
    required this.backgroundDefault,
    required this.backgroundInput,
    required this.snackbarValidation,
    required this.snackbarError,
    required this.textPrimary,
    required this.textButton,
    required this.textSecondary,
    required this.textDisabled,
    required this.backgroundActionPrimary,
    required this.backgroundActionPrimaryDisabled,
    required this.backgroundActionSecondary,
    required this.backgroundActionSecondaryDisabled,
    required this.backgroundActionIconPrimary,
    required this.backgroundActionIconPrimaryDisable,
    required this.backgroundActionIconSecondary,
    required this.backgroundActionIconSecondaryDisabled,
    required this.iconDefault,
    required this.iconActivate,
    required this.iconDisable,
    required this.iconDefaultReversed,
    required this.formFieldBorder,
  });

  // factory for light mode:
  factory AppColorsTheme.light() {
    return const AppColorsTheme._internal(
      backgroundGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xffD0f3E8), Colors.white],
        tileMode: TileMode.decal,
        stops: [.001, 0.1],
      ),
      backgroundDefault: _grey,
      backgroundInput: _teal,
      snackbarValidation: _green,
      snackbarError: _red,
      textPrimary: _darkgreen,
      textButton: _green,
      textSecondary: _teal,
      textDisabled: _grey,
      backgroundActionPrimary: _darkgreen,
      backgroundActionPrimaryDisabled: _grey,
      backgroundActionSecondary: _teal,
      backgroundActionSecondaryDisabled: _grey,
      backgroundActionIconPrimary: _paleblue,
      backgroundActionIconPrimaryDisable: _grey,
      backgroundActionIconSecondary: Colors.white,
      backgroundActionIconSecondaryDisabled: _grey,
      iconDefault: _green,
      iconActivate: _darkgreen,
      iconDisable: _teal,
      iconDefaultReversed: Colors.white,
      formFieldBorder: _lightgrayblue,
    );
  }

  // factory for dark mode:
  factory AppColorsTheme.dark() {
    return const AppColorsTheme._internal(
      backgroundGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [_darkgreen, Colors.black],
      ),
      backgroundDefault: _grey,
      backgroundInput: _grey,
      snackbarValidation: _green,
      snackbarError: _red,
      textPrimary: _grey,
      textSecondary: _grey,
      textDisabled: _grey,
      textButton: _green,
      backgroundActionPrimary: _grey,
      backgroundActionPrimaryDisabled: _grey,
      backgroundActionSecondary: _grey,
      backgroundActionSecondaryDisabled: _grey,
      backgroundActionIconPrimary: _paleblue,
      backgroundActionIconPrimaryDisable: _grey,
      backgroundActionIconSecondary: Colors.white,
      backgroundActionIconSecondaryDisabled: _grey,
      iconDefault: _green,
      iconActivate: _darkgreen,
      iconDisable: _teal,
      iconDefaultReversed: Colors.white,
      formFieldBorder: _lightgrayblue,
    );
  }

  @override
  ThemeExtension<AppColorsTheme> copyWith({bool? lightMode}) {
    if (lightMode == null || lightMode == true) {
      return AppColorsTheme.light();
    }
    return AppColorsTheme.dark();
  }

  @override
  ThemeExtension<AppColorsTheme> lerp(
          covariant ThemeExtension<AppColorsTheme>? other, double t) =>
      this;
}
