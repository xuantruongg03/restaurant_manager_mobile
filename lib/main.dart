import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_manager_mobile/config/routes/app_router.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/core/theme/app_theme.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Set fullscreen mode
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColors.primary, // Làm trong suốt thanh trạng thái
    statusBarIconBrightness: Brightness.light, // Thay đổi màu biểu tượng trên thanh trạng thái
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Manager',
      debugShowCheckedModeBanner: false,
      
      // Theme
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme,
      
      // Routing
      initialRoute: RouteNames.tables, // Tạm thời set làm màn hình khởi đầu
      // initialRoute: RouteNames.splash, // Đặt route ban đầu là splash
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}