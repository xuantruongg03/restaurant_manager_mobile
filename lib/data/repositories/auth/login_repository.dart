import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/models/auth/login_request.dart';
import 'package:restaurant_manager_mobile/utils/functions.dart';

class LoginRepository {

  Future<Map?> login(LoginRequest request) async {
    final response = await ApiClient.post('/account/login', body: request.toJson());
    if (response['success'] == true) {
      return response;
    } else {
      if (response['error'] == "Invalid credentials") {
        Functions.showSnackbar("Tài khoản hoặc mật khẩu không đúng");
      } else if (response['error'] == "Account not activated") {
        Functions.showSnackbar("Tài khoản của bạn chưa được kích hoạt");
        Get.offNamed(RouteNames.confirmPhone);
      } else {
        Functions.showSnackbar("Lỗi đăng nhập");
      }
      return null;
    }
  }
}
