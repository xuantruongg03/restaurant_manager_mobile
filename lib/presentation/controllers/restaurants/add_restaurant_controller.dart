import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/models/restaurants/create_res_request.dart';
import 'package:restaurant_manager_mobile/data/repositories/restaurants/restaurant_repository.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/restaurants/restaurant_controller.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class AddRestaurantController extends GetxController {
  final RestaurantRepository repository;

  AddRestaurantController({required this.repository});

  final key = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  void addRestaurant() async {
    if (key.currentState!.validate()) {
      final storageService = await StorageService.getInstance();
      final userId = storageService.getString(StorageKeys.userId);
      if (userId != null) {
        final res = CreateRestaurantRequest(name: nameController.text, idAccount: userId, status: 'active', isSelected: false, address: addressController.text);
        final response = await repository.createRestaurant(res);
        if (response != null) {
          // Add new restaurant to storage
          // final storageService = await StorageService.getInstance();
          // final restaurants = storageService.getString(StorageKeys.restaurants);
          // final listRestaurants = jsonDecode(restaurants ?? '[]') as List;
          // listRestaurants.add(res);
          // final updatedRestaurants = jsonEncode(listRestaurants);
          // storageService.setString(StorageKeys.restaurants, updatedRestaurants);
          Get.find<RestaurantController>().getRestaurant();
          Get.back();
        }
      }
    }
  }

  
}
