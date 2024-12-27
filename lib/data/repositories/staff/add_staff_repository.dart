import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/models/staff/add_staff_request.dart';
import 'package:restaurant_manager_mobile/data/services/auth_service.dart';

class AddStaffRepository {
  Future<Map<String, dynamic>?> createStaff(AddStaffRequest request) async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.toNamed(RouteNames.login);
        return null;
      }
      final response = await ApiClient.post("/account/create-employee",
          headers: {
            'Authorization':
                'Basic ${base64Encode(utf8.encode('${auth['username']}:${auth['password']}'))}'
          },
          body: {
            'idRestaurant': request.idRestaurant,
            'name': request.name,
            'phone': request.phone,
            'position': request.position,
            'salaryType': request.salaryType,
            'salary': request.salary,
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
      print('error add staff: $e');
      throw Exception('Failed to add staff');
    }
  }
}
