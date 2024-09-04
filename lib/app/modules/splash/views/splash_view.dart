import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/splash/controllers/splash_controller.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashView extends GetView<SplashController> {
  SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: Theme.of(context).appColors.backgroundGradient,
        ),
        child: Center(
          child: Obx(() {
            if (!controller.isLoading.value) {
              return const SizedBox.shrink(); // Empty widget if not loading
            } else {
              return const SplashContent();
            }
          }),
        ),
      ),
    );
  }
}

class SplashContent extends StatelessWidget {
  const SplashContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: const BoxDecoration(
            // borderRadius: BorderRadius.circular(30),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.shade300,
            //     blurStyle: BlurStyle.outer,
            //     blurRadius: 6.0,
            //   ),
            // ],
            image: DecorationImage(
              image: AssetImage('assets/images/logo.png'),
              // image: AssetImage('assets/images/logov2.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            // "KOLEKAN",
            AppLocalizations.of(context)!.app_title.toUpperCase(),
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
