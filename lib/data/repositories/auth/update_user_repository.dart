
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/models/auth/userupdate_request.dart';
import 'package:restaurant_manager_mobile/data/services/auth_service.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';
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
            'Bearer ${storageService.getString(StorageKeys.token)}'
      }, body: request.toJson());

      if (response['success'] == true) {
        return response;
      } else {
        return null;
      }
    } catch (e) {
      // Lỗi kết nối hoặc xử lý yêu cầu
      Functions.showSnackbar("Đã xảy ra lỗi: $e");
      return {'success': false, 'message': e.toString()};
    }
  }
}
