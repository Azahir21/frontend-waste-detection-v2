import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/recycle/controllers/recycle_controller.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management/app/widgets/icon_button.dart';
import 'package:frontend_waste_management/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:frontend_waste_management/core/values/app_icon_name.dart';
import 'package:get/get.dart';

class SmallScreenRecycleView extends GetView<RecycleController> {
  const SmallScreenRecycleView({super.key});

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).appColors;
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: color.backgroundGradient,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 32, 32, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomIconButton.secondary(
                    iconName: AppIconName.backButton,
                    onTap: () {
                      Get.back();
                    },
                    context: context,
                  ),
                  VerticalGap.formMedium(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: size.width * 0.35,
                        width: size.width * 0.35,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(23.0),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/recycle.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      HorizontalGap.formBig(),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.labelSmallEmphasis(
                              "Botol Plastik",
                              context: context,
                            ),
                            VerticalGap.formMedium(),
                            AppText.labelSmallDefault(
                              "Pot Bungah",
                              textOverflow: TextOverflow.ellipsis,
                              maxLines: 4,
                              context: context,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  VerticalGap.formBig(),
                  AppText.labelDefaultEmphasis(
                    "Alat dan Bahan",
                    context: context,
                  ),
                  VerticalGap.formSmall(),
                  AppText.labelSmallDefault("1. Botol Plastik Bekas",
                      context: context),
                  AppText.labelSmallDefault("2. Gunting / Cutter",
                      context: context),
                  AppText.labelSmallDefault("3. Benang pancing",
                      context: context),
                  AppText.labelSmallDefault("4. Paku", context: context),
                  VerticalGap.formMedium(),
                  AppText.labelDefaultEmphasis(
                    "Langkah-langkah",
                    context: context,
                  ),
                  VerticalGap.formSmall(),
                  AppText.labelSmallDefault(
                      "1. Siapakan 1 botol plastik bekas, setelah itu potong tengah yang bagian samping menggunakan gunting / cutter",
                      context: context),
                  AppText.labelSmallDefault(
                      "2. Setelah itu buat lubang dengan menggunakan paku disekitar potongan botol plastik itu",
                      context: context),
                  AppText.labelSmallDefault(
                      "3. Kemudian buat gantungan diatas potongan botol itu",
                      context: context),
                  AppText.labelSmallDefault(
                      "4. Dan tinggal ngisi tanah dan tanaman, Jadilah pot bunga dari botol plastik bekas",
                      context: context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
