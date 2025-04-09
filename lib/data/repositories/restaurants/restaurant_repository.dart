import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/data/models/restaurants/create_res_request.dart';
import 'package:restaurant_manager_mobile/data/models/restaurants/restaurant_modal.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class RestaurantRepository {
  Future<Map?> getRestaurant() async {
    final storageService = await StorageService.getInstance();
    final token = storageService.getString(StorageKeys.token);
    final response =
        await ApiClient.get('/restaurant/get-my-restaurant', headers: {
      'Authorization': 'Bearer $token',
    });
    if (response['success'] == true) {
      return response;
    } else {
      return null;
    }
  }

  Future<Map?> createRestaurant(CreateRestaurantRequest request) async {
    final storageService = await StorageService.getInstance();
    final token = storageService.getString(StorageKeys.token);
    final response = await ApiClient.post('/restaurant/create',
        body: request.toJson(),
        headers: {
          'Authorization': 'Bearer $token',
        });
    if (response['success'] == true) {
      return response['data'];
    } else {
      return null;
    }
  }

  Future<Map?> updateNameRestaurant(RestaurantModel restaurant) async {
    final storageService = await StorageService.getInstance();
    final token = storageService.getString(StorageKeys.token);
    final response = await ApiClient.post('/restaurant/update-name', body: {
      'idRestaurant': restaurant.id,
      'name': restaurant.name,
      'address': restaurant.address,
      'status': restaurant.status,
    }, headers: {
      'Authorization': 'Bearer $token'
    });
    if (response['success'] == true) {
      return response['data'];
    } else {
      return null;
    }
  }

  Future<Map?> deleteRestaurant(String idRestaurant) async {
    final storageService = await StorageService.getInstance();
    final token = storageService.getString(StorageKeys.token);
    final response = await ApiClient.delete('/restaurant/$idRestaurant',
        headers: {'Authorization': 'Bearer $token'});
    if (response['success'] == true) {
      return response['data'];
    } else {
      return null;
    }
  }
}
