import 'dart:convert';

import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/models/foods/food_modal.dart';
import 'package:restaurant_manager_mobile/data/services/auth_service.dart';

class FoodRepository {
  Future<Map<String, dynamic>?> createFood(FoodModel food) async {
    return null;
  }

  Future<List<FoodModel>?> getFoods(String idMenu) async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.toNamed(RouteNames.login);
        return null;
      }
      final response = await ApiClient.get('/food/get', headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${auth['username']}:${auth['password']}'))}'
      }, queryParams: {
        'idMenu': idMenu,
      });
      if (response['success'] == true) {
        final data = response['data']['data'];
        if (data is List) {
          return data.map((json) => FoodModel.fromJson(json)).toList();
        } else {
          throw Exception(
              'Invalid data format: Expected List but got ${data.runtimeType}');
        }
      }
    } catch (e) {
      print('error: $e');
      throw Exception('Error fetching foods: $e');
    }
    return null;
  }
}
