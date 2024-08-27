import 'package:flutter/material.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';

class LargeScreenOnboardingView extends StatelessWidget {
  const LargeScreenOnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: Theme.of(context).appColors.backgroundGradient,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("large screen"),
            ],
          ),
        ),
      ),
    );
  }
}
