import 'package:restaurant_manager_mobile/config/api_client.dart';

class HomeRepository {
  Future<Map<String, dynamic>> createRestaurant(String name, String idAccount) async {
    final response = await ApiClient.post('/restaurant/create', body: {
      'name': name,
      'idAccount': idAccount,
    });
    return response;
  }
}
