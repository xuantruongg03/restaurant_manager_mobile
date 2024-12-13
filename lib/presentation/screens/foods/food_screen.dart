import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/filter.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/textfield_custom.dart';
import 'package:restaurant_manager_mobile/utils/formats.dart';
import '../../controllers/foods/food_controller.dart';

class FoodScreen extends GetView<FoodController> {
  const FoodScreen({super.key});

  Widget _buildFoodItem({
    required BuildContext context,
    required String title,
    required num price,
    required String image,
    required String id,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          //Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          //Title and Price
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatMoneyWithCurrency(price),
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.outline,
                  ),
                ),
              ],
            ),
          ),
          //Action
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 25,
                width: 25,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    PhosphorIconsBold.plus,
                    color: Colors.white,
                    size: 18,
                  ),
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Icon(
                    PhosphorIconsBold.pencilSimpleLine,
                    color: AppColors.outline,
                    size: 20,
                  ),
                  SizedBox(width: 4),
                  Icon(
                    PhosphorIconsBold.trash,
                    color: AppColors.outline,
                    size: 20,
                  ),
                ],
              )
            ],
          )
        ],
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
              title: 'Thực đơn',
              showActionButton: true,
              showBackButton: true,
              onActionPressed: () {
                Get.toNamed(RouteNames.addFood, arguments: {
                  'idMenu': controller.idMenu,
                });
              }),
          Container(
            height: 50,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                controller.categories.length,
                (index) => GestureDetector(
                  onTap: () {
                    controller.selectedIndex.value = index;
                    controller.selectedCategory.value =
                        controller.categories[index];
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(() => Text(
                            controller.categories[index],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: controller.selectedIndex == index
                                  ? AppColors.primary
                                  : Colors.black87,
                            ),
                          )),
                      const SizedBox(height: 4),
                      Obx(() => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            height: 2,
                            width: 50,
                            color: controller.selectedIndex == index
                                ? AppColors.primary
                                : Colors.transparent,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextFieldCustom(
              hintText: 'Tìm kiếm món ăn',
              prefixIcon: PhosphorIconsBold.magnifyingGlass,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${controller.sortedFoodItems.length} món',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
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

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.sortedFoodItems.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final food = controller.sortedFoodItems[index];
                  return _buildFoodItem(
                    context: context,
                    title: food['name'],
                    price: food['price'],
                    image: food['image'],
                    id: food['id'] ?? '',
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
