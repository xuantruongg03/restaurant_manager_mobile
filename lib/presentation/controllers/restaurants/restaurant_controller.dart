import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/models/restaurants/restaurant_modal.dart';
import 'package:restaurant_manager_mobile/data/repositories/restaurants/restaurant_repository.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/presentation/screens/modals/yn_modal.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class RestaurantController extends GetxController {
  final RestaurantRepository repository = RestaurantRepository();
  final filterOptions = ['Tất cả', 'Hoạt động', 'Không hoạt động'].obs;
  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;
  final RxString error = ''.obs;
  final RxString selectedFilter = 'Tất cả'.obs;
  final RxBool sorted = false.obs;
  final RxList<RestaurantModel> restaurantItems = <RestaurantModel>[].obs;

  Future<void> getRestaurant() async {
    final storageService = await StorageService.getInstance();
    final restaurants = storageService.getString(StorageKeys.restaurants);
    final res = await repository.getRestaurant();
    if (restaurants != null && restaurants.isNotEmpty && res != null) {
      final listRestaurants = jsonDecode(restaurants) as List;
      restaurantItems.clear();
      for (var restaurant in listRestaurants) {
        if (restaurant != null) {
          for (var item in res['data']['result'] as List) {
            if (item['name'] == restaurant['name']) {
              // Thay thế res trong storage bằng res mới và thêm isSelected vào res mới
              item['selected'] = restaurant['selected'];
              restaurantItems.add(RestaurantModel.fromJson(item));
            }
          }
        }
      }
    } else {}
  }

  Future<void> selectRestaurant(String idRestaurant) async {
    final storageService = await StorageService.getInstance();
    final restaurants = storageService.getString(StorageKeys.restaurants);
    final listRestaurants = jsonDecode(restaurants ?? '[]') as List;
    
    // Cập nhật selected trong storage
    for (var item in listRestaurants) {
      if (item['idRestaurant'] == idRestaurant) {
        item['selected'] = true;
        storageService.setString(StorageKeys.restaurantId, item['idRestaurant']);
      } else {
        item['selected'] = false;
      }
    }
    final updatedRestaurants = jsonEncode(listRestaurants);
    storageService.setString(StorageKeys.restaurants, updatedRestaurants);

    // Cập nhật UI
    restaurantItems.clear();
    for (var restaurant in listRestaurants) {
      if (restaurant != null) {
        restaurantItems.add(RestaurantModel.fromJson(restaurant));
      }
    }
    update();
  }

  Future<void> deleteRestaurant(String idRestaurant) async {
    Get.dialog(YNModal(
        title: "Xoá nhà hàng",
        content: "Bạn có chắc muốn xoá nhà hàng này",
        yesText: "Có",
        noText: "Không",
        onYes: (value) async {
          if (value) {
            final response = await repository.deleteRestaurant(idRestaurant);
            if (response != null) {
              //Remove restaurant from storage
              final storageService = await StorageService.getInstance();
              final restaurants =
                  storageService.getString(StorageKeys.restaurants);
              final listRestaurants = jsonDecode(restaurants ?? '[]') as List;
              listRestaurants
                  .removeWhere((element) => element['id'] == idRestaurant);
              final updatedRestaurants = jsonEncode(listRestaurants);
              storageService.setString(
                  StorageKeys.restaurants, updatedRestaurants);

              // Update UI
              await getRestaurant();
              ScaffoldMessenger.of(Get.context!).showSnackBar(
                const SnackBar(content: Text('Xóa nhà hàng thành công')),
              );
            } else {
              ScaffoldMessenger.of(Get.context!).showSnackBar(
                const SnackBar(content: Text('Xóa nhà hàng thất bại')),
              );
            }
          }
        }));
  }

  Future<void> updateRestaurantStorage(
      RestaurantModel updatedRestaurant) async {
    final storageService = await StorageService.getInstance();
    final restaurants = storageService.getString(StorageKeys.restaurants);

    if (restaurants != null && restaurants.isNotEmpty) {
      final listRestaurants = jsonDecode(restaurants) as List;

      for (int i = 0; i < listRestaurants.length; i++) {
        final restaurant = listRestaurants[i];
        final restaurantModel =
            RestaurantModel.fromJson(restaurant as Map<String, dynamic>);

        if (restaurantModel.id == updatedRestaurant.id) {
          listRestaurants[i] = updatedRestaurant.toJson();
          break;
        }
      }

      final updatedRestaurants = jsonEncode(listRestaurants);
      storageService.setString(StorageKeys.restaurants, updatedRestaurants);
    }
  }

  Future<void> updateRestaurant(RestaurantModel restaurant) async {
    isUpdating.value = true;
    final response = await repository.updateNameRestaurant(restaurant);
    if (response == null) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text('Cập nhật tên nhà hàng thất bại')),
      );
      return;
    }
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(content: Text('Cập nhật tên nhà hàng thành công')),
    );
    await updateRestaurantStorage(restaurant);
    await getRestaurant();
    Get.back();
    isUpdating.value = false;
  }

  List<RestaurantModel> get filteredRestaurantItems {
    if (selectedFilter.value == 'Tất cả') return restaurantItems;
    return restaurantItems
        .where((item) => selectedFilter.value == 'Hoạt động'
            ? item.isSelected == true
            : item.isSelected == false)
        .toList();
  }

  List<RestaurantModel> get sortedRestaurantItems {
    if (!sorted.value) return filteredRestaurantItems;
    final items = [...filteredRestaurantItems];
    items.sort((a, b) => a.name.compareTo(b.name));
    return items;
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }

  void toggleSort() {
    sorted.value = !sorted.value;
  }

  @override
  void onInit() {
    super.onInit();
    getRestaurant();
  }
}
