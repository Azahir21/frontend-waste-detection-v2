import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/login/controllers/login_controller.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/centered_text_button.dart';
import 'package:frontend_waste_management/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management/app/widgets/form.dart';
import 'package:frontend_waste_management/app/widgets/icon_button.dart';
import 'package:frontend_waste_management/app/widgets/text_button.dart';
import 'package:frontend_waste_management/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:frontend_waste_management/core/values/app_icon_name.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

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
                  VerticalGap.formSmall(),
                  _buildSubHeaderText(context),
                  VerticalGap.formBig(),
                  _buildEmailField(),
                  VerticalGap.formBig(),
                  _buildPasswordField(),
                  VerticalGap.formBig(),
                  _buildForgotPasswordButton(context),
                  VerticalGap.formHuge(),
                  _buildLoginButton(context),
                  VerticalGap.formHuge(),
                  _buildRegisterNowRow(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomIconButton.secondary(
          iconName: AppIconName.backButton,
          onTap: () {
            Get.back();
          },
          context: context,
        ),
      ],
    );
  }

  Widget _buildHeaderText(BuildContext context) {
    return Center(
      child: AppText.labelBigEmphasis(AppLocalizations.of(context)!.login,
          context: context),
    );
  }

  Widget _buildSubHeaderText(BuildContext context) {
    return Center(
      child: AppText.labelDefaultDefault(
        AppLocalizations.of(context)!.welcome,
        context: context,
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomForm.email(
          width: double.infinity,
          labelText: AppLocalizations.of(Get.context!)!.email,
          onChanged: (value) {
            controller.email = value;
            if (controller.emailError.value != null) {
              controller.emailError.value = null;
            }
          },
        ),
        Obx(() => Visibility(
              visible: controller.emailError.value != null,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  controller.emailError.value ?? '',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomForm.password(
          width: double.infinity,
          labelText: AppLocalizations.of(Get.context!)!.password,
          onChanged: (value) {
            controller.password = value;
            if (controller.passwordError.value != null) {
              controller.passwordError.value = null;
            }
          },
        ),
        Obx(() => Visibility(
              visible: controller.passwordError.value != null,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  controller.passwordError.value ?? '',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildForgotPasswordButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomTextButton.primary(
          text: AppLocalizations.of(context)!.forgot_password,
          onPressed: () {
            Get.toNamed("/forget-password");
          },
          context: context,
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return CenteredTextButton.primary(
      width: double.infinity,
      label: AppLocalizations.of(context)!.login,
      onTap: () {
        if (controller.validateInputs()) {
          controller.login();
        }
      },
      context: context,
    );
  }

  Widget _buildRegisterNowRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText.textPrimary(
            "${AppLocalizations.of(context)!.dont_have_account}  ",
            context: context),
        CustomTextButton.primary(
          text: AppLocalizations.of(context)!.register,
          onPressed: () {
            Get.offNamed("/register");
          },
          context: context,
        ),
        AppText.textPrimary(" ${AppLocalizations.of(context)!.now}",
            context: context),
      ],
    );
  }
}
