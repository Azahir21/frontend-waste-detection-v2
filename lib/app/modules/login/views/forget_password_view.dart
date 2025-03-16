import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/login/controllers/login_controller.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/centered_text_button.dart';
import 'package:frontend_waste_management/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management/app/widgets/form.dart';
import 'package:frontend_waste_management/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgetPasswordView extends GetView<LoginController> {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: Theme.of(context).appColors.backgroundGradient,
            ),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeaderText(context),
                  VerticalGap.formHuge(),
                  _buildEmailField(),
                  VerticalGap.formMedium(),
                  _buildUsernameField(),
                  VerticalGap.formMedium(),
                  _buildPasswordField(),
                  VerticalGap.formSmall(),
                  Obx(() {
                    return Visibility(
                      visible: !controller.validPassword.value,
                      child: AppText.textPrimary(controller.massage.value,
                          context: context),
                    );
                  }),
                  VerticalGap.formBig(),
                  _buildSendButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderText(BuildContext context) {
    return AppText.labelDefaultEmphasis(
        AppLocalizations.of(context)!.forget_password,
        context: context);
  }

  Widget _buildEmailField() {
    return CustomForm.email(
      width: double.infinity,
      labelText: AppLocalizations.of(Get.context!)!.email,
      onChanged: (value) {
        controller.resetEmail = value;
      },
    );
  }

  Widget _buildUsernameField() {
    return CustomForm.text(
      width: double.infinity,
      labelText: AppLocalizations.of(Get.context!)!.username,
      onChanged: (value) {
        controller.resetUsername = value;
      },
    );
  }

  Widget _buildPasswordField() {
    return CustomForm.password(
      width: double.infinity,
      labelText: AppLocalizations.of(Get.context!)!.password,
      onChanged: (value) {
        controller.resetPassword = value;
      },
    );
  }

  Widget _buildSendButton(BuildContext context) {
    return CenteredTextButton.primary(
      width: double.infinity,
      label: AppLocalizations.of(context)!.send,
      onTap: () {
        if (controller.resetEmail.isEmpty ||
            controller.resetPassword.isEmpty ||
            controller.resetUsername.isEmpty) {
          showFailedSnackbar(AppLocalizations.of(context)!.attention,
              AppLocalizations.of(context)!.all_fields_must_be_filled);
          return;
        }
        if (!controller.validateEmail(controller.resetEmail)) {
          return;
        }
        controller.validatePassword(controller.resetPassword);
        if (controller.validPassword.value) {
          controller.forgotPassword();
        }
      },
      context: context,
    );
  }
}
