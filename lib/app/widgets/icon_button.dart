import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/widgets/app_icon.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:frontend_waste_management/core/values/app_icon_name.dart';

class CustomIconButton extends StatelessWidget {
  final AppIconName iconName;
  final bool isPrimary;
  final bool isEnabled;
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
    required this.onTap,
    required this.color,
    required this.disabledColor,
    required this.iconColor,
    required this.width,
    required this.height,
    required this.iconSize,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isEnabled ? color : disabledColor,
          borderRadius: BorderRadius.circular(23.0),
          boxShadow: [
            BoxShadow(
              color: !isPrimary
                  ? Colors.black.withOpacity(0.2)
                  : Colors.transparent,
              offset: const Offset(0, 3),
              blurRadius: 6,
            ),
          ],
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
