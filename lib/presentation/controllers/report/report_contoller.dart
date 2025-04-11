import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/models/report/report_model.dart';
import 'package:restaurant_manager_mobile/data/repositories/report/report_repository.dart';

class ReportContoller extends GetxController {
  final ReportRepository reportRepository;

  ReportContoller({required this.reportRepository});

  final RxList<ReportModel> reportList = <ReportModel>[].obs;
  final Rxn<ReportModel> reportDetailResponse = Rxn<ReportModel>();

  @override
  void onInit() {
    super.onInit();
    fetchReports();
  }

  Future<void> fetchReports() async {
    final result = await reportRepository.getReportList();
    reportList.value = result ?? [];
  }

  Future<void> fetchReportDetail(String idReport) async {
    reportDetailResponse.value =
        reportList.firstWhereOrNull((e) => e.idReport == idReport);
  }
}
