import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/filter.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/menus/menu_controller.dart';
import 'package:restaurant_manager_mobile/presentation/screens/modals/edit_name_menu_modal.dart';

class MenuScreen extends GetView<MenusController> {
  const MenuScreen({super.key});

  void _showEditNameMenuModal(String idMenu, String nameMenu) {
    Get.dialog(EditNameMenuModal(idMenu: idMenu, nameMenu: nameMenu, onUpdateNameMenu: (value) {
      controller.updateNameMenu(idMenu, value);
    }));
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String title,
    required String createdBy,
    required String createdAt,
    required Color color,
    required bool isActive,
    required String idMenu,
  }) {
    return InkWell(
      onTap: () {
        Get.toNamed(RouteNames.food, arguments: {
          'idMenu': idMenu,
        });
      },
      onLongPress: () => _showEditNameMenuModal(idMenu, title),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 90,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tạo bởi: $createdBy',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tạo lúc: $createdAt',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            if (isActive)
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/icons/icon-checked.png',
                  width: 24,
                  height: 24,
                ),
              ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Header(
              title: "Menu",
              showActionButton: true,
              showBackButton: true,
              onActionPressed: () {
                Get.toNamed(RouteNames.addMenu);
              }),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Obx(() => Text(
                        '${controller.sortedMenuItems.length} menu',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      )),
                ),
                Filter(
                  selectedValue: controller.selectedFilter.value,
                  options: controller.filterOptions,
                  sorted: controller.sorted.value,
                  onChanged: (value) => controller.changeFilter(value ?? ''),
                  onSorted: (value) => controller.toggleSort(),
                ),
              ],
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
                  await controller.fetchMenuItems();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.sortedMenuItems.length,
                  itemBuilder: (context, index) {
                    final item = controller.sortedMenuItems[index];
                    return _buildMenuItem(
                      context: context,
                      title: item.name,
                      createdBy: item.createdBy,
                      createdAt: item.createdAt,
                      color: item.color,
                      isActive: item.isActive,
                      idMenu: item.idMenu,
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
