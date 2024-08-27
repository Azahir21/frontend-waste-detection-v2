import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';

class CenteredTextButton extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final bool isEnabled;
  final Function() onTap;
  final Color color;
  final Color disabledColor;
  final double width;
  final double height;

  const CenteredTextButton._internal({
    Key? key,
    required this.label,
    required this.isPrimary,
    required this.isEnabled,
    required this.onTap,
    required this.color,
    required this.disabledColor,
    required this.height,
    required this.width,
  }) : super(key: key);

  factory CenteredTextButton.primary({
    Key? key,
    required String label,
    bool isEnabled = true,
    required Function() onTap,
    required BuildContext context,
    double width = 350,
    double height = 50.0,
  }) {
    return CenteredTextButton._internal(
      key: key,
      label: label,
      isPrimary: true,
      isEnabled: isEnabled,
      onTap: onTap,
      color: Theme.of(context).appColors.backgroundActionPrimary,
      disabledColor:
          Theme.of(context).appColors.backgroundActionPrimaryDisabled,
      width: width,
      height: height,
    );
  }

  factory CenteredTextButton.secondary({
    Key? key,
    required String label,
    bool isEnabled = true,
    required Function() onTap,
    required BuildContext context,
    double width = 350,
    double height = 50.0,
  }) {
    return CenteredTextButton._internal(
      key: key,
      label: label,
      isPrimary: false,
      isEnabled: isEnabled,
      onTap: onTap,
      color: Colors.white,
      disabledColor:
          Theme.of(context).appColors.backgroundActionSecondaryDisabled,
      width: width,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: isEnabled ? onTap : null,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return disabledColor;
                }
                return color;
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isPrimary
                      ? Colors.transparent
                      : Theme.of(context)
                          .appColors
                          .backgroundDefault, // Conditional border color
                  width: 1.5, // Border width
                ),
              ),
            ),
          ),
          child: isPrimary
              ? AppText.labelSmallEmphasis(
                  label,
                  context: context,
                  color: Colors.white,
                )
              : AppText.labelSmallEmphasis(label,
                  context: context,
                  color: Theme.of(context).appColors.textPrimary),
        ),
      ),
    );
  }
}
