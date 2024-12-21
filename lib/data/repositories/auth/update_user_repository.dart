import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/models/auth/userupdate_request.dart';
import 'package:restaurant_manager_mobile/data/services/auth_service.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/functions.dart';

class UpdateUserRepository {
  Future<Map?> UpdateUser(UserupdateRequest request) async {
    try {
      final auth = await AuthService().getAuth();
      if (auth == null) {
        Get.toNamed(RouteNames.login);
        return null;
      }
      final storageService = await StorageService.getInstance();
      final response = await ApiClient.post('/account/update', headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${auth['username']}:${auth['password']}'))}'
      }, body: request.toJson());

      // Kiểm tra phản hồi
      if (response['statusCode'] == 200) {
        // Thành công
        return {'success': true, 'message': 'OK'};
      } else if (response['statusCode'] == 417) {
        // EXPECTATION_FAILED
        Functions.showSnackbar(
            "Cập nhật thất bại: Không thể cập nhật thông tin.");
        return {'success': false, 'message': 'EXPECTATION_FAILED'};
      } else if (response['statusCode'] == 401) {
        // UNAUTHORIZED
        Functions.showSnackbar(
            "Cập nhật thất bại: Người dùng không được phép.");
        return {'success': false, 'message': 'UNAUTHORIZED'};
      } else {
        // Lỗi không xác định
        Functions.showSnackbar(
            "Đã xảy ra lỗi: ${response['message'] ?? 'Unknown error'}");
        return {
          'success': false,
          'message': response['message'] ?? 'Unknown error'
        };
      }
    } catch (e) {
      // Lỗi kết nối hoặc xử lý yêu cầu
      Functions.showSnackbar("Đã xảy ra lỗi: $e");
      return {'success': false, 'message': e.toString()};
    }
  }
}
