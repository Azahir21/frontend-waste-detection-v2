import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/login/controllers/login_controller.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/centered_text_button.dart';
import 'package:frontend_waste_management/app/widgets/form.dart';
import 'package:frontend_waste_management/app/widgets/icon_button.dart';
import 'package:frontend_waste_management/app/widgets/text_button.dart';
import 'package:frontend_waste_management/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:frontend_waste_management/core/values/app_icon_name.dart';
import 'package:get/get.dart';

class SmallScreenLoginView extends GetView<LoginController> {
  const SmallScreenLoginView({Key? key}) : super(key: key);

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
                  _buildBackButton(context),
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
      child: AppText.labelBigEmphasis("Masuk", context: context),
    );
  }

  Widget _buildSubHeaderText(BuildContext context) {
    return Center(
      child: AppText.labelDefaultDefault(
        "Selamat datang kembali!",
        context: context,
      ),
    );
  }

  Widget _buildEmailField() {
    return CustomForm.email(
      width: double.infinity,
      labelText: "Email",
      onChanged: (value) {
        controller.email = value;
      },
    );
  }

  Widget _buildPasswordField() {
    return CustomForm.password(
      width: double.infinity,
      labelText: "Password",
      onChanged: (value) {
        controller.password = value;
      },
    );
  }

  Widget _buildForgotPasswordButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomTextButton.primary(
          text: "Lupa Password?",
          onPressed: () {},
          context: context,
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return CenteredTextButton.primary(
      width: double.infinity,
      label: "Masuk",
      onTap: () {
        if (controller.email.isEmpty || controller.password.isEmpty) {
          Get.snackbar('Input Error', 'Email and password cannot be empty.');
          return;
        }
        controller.login();
      },
      context: context,
    );
  }

  Widget _buildRegisterNowRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText.textPrimary("Belum memiliki akun? ", context: context),
        CustomTextButton.primary(
          text: "Daftar",
          onPressed: () {
            Get.offNamed("/register");
          },
          context: context,
        ),
        AppText.textPrimary(" Sekarang", context: context),
      ],
    );
  }
}
