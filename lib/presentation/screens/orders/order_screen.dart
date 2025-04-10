import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
import 'package:restaurant_manager_mobile/data/models/orders/order_modal.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/orders/order_controller.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/filter.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/textfield_custom.dart';

class OrderScreen extends GetView<OrderController> {
  const OrderScreen({super.key});

  Widget _buildOrderItem(OrderModal order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Food image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(order.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Order details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.nameFood,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Số lượng: ${order.quantity}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Bàn: ${order.nameTable}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Positioned icons at the bottom-right corner
          Positioned(
            bottom: 8,
            right: 0,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (order.status == 'Processing') {
                      controller.showAcceptOrderModal(order.idOrder,
                          order.nameFood, order.quantity, order.nameTable);
                    } else if (order.status == 'Received') {
                      controller.showSuccessOrderModal(order.idOrder,
                          order.nameFood, order.quantity, order.nameTable);
                    }
                  },
                  child: Icon(Icons.edit_outlined,
                      size: 26, color: Colors.grey[600]),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    if (order.status == 'Processing') {
                      controller.showCancelOrderModal(order.idOrder,
                          order.nameFood, order.quantity, order.nameTable);
                    }
                  },
                  child: Icon(
                      order.status == 'Processing'
                          ? Icons.delete_outline
                          : PhosphorIconsBold.bowlSteam,
                      size: 26,
                      color: order.status == 'Processing'
                          ? Colors.grey[600]
                          : AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(OrderController());
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const Header(title: "Đơn hàng"),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFieldCustom(
              hintText: 'Tìm kiếm đơn hàng',
              prefixIcon: PhosphorIconsBold.magnifyingGlass,
              onChanged: (value) {
                controller.searchText.value = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(
                      '${controller.sortedOrders.length} đơn hàng',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    )),
                Obx(() => Filter(
                      selectedValue: controller.selectedFilter.value,
                      options: controller.filterOptions,
                      sorted: controller.sorted.value,
                      onChanged: (value) {
                        controller.selectedFilter.value = value!;
                      },
                      onSorted: (value) {
                        controller.sorted.value = value;
                      },
                    )),
              ],
            ),
          ),
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
                  await controller.fetchOrders();
                },
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.sortedOrders.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final order = controller.sortedOrders[index];
                    return _buildOrderItem(order);
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
