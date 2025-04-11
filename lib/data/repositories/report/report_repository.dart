import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/models/report/report_model.dart';
import 'package:restaurant_manager_mobile/data/models/staff/create_report_request.dart';
import 'package:restaurant_manager_mobile/data/models/staff/report_detail_resonse.dart';
import 'package:restaurant_manager_mobile/data/services/auth_service.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class ReportRepository {
  Future<bool> createReport(CreateReportRequest request) async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.toNamed(RouteNames.login);
        return false;
      }

      final storageService = await StorageService.getInstance();
      final response = await ApiClient.post("/report/create",
          headers: {
            'Authorization':
                'Bearer ${storageService.getString(StorageKeys.token)}'
          },
          body: request.toJson());

      if (response['success']) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Tạo báo cáo thành công')),
        );
        return true;
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Tạo báo cáo thất bại')),
        );
        return false;
      }
    } catch (e) {
      print('Error create report: $e');
      throw Exception('Failed to create report');
    }
  }

  Future<ReportDetailResponse?> getReportByWorkDayId(String workDayId) async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.toNamed(RouteNames.login);
        return null; // <- trả null nếu chưa login
      }

      final storageService = await StorageService.getInstance();
      final response = await ApiClient.get(
        "/report/get-by-work-day/$workDayId",
        headers: {
          'Authorization':
              'Bearer ${storageService.getString(StorageKeys.token)}'
        },
      );

      print(response['data']['result']);

      if (response['success'] == true) {
        return ReportDetailResponse.fromJson(response['data']['result']);
      } else {
        return null;
      }
    } catch (e) {
      print('Error when get report: $e');
      return null;
    }
  }

  Future<List<ReportModel>?> getReportList() async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.toNamed(RouteNames.login);
        return null;
      }
      final storageService = await StorageService.getInstance();

      String idRes = storageService.getString(StorageKeys.restaurantId) ??
          "917f554a-98f2-406f-8862-f07730a6b8f1";

      final response = await ApiClient.get(
        '/report/get-by-restaurant-id/$idRes',
        headers: {
          'Authorization':
              'Bearer ${storageService.getString(StorageKeys.token)}'
        },
      );

      if (response['success'] == true) {
        final data = response['data']['result'];
        if (data is List) {
          return data.map((json) => ReportModel.fromJson(json)).toList();
        } else {
          throw Exception(
              'Invalid data format: Expected List but got ${data.runtimeType}');
        }
      }

      throw Exception(
          response['message'] ?? 'Failed to fetch report list');
    } catch (e) {
      print('error: $e');
      throw Exception('Error fetching report list: $e');
    }
  }
}
