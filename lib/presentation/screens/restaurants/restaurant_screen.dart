import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
import 'package:restaurant_manager_mobile/data/models/restaurants/restaurant_modal.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/restaurants/restaurant_controller.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';
import 'package:restaurant_manager_mobile/presentation/screens/modals/edit_name_restaurant.dart';
import 'package:restaurant_manager_mobile/presentation/screens/modals/permission_denied_modal.dart';
import 'package:restaurant_manager_mobile/utils/permission_utils.dart';

class RestaurantScreen extends GetView<RestaurantController> {
  const RestaurantScreen({super.key});

  void _showEditNameRestaurantModal(RestaurantModel restaurant) {
    Get.dialog(EditNameRestaurantModal(idRestaurant: restaurant.id, nameRestaurant: restaurant.name, address: restaurant.address, status: restaurant.status, onUpdateNameRestaurant: (value) {
      controller.updateRestaurant(RestaurantModel(id: value.id, name: value.name, address: value.address, color: value.color, isSelected: value.isSelected, status: value.status));
    }));
  }

  Widget _buildRestaurantItem({
    required BuildContext context,
    required String title,
    required Color color,
    required String idRestaurant,
    required String address,
    required String status,
    required bool isSelected,
  }) {
    print('idRestaurant $idRestaurant');
    return InkWell(
          onTap: () {
            _showEditNameRestaurantModal(RestaurantModel(id: idRestaurant, name: title, address: address, color: color, isSelected: isSelected, status: status));
          },
          onDoubleTap: () => {
            controller.selectRestaurant(idRestaurant)
          },
          onLongPress: () async {
            if (await PermissionUtils.checkDeletePermissionWithModal()) {
              controller.deleteRestaurant(idRestaurant);
            }
          },
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
                        status == 'active' ? 'Hoạt động' : 'Không hoạt động',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Địa chỉ: $address',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                if (isSelected)
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
    return FutureBuilder<bool>(
      future: PermissionUtils.checkOwnerPermission(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data != true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.back();
            Get.dialog(const PermissionDeniedModal());
          });
          return const SizedBox.shrink();
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              Header(
                  title: "Nhà hàng",
                  showActionButton: true,
                  showBackButton: true,
                  onActionPressed: () {
                    Get.toNamed(RouteNames.addRestaurant);
                  }),
              const SizedBox(height: 12),
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
                      await controller.getRestaurant();
                    },
                    child: Obx(() => ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: controller.sortedRestaurantItems.length,
                      itemBuilder: (context, index) {
                        final item = controller.sortedRestaurantItems[index];
                        return _buildRestaurantItem(
                          context: context,
                          title: item.name,
                          color: item.color,
                          status: item.status,
                          isSelected: item.isSelected,
                          idRestaurant: item.id,
                          address: item.address,
                        );
                      },
                    )),
                  );
                }),
              ),
            ],
          ),
        );
      }
    );
  }
}
