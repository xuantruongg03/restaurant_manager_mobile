import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/tables/table_controller.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';

class TableScreen extends GetView<TablesController> {
  const TableScreen({super.key});

  Widget _buildTableItem(
      {required String idTable,
      required String name,
      required String status,
      required String time,
      required String colorMerge,
      required bool isMerge}) {
    return GestureDetector(
      onLongPress: () => controller.showQRModal(name, idTable),
      onTap: () => {
        if (status != "Available") {
          Get.toNamed(RouteNames.bill, arguments: {
            "idTable": idTable,
            "nameTable": name,
            "timeArrive": time,
          }),
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tên: $name",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isMerge)
                  GestureDetector(
                    onTap: () =>
                        controller.showMergeModalWithTables(idTable),
                    child: Transform.rotate(
                      angle: 80 * 3.14159 / 180,
                      child: const Icon(
                        PhosphorIconsBold.link,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  )
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 20,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final textSpan = TextSpan(
                    text: "Trạng thái: ${controller.convertStatus(status)}",
                    style: const TextStyle(fontSize: 14),
                  );
                  final textPainter = TextPainter(
                    text: textSpan,
                    textDirection: TextDirection.ltr,
                    maxLines: 1,
                  )..layout(maxWidth: double.infinity);

                  if (textPainter.width > constraints.maxWidth) {
                    return Marquee(
                      text: "Trạng thái: ${controller.convertStatus(status)}",
                      style: const TextStyle(fontSize: 14),
                      scrollAxis: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      blankSpace: 20.0,
                      velocity: 30.0,
                      pauseAfterRound: const Duration(seconds: 1),
                      accelerationDuration: const Duration(seconds: 1),
                      accelerationCurve: Curves.linear,
                      decelerationDuration: const Duration(milliseconds: 500),
                      decelerationCurve: Curves.easeOut,
                    );
                  } else {
                    return Text(
                      "Trạng thái: ${controller.convertStatus(status)}",
                      style: const TextStyle(fontSize: 14),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Giờ vào: $time",
                  style: const TextStyle(fontSize: 14),
                ),
                if (status == 'Thanh toán')
                  const Icon(Icons.attach_money,
                      color: AppColors.primary, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0, right: 10),
        child: FloatingActionButton(
          onPressed: () => controller.showMergeModal(),
          backgroundColor: Colors.white,
          elevation: 0,
          shape: CircleBorder(
            side: BorderSide(color: Colors.grey[300]!, width: 1),
          ),
          child: Transform.rotate(
            angle: 80 * 3.14159 / 180, // Convert 200 degrees to radians
            child: const Icon(PhosphorIconsBold.link, color: Colors.black),
          ),
        ),
      ),
      body: Column(
        children: [
          Header(
            title: "Bàn",
            showBackButton: true,
            showActionButton: true,
            onActionPressed: () {
              Get.toNamed(RouteNames.addTable);
            },
            actionButtonText: "Thêm",
          ),
          Container(
            height: 50,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                controller.categories.length,
                (index) => Obx(() => GestureDetector(
                      onTap: () {
                        controller.changeFilter(controller.categories[index]);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() => Text(
                                controller.categories[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: controller.selectedFilter.value ==
                                          controller.categories[index]
                                      ? AppColors.primary
                                      : Colors.black87,
                                ),
                              )),
                          const SizedBox(height: 4),
                          Container(
                            height: 2,
                            width: 50,
                            color: controller.selectedFilter.value ==
                                    controller.categories[index]
                                ? AppColors.primary
                                : Colors.transparent,
                          ),
                        ],
                      ),
                    )),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.error.isNotEmpty) {
                return Center(child: Text(controller.error.value));
              }
              return RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchTables();
                },
                child: Container(
                  color: Colors.grey[100],
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.6,
                    ),
                    shrinkWrap: true, // Add this to constrain GridView height
                    physics:
                        const AlwaysScrollableScrollPhysics(), // Ensure compatibility with RefreshIndicator
                    itemCount: controller.filteredTables.length,
                    itemBuilder: (context, index) {
                      final table = controller.filteredTables[index];
                      return _buildTableItem(
                        idTable: table.idTable,
                        name: table.name,
                        status: table.status,
                        time: table.time,
                        isMerge: table.isMerge,
                        colorMerge: table.color,
                      );
                    },
                  ),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
