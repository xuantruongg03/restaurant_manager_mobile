import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/models/staff/add_staff_request.dart';
import 'package:restaurant_manager_mobile/data/models/staff/update_staff_request.dart';
import 'package:restaurant_manager_mobile/data/services/auth_service.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class AddStaffRepository {
  Future<bool> createStaff(AddStaffRequest request) async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.toNamed(RouteNames.login);
        return false;
      }

      final storageService = await StorageService.getInstance();
      final response = await ApiClient.post("/account/create-employee",
          headers: {
            'Authorization':
                'Bearer ${storageService.getString(StorageKeys.token)}'
          },
          body: request.toJson());

      if (response['success']) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Thêm mới thành công')),
        );
        return true;
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Thêm mới thất bại')),
        );
        return false;
      }
    } catch (e) {
      print('error add staff: $e');
      throw Exception('Failed to add staff');
    }
  }

  Future<bool> updateStaff(
      String userId, UpdateStaffRequest request) async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.toNamed(RouteNames.login);
        return false;
      }

      final storageService = await StorageService.getInstance();
      final response = await ApiClient.put("/account/update-employee/$userId",
          headers: {
            'Authorization':
                'Bearer ${storageService.getString(StorageKeys.token)}'
          },
          body: request.toJson());

      if (response['success']) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Cập nhật thành công')),
        );
        return true;
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Cậpp nhật thất bại')),
        );
        return false;
      }
    } catch (e) {
      print('error add staff: $e');
      throw Exception('Failed to add staff');
    }
  }
}
