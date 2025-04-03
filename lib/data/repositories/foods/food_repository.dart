
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/models/foods/food_modal.dart';
import 'package:restaurant_manager_mobile/data/models/foods/food_request.dart';
import 'package:restaurant_manager_mobile/data/services/auth_service.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class FoodRepository {
  Future<List<FoodModel>?> getFoods(String idMenu) async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.toNamed(RouteNames.login);
        return null;
      }

      final response = await ApiClient.get('/food/get/$idMenu', headers: {
        'Authorization': 'Bearer ${auth['token']}'
      });
      if (response['success'] == true) {
        final result = response['data']['result'];
        if (result is List) {
          return result.map((json) => FoodModel.fromJson(json)).toList();
        } else {
          throw Exception(
              'Invalid data format: Expected List but got ${result.runtimeType}');
        }
      }
      return null;
    } catch (e) {
      print('error: $e');
      throw Exception('Error fetching foods: $e');
    }
  }

  Future<Map<String, dynamic>?> deleteFood(String idFood) async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.toNamed(RouteNames.login);
        return null;
      }

      final response = await ApiClient.get('/food/delete/$idFood', headers: {
        'Authorization': 'Bearer ${auth['token']}'
      });
      print("deleteFood: $response");
      if (response['success'] == true) {
        return response;
      }
      return null;
    } catch (e) {
      throw Exception('Error deleting food: $e');
    }
  }

  Future<FoodModel?> getFoodById(String idFood) async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.toNamed(RouteNames.login);
        return null;
      }

      final response = await ApiClient.get('/food/get-by-id/$idFood', headers: {
        'Authorization': 'Bearer ${auth['token']}'
      });
      if (response['success'] == true) {
        final data = response['data']['result'];
        if (data is Map) {
          return FoodModel.fromJson(data as Map<String, dynamic>);
        } else {
          throw Exception(
              'Invalid data format: Expected Map but got ${data.runtimeType}');
        }
      }
      return null;
    } catch (e) {
      print('error: $e');
      throw Exception('Error fetching food: $e');
    }
  }

  Future<Map<String, dynamic>?> editFood(
      String idFood, FoodRequest request) async {
    final auth = await AuthService().getAuth();
    if (auth == null) {
      Get.toNamed(RouteNames.login);
      return null;
    }

    final response = await ApiClient.post('/food/update', headers: {
      'Authorization': 'Bearer ${auth['token']}'
    }, body: {
      'idFood': idFood,
      'idMenu': request.idMenu,
      'name': request.name,
      'price': request.price,
      'type': request.type,
      'image': request.image,
    });
    if (response['success'] == true) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text('Chỉnh sửa món ăn thành công!')),
      );
      return response;
    }
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(content: Text('Chỉnh sửa món ăn thất bại!')),
    );
    return null;
  }

  Future<Map<String, dynamic>?> orderFood(
      String idFood, String idTable, num quantity) async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.toNamed(RouteNames.login);
        return null;
      }
      final response = await ApiClient.post('/bills/order', headers: {
        'Authorization': 'Bearer ${auth['token']}'
      }, body: {
        'idFood': idFood,
        'idTable': idTable,
        'quantity': quantity,
      });
      if (response['success'] == true) {
        return response;
      }
      return null;
    } catch (e) {
      print('error: $e');
      throw Exception('Error ordering food: $e');
    }
  }
}
