import 'dart:convert';

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

      final storageService = await StorageService.getInstance();
      final response = await ApiClient.get('/food/get', headers: {
        'Authorization': 'Bearer ${storageService.getString(StorageKeys.token)}'
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

  Future<Map<String, dynamic>?> deleteFood(String idFood) async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.toNamed(RouteNames.login);
        return null;
      }

      final storageService = await StorageService.getInstance();
      final response = await ApiClient.get('/food/delete', headers: {
        'Authorization': 'Bearer ${storageService.getString(StorageKeys.token)}'
      }, queryParams: {
        'idFood': idFood,
      });
      if (response['success'] == true) {
        return response;
      }
      return null;
    } catch (e) {
      print('error: $e');
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

      final storageService = await StorageService.getInstance();
      final response = await ApiClient.get('/food/get-by-id', headers: {
        'Authorization': 'Bearer ${storageService.getString(StorageKeys.token)}'
      }, queryParams: {
        'idFood': idFood,
      });
      if (response['success'] == true) {
        final data = response['data']['data'];
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

    final storageService = await StorageService.getInstance();
    final response = await ApiClient.post('/food/update', headers: {
      'Authorization': 'Bearer ${storageService.getString(StorageKeys.token)}'
    }, body: {
      'idFood': idFood,
      'idMenu': request.idMenu,
      'name': request.name,
      'price': request.price,
      // 'category': request.category,
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
      final storageService = await StorageService.getInstance();
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.toNamed(RouteNames.login);
        return null;
      }
      final response = await ApiClient.post('/bills/order', headers: {
        'Authorization': 'Bearer ${storageService.getString(StorageKeys.token)}'
      }, body: {
        'idFood': idFood,
        'idRestaurant': storageService.getString(StorageKeys.restaurantId),
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
