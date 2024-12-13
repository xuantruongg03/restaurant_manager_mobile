import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/bindings/app_binding.dart';
import 'package:restaurant_manager_mobile/config/routes/app_pages.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/services/state_service.dart';
import 'package:restaurant_manager_mobile/core/theme/app_theme.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.getInstance();

  final stateService = Get.put(StateService());
  await stateService.checkAuth();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColors.primary,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Restaurant 4.0',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // home: const MainLayout(),
      initialRoute: RouteNames.splash,
      getPages: AppPages.routes,
      initialBinding: AppBinding(),
    );
  }
}
