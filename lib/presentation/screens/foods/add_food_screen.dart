import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/foods/add_food_controller.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/textfield_custom.dart';

class AddFoodScreen extends GetView<AddFoodController> {
  const AddFoodScreen({super.key});

  Widget _buildImageGrid() {
    List<Widget> items = [
      ...controller.images.asMap().entries.map((entry) {
        int idx = entry.key;
        File image = entry.value;
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                  image: FileImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              right: 4,
              top: 4,
              child: GestureDetector(
                onTap: () => controller.removeImage(idx),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
      if (controller.images.length < 5)
        GestureDetector(
          onTap: controller.pickImage,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.add, size: 24),
          ),
        ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1,
      children: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Header(
            title: 'Thêm món ăn',
            showBackButton: true,
            showActionButton: true,
            actionButtonText: 'Thêm',
            onActionPressed: () {
              controller.addFood();
            },
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tên món:',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      TextFieldCustom(
                        controller: controller.nameController,
                        hintText: 'Nhập tên món...',
                        // contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      const SizedBox(height: 12),
                      const Text('Giá món:',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      TextFieldCustom(
                        controller: controller.priceController,
                        hintText: 'Nhập giá món...',
                        // contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      const SizedBox(height: 12),
                      const Text('Loại:',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () => controller.showCategoryDialog(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                controller.selectedCategory.value == ''
                                    ? 'Chọn loại món ăn'
                                    : controller.selectedCategory.value,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: controller.selectedCategory.value == ''
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down, size: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('Hình ảnh:',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      _buildImageGrid(),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
