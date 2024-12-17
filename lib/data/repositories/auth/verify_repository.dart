import 'package:restaurant_manager_mobile/config/api_client.dart';

class VerifyRepository {
  Future<Map?> verifyPhone(String phone, String code) async {
    try {
      final response = await ApiClient.post('/otp/activeOTP',
          body: {'phone': phone, 'code': code});
      if (response['success'] == true) {
        return response;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
