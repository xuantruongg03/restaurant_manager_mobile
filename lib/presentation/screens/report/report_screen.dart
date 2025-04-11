import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/report/report_contoller.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

@override
  Widget build(BuildContext context) {
    final controller = Get.find<ReportContoller>();

    return const Scaffold(
      body: Column(
        children: [
          const Header(
            title: 'Báo cáo',
            showBackButton: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: const Text('This is report view'),
              )
            ),
          ),
        ],
      ),
    );
  }
}
