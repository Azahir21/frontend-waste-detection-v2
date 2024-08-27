import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/report_detail/controllers/report_detail_controller.dart';
import 'package:get/get.dart';

class LargeScreenReportDetailView extends GetView<ReportDetailController> {
  const LargeScreenReportDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReportDetailView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ReportDetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
