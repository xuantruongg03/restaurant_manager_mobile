import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/models/staff/create_work_day_staff_model.dart';
import 'package:restaurant_manager_mobile/data/models/staff/work_day_staff_modal.dart';
import 'package:restaurant_manager_mobile/data/services/auth_service.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class WorkScheduleRepository {
  Future<List<WorkDayStaffModal>> getWorkDayByUsernameAndDay(
      String date, String userId) async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.toNamed(RouteNames.login);
      }

      final storageService = await StorageService.getInstance();
      final response = await ApiClient.get(
        "/work-day/get-by-date/$date/$userId",
        headers: {
          'Authorization':
              'Bearer ${storageService.getString(StorageKeys.token)}'
        },
      );

      if (response['success'] == true) {
        final data = response['data']['result'];
        if (data is List) {
          return data.map((json) => WorkDayStaffModal.fromJson(json)).toList();
        } else {
          throw Exception(
              'Invalid data format: Expected List but got ${data.runtimeType}');
        }
      }

      throw Exception(
          response['message'] ?? 'Failed to fetch work dat staff list');
    } catch (e) {
      print('Error add work day: $e');
      throw Exception('Failed to fetch work day staff list');
    }
  }

  Future<List<WorkDayStaffModal>> getWorkDayByUserIdAndMonth(
      String userId, int month, int year) async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.toNamed(RouteNames.login);
      }

      final storageService = await StorageService.getInstance();
      final response = await ApiClient.get(
        "/work-day/get-by-month/$month/$year/$userId",
        headers: {
          'Authorization':
              'Bearer ${storageService.getString(StorageKeys.token)}'
        },
      );

      if (response['success'] == true) {
        final data = response['data']['result'];
        if (data is List) {
          return data.map((json) => WorkDayStaffModal.fromJson(json)).toList();
        } else {
          throw Exception(
              'Invalid data format: Expected List but got ${data.runtimeType}');
        }
      }

      throw Exception(
          response['message'] ?? 'Failed to fetch work dat staff list');
    } catch (e) {
      print('Error add work day: $e');
      throw Exception('Failed to fetch work day staff list');
    }
  }

  Future<bool> createWorkDay(CreateWorkDayStaffModel request) async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.toNamed(RouteNames.login);
        return false;
      }

      final storageService = await StorageService.getInstance();
      final response = await ApiClient.post("/work-day/create",
          headers: {
            'Authorization':
                'Bearer ${storageService.getString(StorageKeys.token)}'
          },
          body: request.toJson());

      print(request.toJson());
      print(response);

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
      print('Error add work day: $e');
      throw Exception('Failed to add work day');
    }
  }

  Future<bool> deleteWorkDay(String workDayId) async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.toNamed(RouteNames.login);
        return false;
      }

      final storageService = await StorageService.getInstance();
      final response = await ApiClient.get(
        "/work-day/delete/$workDayId",
        headers: {
          'Authorization':
              'Bearer ${storageService.getString(StorageKeys.token)}'
        },
      );

      if (response['success']) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Xóa lịch làm việc thành công')),
        );
        return true;
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Xóa lịch làm việc thất bại')),
        );
        return false;
      }
    } catch (e) {
      print('Error delete work day: $e');
      throw Exception('Failed to delete work day');
    }
  }

  Future<bool> updateWorkDay(WorkDayStaffModal request) async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.toNamed(RouteNames.login);
        return false;
      }

      final storageService = await StorageService.getInstance();
      final response = await ApiClient.post("/work-day/update",
          headers: {
            'Authorization':
                'Bearer ${storageService.getString(StorageKeys.token)}'
          },
          body: request.toJson());

      if (response['success']) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Cập nhật lịch làm việc thành công')),
        );
        return true;
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Cập nhật lịch làm việc thất bại')),
        );
        return false;
      }
    } catch (e) {
      print('Error update work day: $e');
      throw Exception('Failed to update work day');
    }
  }
}
