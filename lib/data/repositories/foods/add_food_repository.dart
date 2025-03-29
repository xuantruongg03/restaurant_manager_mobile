import 'dart:convert';

import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/models/foods/food_request.dart';
import 'package:restaurant_manager_mobile/data/services/auth_service.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class AddFoodRepository {
  Future<Map<String, dynamic>?> addFood(FoodRequest request) async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.offAllNamed(RouteNames.login);
        return null;
      }

      final storageService = await StorageService.getInstance();
      final response = await ApiClient.post(
        '/food/create',
        headers: {
          'Authorization':
              'Bearer ${storageService.getString(StorageKeys.token)}'
        },
        body: request.toJson(),
      );
      if (response["success"] == true) {
        return response;
      }
      return null;
    } catch (e) {
      print("error when add food: $e");
      return null;
    }
  }
}
