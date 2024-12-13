import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/api_client.dart';
import 'package:restaurant_manager_mobile/data/services/state_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiClient());
    Get.put(StateService());
  }
} 
