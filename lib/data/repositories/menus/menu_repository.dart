import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/models/menus/menu_modal.dart';
import 'package:restaurant_manager_mobile/data/services/auth_service.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class MenuRepository {
  final ApiClient apiClient;

  MenuRepository({required this.apiClient});

  Future<Map<String, dynamic>?> createMenu(String name) async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.toNamed(RouteNames.login);
        return null;
      }
      final storageService = await StorageService.getInstance();
      final response = await ApiClient.post('/menu/create', headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${auth['username']}:${auth['password']}'))}'
      }, body: {
        'idRestaurant': storageService.getString(StorageKeys.restaurantId),
        'name': name
      });
      if (response['success'] == true) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Thêm mới thành công')),
        );
        return response;
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Thêm mới thất bại')),
        );
        return null;
      }
    } catch (e) {
      print('error: $e');
      throw Exception('Error fetching menu items: $e');
    }
  }

  Future<List<MenuModel>?> getMenuItems() async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.toNamed(RouteNames.login);
        return null;
      }
      final storageService = await StorageService.getInstance();

      final response = await ApiClient.get(
        '/menu/get',
        queryParams: {
          'idRestaurant': storageService.getString(StorageKeys.restaurantId)
        },
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('${auth['username']}:${auth['password']}'))}'
        },
      );

      if (response['success'] == true) {
        final data = response['data']['data']; 
        if (data is List) {
          return data.map((json) => MenuModel.fromJson(json)).toList();
        } else {
          throw Exception(
              'Invalid data format: Expected List but got ${data.runtimeType}');
        }
      }

      throw Exception(response['message'] ?? 'Failed to fetch menu items');
    } catch (e) {
      print('error: $e');
      throw Exception('Error fetching menu items: $e');
    }
  }

  Future<Map<String, dynamic>?> updateMenu(String idMenu, String nameMenu) async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.toNamed(RouteNames.login);
        return null;
      }
      final storageService = await StorageService.getInstance();
      final response = await ApiClient.post('/menu/update-name', headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${auth['username']}:${auth['password']}'))}'
      }, body: {
        'idMenu': idMenu,
        'name': nameMenu,
        'idRestaurant': storageService.getString(StorageKeys.restaurantId)
      });
      if (response["success"] == true) {
        return response;
      }
      return null;
    } catch (e) {
      print('error: $e');
      throw Exception('Error updating menu: $e');
    }
  }
}
