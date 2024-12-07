import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/config/env.dart';
import 'package:restaurant_manager_mobile/data/models/user_modal.dart';

class AuthService {
  static const String baseUrl = Env.apiUrl;

  Future<Map<String, dynamic>> signUp(UserModel user) async {
    try {
        final response = await ApiClient.post('/account/register', body: user.toJson());
        print(response);
        if(response['success'] == false) {
          return {
            'success': false,
            'message': response['message']
          };
        }
        if (response['status'] == 200 || response['status'] == 201) {
          return response;
        }
        return response;
    } catch (e) {
      print('Error during sign up: $e');
      return {
        'success': false,
        'message': '$e',
      };
    }
  }
}
