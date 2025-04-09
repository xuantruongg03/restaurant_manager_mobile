import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/models/staff/staff_modal.dart';
import 'package:restaurant_manager_mobile/data/services/auth_service.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class StaffRepository extends GetConnect {
  final ApiClient apiClient;

  StaffRepository({required this.apiClient});

  Future<List<StaffModel>?> getStaffList() async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.toNamed(RouteNames.login);
        return null;
      }
      final storageService = await StorageService.getInstance();

      String idRes = storageService.getString(StorageKeys.restaurantId) ??
          "917f554a-98f2-406f-8862-f07730a6b8f1";
      final now = DateTime.now();
      final currentMonth = now.month;
      final currentYear = now.year;

      final response = await ApiClient.get(
        '/staff-payment/get-all-salary/$idRes/$currentMonth/$currentYear',
        headers: {
          'Authorization':
              'Bearer ${storageService.getString(StorageKeys.token)}'
        },
      );

      if (response['success'] == true) {
        final data = response['data']['result'];
        if (data is List) {
          return data.map((json) => StaffModel.fromJson(json)).toList();
        } else {
          throw Exception(
              'Invalid data format: Expected List but got ${data.runtimeType}');
        }
      }

      throw Exception(
          response['message'] ?? 'Failed to fetch staff salary list');
    } catch (e) {
      print('error: $e');
      throw Exception('Error fetching staff salary list: $e');
    }
  }

  Future<void> deleteStaff(String userId) async {
    try {
      final storageService = await StorageService.getInstance();

      final response = await ApiClient.delete(
        '/account/$userId',
        headers: {
          'Authorization':
              'Bearer ${storageService.getString(StorageKeys.token)}'
        },
      );

      if (response['success'] == true) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Xóa nhân viên thành công')),
        );
      }

      throw Exception(response['message'] ?? 'Failed to delete salary');
    } catch (e) {
      print('error: $e');
      throw Exception('Error deleting staff: $e');
    }
  }

  Future<void> deleteMultiStaff(List<String> userIds) async {
    try {
      final storageService = await StorageService.getInstance();

      final response = await ApiClient.delete('/account/delete-many', headers: {
        'Authorization': 'Bearer ${storageService.getString(StorageKeys.token)}'
      }, body: {
        'accountIds': userIds
      });

      if (response['success'] == true) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Xóa các nhân viên thành công')),
        );
      }

      throw Exception(response['message'] ?? 'Failed to delete salary');
    } catch (e) {
      print('error: $e');
      throw Exception('Error deleting staff: $e');
    }
  }
}
