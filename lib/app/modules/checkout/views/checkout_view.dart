import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/checkout/views/largescreen_checkout_view.dart';
import 'package:frontend_waste_management/app/modules/checkout/views/smallscreen_checkout_view.dart';

import 'package:get/get.dart';

import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return SmallScreenCheckoutView();
        } else {
          return LargeScreenCheckoutView();
        }
      }),
    );
  }
}
