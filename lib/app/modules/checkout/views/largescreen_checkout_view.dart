import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:get/get.dart';

class LargeScreenCheckoutView extends GetView<CheckoutController> {
  const LargeScreenCheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("checkout is working on large screen"),
      ),
    );
  }
}
