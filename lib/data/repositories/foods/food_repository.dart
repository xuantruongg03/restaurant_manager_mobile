import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/models/foods/food_modal.dart';
import 'package:restaurant_manager_mobile/data/models/foods/food_request.dart';
import 'package:restaurant_manager_mobile/data/services/auth_service.dart';

class FoodRepository {

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

  Future<Map<String, dynamic>?> deleteFood(String idFood) async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.toNamed(RouteNames.login);
        return null;
      }
      final response = await ApiClient.get('/food/delete', headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${auth['username']}:${auth['password']}'))}'
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
      final response = await ApiClient.get('/food/get-by-id', headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${auth['username']}:${auth['password']}'))}'
      }, queryParams: {
        'idFood': idFood,
      });
      print('response: $response');
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

  Future<Map<String, dynamic>?> editFood(String idFood, FoodRequest request) async {
    final auth = await AuthService().getAuth();
    if (auth == null) {
      Get.toNamed(RouteNames.login);
      return null;
    }
    final response = await ApiClient.post('/food/update', headers: {
      'Authorization': 'Basic ${base64Encode(utf8.encode('${auth['username']}:${auth['password']}'))}'
    }, body: {
      'idFood': idFood,
      'idMenu': request.idMenu,
      'name': request.name,
      'price': request.price,
      // 'category': request.category,
      'image': request.image,
    });
    print('response: $response');
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
}
