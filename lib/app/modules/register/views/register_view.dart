import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/register/controllers/register_controller.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/centered_text_button.dart';
import 'package:frontend_waste_management/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management/app/widgets/dropdown.dart';
import 'package:frontend_waste_management/app/widgets/form.dart';
import 'package:frontend_waste_management/app/widgets/icon_button.dart';
import 'package:frontend_waste_management/app/widgets/text_button.dart';
import 'package:frontend_waste_management/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:frontend_waste_management/core/values/app_icon_name.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);

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
                  VerticalGap.formMedium(),
                  _buildNameField(),
                  VerticalGap.formMedium(),
                  _buildGenderDropdown(),
                  VerticalGap.formMedium(),
                  _buildUsernameField(),
                  VerticalGap.formMedium(),
                  _buildEmailField(),
                  VerticalGap.formMedium(),
                  _buildPasswordField(),
                  VerticalGap.formSmall(),
                  VerticalGap.formMedium(),
                  _buildAgreementCheckbox(context),
                  VerticalGap.formMedium(),
                  _buildRegisterButton(context),
                  VerticalGap.formMedium(),
                  _buildLoginNowRow(context),
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
      child: AppText.labelBigEmphasis(AppLocalizations.of(context)!.register,
          context: context),
    );
  }

  Widget _buildSubHeaderText(BuildContext context) {
    return Center(
      child: AppText.labelDefaultDefault(
        AppLocalizations.of(context)!.create_account,
        context: context,
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomForm.text(
          width: double.infinity,
          labelText: AppLocalizations.of(Get.context!)!.full_name,
          onChanged: (value) {
            controller.fullName = value;
            if (controller.fullNameError.value != null) {
              controller.fullNameError.value = null;
            }
          },
        ),
        Obx(() => Visibility(
              visible: controller.fullNameError.value != null,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  controller.fullNameError.value ?? '',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDropdown(
          onChanged: (value) {
            controller.gender = value;
          },
          dropDownItems: [
            AppLocalizations.of(Get.context!)!.male,
            AppLocalizations.of(Get.context!)!.female
          ],
          labelText: AppLocalizations.of(Get.context!)!.gender,
          width: double.infinity,
          height: 70,
        ),
        Obx(() => Visibility(
              visible: controller.genderError.value != null,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  controller.genderError.value ?? '',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomForm.text(
          width: double.infinity,
          labelText: AppLocalizations.of(Get.context!)!.username,
          onChanged: (value) {
            controller.username = value;
          },
        ),
        Obx(() => Visibility(
              visible: controller.usernameError.value != null,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  controller.usernameError.value ?? '',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            )),
      ],
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

  Widget _buildAgreementCheckbox(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          Checkbox(
            value: controller.isAgree,
            onChanged: (value) {
              controller.isAgree = value!;
            },
          ),
          Flexible(
            child: AppText.labelSmallEmphasis(
              AppLocalizations.of(context)!.terms_and_conditions_aggrement,
              context: context,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return CenteredTextButton.primary(
      width: double.infinity,
      label: AppLocalizations.of(context)!.register,
      context: context,
      onTap: () {
        if (controller.validateInputs()) {
          controller.register();
        }
      },
    );
  }

  Widget _buildLoginNowRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText.textPrimary(AppLocalizations.of(context)!.have_account,
            context: context),
        CustomTextButton.primary(
          text: AppLocalizations.of(context)!.login,
          onPressed: () {
            Get.toNamed("/login");
          },
          context: context,
        ),
      ],
    );
  }
}
