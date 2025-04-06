import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/bindings/app_binding.dart';
import 'package:restaurant_manager_mobile/config/routes/app_pages.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/data/services/auth_service.dart';
import 'package:restaurant_manager_mobile/data/services/state_service.dart';
import 'package:restaurant_manager_mobile/core/theme/app_theme.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pushy_flutter/pushy_flutter.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/main_layout_controller.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/noti/noti_controller.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';
import 'package:flutter_localizations/flutter_localizations.dart';  

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.getInstance();

  final stateService = Get.put(StateService());
  await stateService.checkAuth();

  final checkAuth = await AuthService().checkAuth();
  final initialRoute = checkAuth ? RouteNames.home : RouteNames.login;

  Pushy.listen();
  Pushy.toggleInAppBanner(true);
  Pushy.setNotificationListener(backgroundNotificationListener);
  Pushy.setNotificationClickListener((Map<String, dynamic> data) {
    if (data.isNotEmpty) {
      final MainLayoutController controller = Get.put(MainLayoutController());
      controller.changeScreen(3);
      Pushy.clearBadge();
    } else {
      print('No data received on notification click.');
    }
  });

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColors.primary,
    statusBarIconBrightness: Brightness.light,
  ));

  await dotenv.load(fileName: '.env');

  runApp(MyApp(initialRoute: initialRoute));
}

@pragma('vm:entry-point')
void backgroundNotificationListener(Map<String, dynamic> data) {
  String notificationTitle = Constants.appName;
  String notificationText = data['message'] ?? 'Hello World!';
  final notiController = Get.put(NotiController());
  notiController.handleNotification(data['message']);
  Pushy.notify(notificationTitle, notificationText, data);
  Pushy.clearBadge();
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Restaurant 4.0',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      initialBinding: AppBinding(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('vi', 'VN'),
        Locale('en', 'US'),
      ],
    );
  }
}

