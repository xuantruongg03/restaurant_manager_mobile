import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/models/foods/food_modal.dart';
import 'package:restaurant_manager_mobile/data/repositories/foods/food_repository.dart';
import 'package:restaurant_manager_mobile/presentation/screens/modals/order_staff_modal.dart';
import 'package:restaurant_manager_mobile/presentation/screens/modals/yn_modal.dart';
import 'package:restaurant_manager_mobile/utils/functions.dart';

class FoodController extends GetxController {
  final FoodRepository repository;

  FoodController({required this.repository});

  final RxList<FoodModel> foods = <FoodModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isDeleting = false.obs;
  final RxString error = ''.obs;
  final selectedFilter = 'Tất cả'.obs;
  final RxBool sorted = false.obs;
  final idMenu = Get.arguments['idMenu'];
  final search = ''.obs;

  final filterOptions = ['Tất cả', 'Chiên', 'Nướng', 'Xào', 'Hấp', 'Trộn'].obs;

  final categories = ['Tất cả', 'Đồ ăn', 'Đồ uống', 'Khác'].obs;

  final selectedIndex = 0.obs;
  final selectedCategory = 'Tất cả'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFoods(idMenu);
  }

  void fetchFoods(String idMenu) async {
    try {
      isLoading.value = true;
      error.value = '';
      final foods = await repository.getFoods(idMenu);
      if (foods == null) {
        return;
      }
      this.foods.value = foods;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void editFood(String idFood) async {
    Get.toNamed(RouteNames.addFood, arguments: {
      'idMenu': idMenu,
      'idFood': idFood,
    });
  }

  void deleteConfirm(String idFood) async {
    try {
      isDeleting.value = true;
      final delete = await repository.deleteFood(idFood);
      if (delete == null) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Xóa món ăn thất bại')),
        );
        return;
      }
      foods.removeWhere((food) => food.idFood == idFood);
    } catch (e) {
      print('error: $e');
      error.value = e.toString();
    } finally {
      isDeleting.value = false;
    }
  }

  void deleteFood(String idFood) {
    Get.dialog(YNModal(
      title: 'Xóa món ăn',
      content: 'Bạn có chắc chắn muốn xóa món ăn này không?',
      yesText: 'Xóa',
      noText: 'Huỷ',
      onYes: (value) {
        deleteConfirm(idFood);
      },
    ));
  }

  List<FoodModel> get filteredFoodItems {
    var items = List<FoodModel>.from(foods);

    if (selectedCategory.value != 'Tất cả') {
      items = items
          .where((item) => item.category == selectedCategory.value)
          .toList();
    }

    if (selectedFilter.value != 'Tất cả') {
      items = items.where((item) => item.type == selectedFilter.value).toList();
    }

    if (search.value.isNotEmpty) {
      items = items
          .where((item) =>
              item.name.toLowerCase().contains(search.value.toLowerCase()))
          .toList();
    }

    return items;
  }

  List<FoodModel> get sortedFoodItems {
    if (!sorted.value) return filteredFoodItems;
    final items = List<FoodModel>.from(filteredFoodItems);
    items.sort((a, b) => a.name.compareTo(b.name));
    return items;
  }

  void showOrderModal(String idFood, String nameFood) {
    Get.dialog(
      OrderStaffModal(idFood: idFood, nameFood: nameFood, onOrder: onOrder),
    );
  }

  Future<void> onOrder(String idFood, String nameFood, String idTable, num quantity) async {
    try {
      final rs = await repository.orderFood(idFood, idTable, quantity);
      if (rs == null) {
        Functions.showSnackbar('Đặt món thất bại');
        return;
      }
      Functions.showSnackbar('Đặt món thành công');
    } catch (e) {
      Functions.showSnackbar('Đặt món thất bại. ${e.toString()}');
    } finally {
      Get.back();
    }
  }
}
