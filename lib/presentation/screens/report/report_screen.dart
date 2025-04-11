import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/models/report/report_model.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/report/report_contoller.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';
import 'package:restaurant_manager_mobile/utils/formats.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReportContoller>();

    return Scaffold(
      body: Column(
        children: [
          const Header(
            title: 'Báo cáo',
            showBackButton: true,
          ),
          Expanded(
            child: Obx(() {
              final list = controller.reportList;
              if (list.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.report_gmailerrorred,
                          size: 60, color: Colors.grey),
                      SizedBox(height: 8),
                      Text("Không có báo cáo",
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ],
                  ),
                );
              }

              return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final report = list[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report.note,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.person,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text('Nhân viên: ${report.employeeName}'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () =>
                                  showReportDetails(controller, report),
                              icon: const Icon(Icons.visibility),
                              label: const Text("Xem chi tiết"),
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.orange),
                            ),
                          )
                        ],
                      ),
                    );
                  });
            }),
          ),
        ],
      ),
    );
  }

  void showReportDetails(ReportContoller controller, ReportModel report) async {
    await controller.fetchReportDetail(report.idReport);

    if (controller.reportDetailResponse.value == null) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text('Không có thông tin chi tiết để xem')),
      );
      return;
    }

    final detail = controller.reportDetailResponse.value!;
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Chi tiết báo cáo",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                _buildLabelValue("Nhân viên", detail.employeeName),
                const SizedBox(height: 8),
                _buildLabelValue("Ngày", formatWorkDate(detail.workDayStart)),
                const SizedBox(height: 10),
                _buildLabelValue("Ghi chú", detail.note),
                const SizedBox(height: 10),
                if (detail.reportImages.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hình ảnh đính kèm",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700])),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 80,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: detail.reportImages.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final imageUrl = detail.reportImages[index].url;
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.broken_image),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  onPressed: () => Get.back(),
                  child: const Text("Đóng"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabelValue(String label, String value) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        children: [
          TextSpan(
              text: "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
