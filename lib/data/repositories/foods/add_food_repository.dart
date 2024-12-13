import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/data/models/foods/add_food_request.dart';

class AddFoodRepository {
  Future<Map<String, dynamic>?> addFood(AddFoodRequest request) async {
    try {
      final response =
          await ApiClient.post('/food/create', body: request.toJson());
      if (response["success"] == true) {
        return response;
      }
      return null;
    } catch (e) {
      print("error when add food: $e");
      return null;
    }
  }
}
