import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/report_detail/views/largescreen_report_detail_view.dart';
import 'package:frontend_waste_management/app/modules/report_detail/views/smallscreen_report_detail_view.dart';

import 'package:get/get.dart';

import '../controllers/report_detail_controller.dart';

class ReportDetailView extends GetView<ReportDetailController> {
  const ReportDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return SmallScreenReportDetailView();
        } else {
          return LargeScreenReportDetailView();
        }
      }),
    );
  }
}
