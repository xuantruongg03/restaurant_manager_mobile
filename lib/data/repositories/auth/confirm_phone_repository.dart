import 'package:restaurant_manager_mobile/config/api_client.dart';

class ConfirmPhoneRepository {
  Future<Map?> sendOTP(String phone) async {
    try {
      final response =
          await ApiClient.post('/otp/sendOTP', body: {'phone': phone});
      if (response['success'] == true) {
        return response;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
