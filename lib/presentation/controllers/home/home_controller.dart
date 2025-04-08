import 'dart:convert';

import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/models/restaurants/create_res_request.dart';
import 'package:restaurant_manager_mobile/data/repositories/home/home_reponsitory.dart';
import 'package:restaurant_manager_mobile/data/repositories/restaurants/restaurant_repository.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class HomeController extends GetxController {
  final HomeRepository repository = HomeRepository();
  final RestaurantRepository restaurantRepository = RestaurantRepository();
  final List<Map<String, dynamic>> quickAccessItems = [
    {
      'title': 'Báo cáo',
      'icon': 'assets/icons/menu.png',
      'route': RouteNames.menu
    },
    {
      'title': 'Thống kê',
      'icon': 'assets/icons/menu.png',
      'route': RouteNames.menu
    },
    {
      'title': 'Thống kê',
      'icon': 'assets/icons/menu.png',
      'route': RouteNames.menu
    },
    {
      'title': 'Thống kê',
      'icon': 'assets/icons/menu.png',
      'route': RouteNames.menu
    },
    {
      'title': 'Thống kê',
      'icon': 'assets/icons/menu.png',
      'route': RouteNames.menu
    },
    {
      'title': 'Thống kê',
      'icon': 'assets/icons/menu.png',
      'route': RouteNames.menu
    },
    {
      'title': 'Thống kê',
      'icon': 'assets/icons/menu.png',
      'route': RouteNames.feature
    },
  ];

  Future<void> getRestaurant() async {
    final storageService = await StorageService.getInstance();
    String idAccount = storageService.getString(StorageKeys.userId) ?? '';
    final response = await restaurantRepository.getRestaurant();
    if (response != null && response['data']['result'].length > 0) {
      final List<dynamic> restaurants = response['data']['result'];
      List<Map<String, dynamic>> restaurantList = []; 
      for (var i = 0; i < restaurants.length; i++) {
        final restaurant = restaurants[i];
        final idRestaurant = restaurant['idRestaurant'];
        final nameRestaurant = restaurant['name'];
        final statusRestaurant = restaurant['status'];
        final addressRestaurant = restaurant['address'];
        // Create a restaurant object and set selected for the first restaurant
        restaurantList.add({
          'id': idRestaurant,
          'name': nameRestaurant,
          'status': statusRestaurant,
          'address': addressRestaurant,
          'selected': i == 0, // Set selected to true for the first restaurant
        });
        if (i == 0) {
          storageService.setString(StorageKeys.restaurantId, idRestaurant);
        }
      }
      // Save the list of restaurant objects to storage
      await storageService.setString(StorageKeys.restaurants, jsonEncode(restaurantList));
    } else {
      // Create restaurant
      final createRestaurantRequest =
          CreateRestaurantRequest(name: "Nhà hàng 1", idAccount: idAccount, status: 'active', isSelected: false, address: '');
      final responseCreateRestaurant =
          await restaurantRepository.createRestaurant(createRestaurantRequest);
      if (responseCreateRestaurant != null) {
        getRestaurant();
      }
    }
  }

  void registerDevicePushy() async {
    try {
      final storageService = await StorageService.getInstance();
      final deviceToken = storageService.getString(StorageKeys.deviceToken);

      if (deviceToken == null || deviceToken.isEmpty) {
        await repository.registerDevicePushy();
        storageService.getString(StorageKeys.deviceToken);
      }
    } catch (e) {
      print('Error in registerDevicePushy: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    getRestaurant();
    registerDevicePushy();
  }
}
