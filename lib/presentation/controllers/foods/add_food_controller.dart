import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/repositories/foods/add_food_repository.dart';
import 'package:restaurant_manager_mobile/data/models/foods/add_food_request.dart';

class AddFoodController extends GetxController {
  final AddFoodRepository addFoodRepository;

  AddFoodController({required this.addFoodRepository});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final selectedCategory = "".obs;
  final RxList<File> images = RxList.empty();
  final ImagePicker _picker = ImagePicker();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final idMenu = Get.arguments['idMenu'];

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        images.add(File(image.path));
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text('Lỗi chọn ảnh!')),
      );
    }
  }

  void removeImage(int index) {
    images.removeAt(index);
  }

  Future<void> showCategoryDialog() async {
    final List<String> categories = ['Đồ ăn', 'Đồ uống', 'Tráng miệng', 'Khác'];

    final String? result = await showDialog<String>(
      context: Get.context!,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Chọn loại món ăn'),
          children: categories.map((String category) {
            return SimpleDialogOption(
              onPressed: () => Navigator.pop(context, category),
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: selectedCategory.value == category
                      ? FontWeight.w500
                      : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        );
      },
    );

    if (result != null) {
      selectedCategory.value = result;
    }
  }

  Future<void> addFood() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      final request = AddFoodRequest(
        name: nameController.text,
        price: double.parse(priceController.text),
        category: selectedCategory.value,
        images: images.map((image) => image.path).toList(),
        idMenu: idMenu,
      );
      final response = await addFoodRepository.addFood(request);
      if (response != null) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Thêm món ăn thành công!')),
        );
        Get.back();
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Thêm món ăn thất bại!')),
        );
      }
    }
  }
}
