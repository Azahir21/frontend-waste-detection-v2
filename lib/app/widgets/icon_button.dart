import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/widgets/app_icon.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:frontend_waste_management/core/values/app_icon_name.dart';

class CustomIconButton extends StatelessWidget {
  final AppIconName iconName;
  final bool isPrimary;
  final bool isEnabled;
  final bool isBordered;
  final bool isActive;
  final Function() onTap;
  final Color color;
  final Color disabledColor;
  final Color iconColor;
  final double width;
  final double height;
  final double iconSize;

  const CustomIconButton._internal({
    Key? key,
    required this.iconName,
    required this.isPrimary,
    required this.isEnabled,
    required this.isBordered,
    required this.isActive,
    required this.onTap,
    required this.color,
    required this.disabledColor,
    required this.iconColor,
    required this.width,
    required this.height,
    required this.iconSize,
  }) : super(key: key);

  /// Uses the first widget’s color scheme for primary buttons.
  factory CustomIconButton.primary({
    Key? key,
    required AppIconName iconName,
    bool isEnabled = true,
    required Function() onTap,
    required BuildContext context,
    double width = 50.0,
    double height = 50.0,
    double iconSize = 32.0,
  }) {
    return CustomIconButton._internal(
      key: key,
      iconName: iconName,
      isPrimary: true,
      isEnabled: isEnabled,
      isBordered: false,
      isActive: true,
      onTap: onTap,
      color: Theme.of(context).appColors.backgroundActionIconPrimary,
      disabledColor:
          Theme.of(context).appColors.backgroundActionIconPrimaryDisable,
      iconColor: Theme.of(context).appColors.iconDefault,
      width: width,
      height: height,
      iconSize: iconSize,
    );
  }

  /// Uses the first widget’s color scheme for secondary buttons.
  factory CustomIconButton.secondary({
    Key? key,
    required AppIconName iconName,
    bool isEnabled = true,
    required Function() onTap,
    required BuildContext context,
    double width = 50.0,
    double height = 50.0,
    double iconSize = 32.0,
  }) {
    return CustomIconButton._internal(
      key: key,
      iconName: iconName,
      isPrimary: false,
      isEnabled: isEnabled,
      isBordered: false,
      isActive: true,
      onTap: onTap,
      color: Theme.of(context).appColors.backgroundActionIconSecondary,
      disabledColor:
          Theme.of(context).appColors.backgroundActionIconSecondaryDisabled,
      iconColor: Theme.of(context).appColors.iconActivate,
      width: width,
      height: height,
      iconSize: iconSize,
    );
  }

  /// For a bordered button with active state (using the second widget’s style).
  factory CustomIconButton.activeBordered({
    Key? key,
    required AppIconName iconName,
    bool isEnabled = true,
    required Function() onTap,
    required BuildContext context,
    double width = 50.0,
    double height = 50.0,
    double iconSize = 32.0,
  }) {
    return CustomIconButton._internal(
      key: key,
      iconName: iconName,
      isPrimary: true,
      isEnabled: isEnabled,
      isBordered: true,
      isActive: true,
      onTap: onTap,
      color: Theme.of(context).appColors.backgroundActionIconPrimary,
      // For bordered variants, we still provide a disabledColor even if it is not used in the second widget’s version.
      disabledColor:
          Theme.of(context).appColors.backgroundActionIconPrimaryDisable,
      iconColor: Theme.of(context).appColors.iconActivate,
      width: width,
      height: height,
      iconSize: iconSize,
    );
  }

  /// For a bordered button with inactive state (using the second widget’s style).
  factory CustomIconButton.inactiveBordered({
    Key? key,
    required AppIconName iconName,
    bool isEnabled = true,
    required Function() onTap,
    required BuildContext context,
    double width = 50.0,
    double height = 50.0,
    double iconSize = 32.0,
  }) {
    return CustomIconButton._internal(
      key: key,
      iconName: iconName,
      isPrimary: true,
      isEnabled: isEnabled,
      isBordered: true,
      isActive: false,
      onTap: onTap,
      color: Theme.of(context).appColors.backgroundActionIconPrimary,
      disabledColor:
          Theme.of(context).appColors.backgroundActionIconPrimaryDisable,
      iconColor: Theme.of(context).appColors.iconDefault,
      width: width,
      height: height,
      iconSize: iconSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use disabledColor if not enabled.
    final effectiveColor = isEnabled ? color : disabledColor;
    // Determine box shadow behavior: if bordered (second widget style) use one logic, otherwise use the first widget's logic.
    final boxShadow = [
      BoxShadow(
        color: isBordered
            ? (isPrimary ? Colors.black.withOpacity(0.2) : Colors.transparent)
            : (!isPrimary ? Colors.black.withOpacity(0.2) : Colors.transparent),
        offset: const Offset(0, 3),
        blurRadius: 6,
      ),
    ];

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: effectiveColor,
          borderRadius: BorderRadius.circular(isBordered ? 20.0 : 23.0),
          boxShadow: boxShadow,
          border: isBordered
              ? Border.all(
                  color: isActive
                      ? Theme.of(context).appColors.iconActivate
                      : Theme.of(context).appColors.iconDefault,
                  width: 3.0,
                )
              : null,
        ),
        child: Center(
          child: AppIcon.custom(
            appIconName: iconName,
            color: iconColor,
            size: iconSize,
            context: context,
          ),
        ),
      ),
    );
  }
}
