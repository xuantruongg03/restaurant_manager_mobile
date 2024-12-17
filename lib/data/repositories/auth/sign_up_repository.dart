import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/data/models/auth/user_modal.dart';
import 'package:restaurant_manager_mobile/utils/functions.dart';

class SignUpRepository {
  Future<Map?> signUp(UserModel user) async {
    try {
      final response = await ApiClient.post('/account/register', body: user.toJson());
      if (response['success'] == true) {
        return response;
      } else if (response['error'] == "Username already exists") {
        Functions.showSnackbar("Tài khoản đã tồn tại");
      } else if (response['error'] == "Phone number exists") {
        Functions.showSnackbar("Số điện thoại đã tồn tại");
      } else {
        Functions.showSnackbar("Lỗi đăng ký");
      }
      return null;

    } catch (e) {
      Functions.showSnackbar("Lỗi đăng ký");
      return null;
    }
  }
}