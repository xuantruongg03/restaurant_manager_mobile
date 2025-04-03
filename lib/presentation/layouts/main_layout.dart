import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/main_layout_controller.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/bottom_bar.dart';

class MainLayout extends GetView<MainLayoutController> {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MainLayoutController());
    return Scaffold(
      body: SafeArea(
        child: Obx(() => Container(
              color: const Color(0xFFF2F4F7),
              child: controller.screens[controller.selectedIndex.value],
            )),
      ),
      extendBody: true,
      bottomNavigationBar: Obx(() => CustomBottomBar(
            selectedIndex: controller.selectedIndex.value,
            onItemTapped: (index) {
              controller.changeScreen(index);
              if (index == 1) {
                controller.orderController.fetchOrders();
              } else if (index == 4) {
                controller.profileController.getProfile();
              }
            },
          )),
    );
  }
}
