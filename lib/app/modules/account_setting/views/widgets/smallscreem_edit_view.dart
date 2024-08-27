import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/account_setting/controllers/account_setting_controller.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/centered_text_button.dart';
import 'package:frontend_waste_management/app/widgets/dropdown.dart';
import 'package:frontend_waste_management/app/widgets/form.dart';
import 'package:frontend_waste_management/app/widgets/icon_button.dart';
import 'package:frontend_waste_management/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:frontend_waste_management/core/values/app_icon_name.dart';
import 'package:get/get.dart';

class SmallScreenEditProvileView extends GetView<AccountSettingController> {
  const SmallScreenEditProvileView({super.key});

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).appColors;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: color.backgroundGradient,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 32, 32, 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconButton.secondary(
                        iconName: AppIconName.backButton,
                        onTap: () {
                          Get.back();
                        },
                        context: context,
                      ),
                      Expanded(
                        child: Center(
                          child: AppText.labelDefaultEmphasis(
                            "Pengaturan Akun",
                            context: context,
                          ),
                        ),
                      )
                    ],
                  ),
                  VerticalGap.formHuge(),
                  _buildNameField(),
                  VerticalGap.formMedium(),
                  _buildUsernameField(),
                  VerticalGap.formMedium(),
                  _buildPhoneField(),
                  VerticalGap.formMedium(),
                  _buildGenderDropdown(),
                  VerticalGap.formMedium(),
                  _buildStreetField(),
                  VerticalGap.formMedium(),
                  _buildRTField(),
                  VerticalGap.formMedium(),
                  _buildRWField(),
                  VerticalGap.formMedium(),
                  _buildVillageField(),
                  VerticalGap.formMedium(),
                  _buildSubDistrictField(),
                  VerticalGap.formMedium(),
                  _buildRegencyField(),
                  VerticalGap.formMedium(),
                  _buildProvinceField(),
                  VerticalGap.formMedium(),
                  _buildKodePosField(),
                  VerticalGap.formBig(),
                  CenteredTextButton.primary(
                    label: "Simpan",
                    onTap: () {
                      Get.toNamed('/edit-profile');
                    },
                    context: context,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return CustomForm.text(
      width: double.infinity,
      labelText: "Nama Lengkap",
      onChanged: (value) {},
    );
  }

  Widget _buildGenderDropdown() {
    return CustomDropdown(
      onChanged: (value) {
        print(value);
      },
      dropDownItems: const ["Laki-laki", "Perempuan"],
      labelText: "Jenis Kelamin",
      width: double.infinity,
      height: 70,
    );
  }

  Widget _buildUsernameField() {
    return CustomForm.text(
      width: double.infinity,
      labelText: "Username",
      onChanged: (value) {},
    );
  }

  Widget _buildPhoneField() {
    return CustomForm.phone(
      width: double.infinity,
      labelText: "Nomor Telepon",
      onChanged: (value) {},
    );
  }

  Widget _buildStreetField() {
    return CustomForm.text(
      width: double.infinity,
      labelText: "Jalan",
      onChanged: (value) {},
    );
  }

  Widget _buildRTField() {
    return CustomForm.text(
      width: double.infinity,
      labelText: "RT",
      onChanged: (value) {},
    );
  }

  Widget _buildRWField() {
    return CustomForm.text(
      width: double.infinity,
      labelText: "RW",
      onChanged: (value) {},
    );
  }

  Widget _buildVillageField() {
    return CustomForm.text(
      width: double.infinity,
      labelText: "Kelurahan / Desa",
      onChanged: (value) {},
    );
  }

  Widget _buildSubDistrictField() {
    return CustomForm.text(
      width: double.infinity,
      labelText: "Kacamatan",
      onChanged: (value) {},
    );
  }

  Widget _buildRegencyField() {
    return CustomForm.text(
      width: double.infinity,
      labelText: "Kabupaten / kota",
      onChanged: (value) {},
    );
  }

  Widget _buildProvinceField() {
    return CustomForm.text(
      width: double.infinity,
      labelText: "Provinsi",
      onChanged: (value) {},
    );
  }

  Widget _buildKodePosField() {
    return CustomForm.number(
      width: double.infinity,
      labelText: "Kode Pos",
      onChanged: (value) {},
    );
  }
}
