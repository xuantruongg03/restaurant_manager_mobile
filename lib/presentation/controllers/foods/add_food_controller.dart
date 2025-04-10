import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
import 'package:restaurant_manager_mobile/data/models/foods/food_request.dart';
import 'package:restaurant_manager_mobile/data/repositories/foods/add_food_repository.dart';
import 'package:restaurant_manager_mobile/data/repositories/foods/food_repository.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/foods/food_controller.dart';
import 'package:restaurant_manager_mobile/utils/functions.dart';


class AddFoodController extends GetxController {
  final addFoodRepository = AddFoodRepository();
  final foodRepository = FoodRepository();

  final title = "Thêm món ăn".obs;
  final actionButtonText = "Thêm".obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final isUploading = false.obs;
  final selectedCategory = "Đồ ăn".obs;
  final RxList<String> uploadedImageUrls = RxList.empty();
  final ImagePicker _picker = ImagePicker();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final idMenu = Get.arguments['idMenu'];
  final idFood = Get.arguments['idFood'];

  @override
  void onInit() {
    super.onInit();
    if (idFood != null) {
      fetchFood(idFood);
      title.value = "Chỉnh sửa món ăn";
      actionButtonText.value = "Sửa";
    }
  }

  void fetchFood(String idFood) async {
    final food = await foodRepository.getFoodById(idFood);
    if (food != null) {
      nameController.text = food.name;
      priceController.text = food.price.toString();
      selectedCategory.value = food.type;
      uploadedImageUrls.value = [food.image];
    }
  }

  Future<void> pickMultipleImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        isUploading.value = true;
        for (XFile image in images) {
          String? imageUrl = await Functions.uploadImageToCloudinary(File(image.path));
          if (imageUrl == null) {
            ScaffoldMessenger.of(Get.context!).showSnackBar(
              const SnackBar(
                content: Text('Tải lên thất bại!'),
              ),
            );
            return;
          } else {
            uploadedImageUrls.add(imageUrl);
          }
        }
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text('Tải lên thành công ${images.length} ảnh!'),
          ),
        );
      }
    } catch (e) {
      print('Error picking images: $e');
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text('Lỗi chọn ảnh!')),
      );
    } finally {
      isUploading.value = false;
    }
  }

  void removeImage(int index) {
    uploadedImageUrls.removeAt(index);
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
              onPressed: () => {
                selectedCategory.value = category,
                Get.back(result: category),
              },
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 14,
                  color: selectedCategory.value == category
                      ? AppColors.primary
                      : Colors.black,
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
      if (uploadedImageUrls.isEmpty) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn ít nhất 1 ảnh!')),
        );
        return;
      }
      isLoading.value = true;
      final request = FoodRequest(
        image: uploadedImageUrls[0],
        name: nameController.text,
        price: double.parse(priceController.text),
        type: selectedCategory.value,
        idFood: '',
        idMenu: idMenu,
      );
      final response = await addFoodRepository.addFood(request);
      if (response != null) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Thêm món ăn thành công!')),
        );
        Get.find<FoodController>().fetchFoods(idMenu);
        Get.back();
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Thêm món ăn thất bại!')),
        );
      }
    }
  }

  Future<void> editFood() async {
    if (formKey.currentState!.validate()) {
      if (uploadedImageUrls.isEmpty) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn ít nhất 1 ảnh!')),
        );
        return;
      }
      final request = FoodRequest(
        image: uploadedImageUrls[0],
        name: nameController.text,
        price: double.parse(priceController.text),
        type: selectedCategory.value,
        idFood: idFood,
        idMenu: idMenu,
      );
      final response = await foodRepository.editFood(idFood, request);
      if (response != null) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Chỉnh sửa món ăn thành công!')),
        );
        Get.find<FoodController>().fetchFoods(idMenu);
        Get.back();
      }
    }
  }

  // Future<String?> uploadImageToCloudinary(File imageFile) async {
  //   try {
  //     final String cloudName = dotenv.env['CLOUD_NAME'] ?? '';
  //     final String apiKey = dotenv.env['API_KEY'] ?? '';
  //     final String apiSecret = dotenv.env['API_SECRET'] ?? '';

  //     final uri =
  //         Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
  //     final request = http.MultipartRequest('POST', uri);

  //     request.fields['upload_preset'] = dotenv.env['UPLOAD_PRESET'] ?? '';
  //     request.fields['api_key'] = apiKey;
  //     request.fields['api_secret'] = apiSecret;
  //     request.files
  //         .add(await http.MultipartFile.fromPath('file', imageFile.path));

  //     final response = await request.send();
  //     if (response.statusCode == 200) {
  //       final responseData = await http.Response.fromStream(response);
  //       final data = jsonDecode(responseData.body);
  //       return data['secure_url'];
  //     } else {
  //       print('Failed to upload image: ${response.reasonPhrase}');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error uploading image: $e');
  //     return null;
  //   }
  // }
}
