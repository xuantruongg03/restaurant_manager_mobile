import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/services/state_service.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final stateService = Get.find<StateService>();
    if (!stateService.isAuthenticated) {
      return const RouteSettings(name: RouteNames.login);
    }
    return null;
  }
}