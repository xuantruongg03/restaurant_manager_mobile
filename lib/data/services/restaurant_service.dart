import 'package:restaurant_manager_mobile/config/api_client.dart';

class RestaurantService {
  static Future<Map<String, dynamic>> createRestaurant(
      String name, String id) async {
    try {
      final response = await ApiClient.post('/restaurant/create',
          body: {'name': name, 'id': id});
      if (response['success'] == true) {
        return response['data'];
      }
      return {
        'success': false,
        'message': response['message'],
        'error': 'Lỗi hệ thống!'
      };
    } catch (e) {
      return {'success': false, 'message': '$e', 'error': 'Lỗi hệ thống!'};
    }
  }
}
