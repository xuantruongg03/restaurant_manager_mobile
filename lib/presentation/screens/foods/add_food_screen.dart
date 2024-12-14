import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/foods/add_food_controller.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';

class AddFoodScreen extends GetView<AddFoodController> {
  const AddFoodScreen({super.key});

  Widget _buildImageGrid() {
    return Obx(() {
      List<Widget> items =
          controller.uploadedImageUrls.asMap().entries.map((entry) {
        int idx = entry.key;
        String imageUrl = entry.value;
        return Stack(
          children: [
            SizedBox(
              width: 100.0,
              height: 100.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
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
      }).toList();

      // If there are less than 5 images, add the "add image" button
      if (controller.uploadedImageUrls.length < 5 ||
          controller.uploadedImageUrls.isEmpty) {
        items.add(
          controller.isUploading.value
              ? Stack(
                  children: [
                    Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.grey[200],
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 32.0, // Adjust the size as needed
                          height: 32.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 3, // Adjust the stroke width as needed
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    GestureDetector(
                      onTap: controller.pickMultipleImages,
                      child: Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.add, size: 24),
                      ),
                    ),
                  ],
                ),
        );
      }

      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.0, // Adjust for larger boxes
        children: items,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Obx(() => Header(
                title: controller.title.value,
                showBackButton: true,
                showActionButton: true,
                actionButtonText: controller.actionButtonText.value,
                onActionPressed: () {
                  if (controller.idFood != null) {
                    controller.editFood();
                  } else {
                    controller.addFood();
                  }
                },
              )),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 16,
              ),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tên món:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: controller.nameController,
                      decoration: InputDecoration(
                        hintText: 'Nhập tên món...',
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên món';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Giá món:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: controller.priceController,
                      decoration: InputDecoration(
                        hintText: 'Nhập giá món...',
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập giá món';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Loại:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: controller.showCategoryDialog,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() => Text(
                                  controller.selectedCategory.value.isEmpty
                                      ? 'Chọn loại món ăn'
                                      : controller.selectedCategory.value,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: controller
                                            .selectedCategory.value.isEmpty
                                        ? Colors.grey
                                        : Colors.black,
                                  ),
                                )),
                            const Icon(Icons.arrow_drop_down, size: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Hình ảnh:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildImageGrid(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
