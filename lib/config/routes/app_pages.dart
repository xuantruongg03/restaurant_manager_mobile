import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/middleware/auth_middleware.dart';
import 'package:restaurant_manager_mobile/presentation/bindings/auth/confirm_phone_binding.dart';
import 'package:restaurant_manager_mobile/presentation/bindings/auth/forgot_pass_binding.dart';
import 'package:restaurant_manager_mobile/presentation/bindings/auth/login_binding.dart';
import 'package:restaurant_manager_mobile/presentation/bindings/auth/sign_up_binding.dart';
import 'package:restaurant_manager_mobile/presentation/bindings/auth/verify_binding.dart';
import 'package:restaurant_manager_mobile/presentation/bindings/bills/bill_binding.dart';
import 'package:restaurant_manager_mobile/presentation/bindings/foods/add_food_binding.dart';
import 'package:restaurant_manager_mobile/presentation/bindings/foods/food_binding.dart';
import 'package:restaurant_manager_mobile/presentation/bindings/menus/add_menu_binding.dart';
import 'package:restaurant_manager_mobile/presentation/bindings/menus/menu_binding.dart';
import 'package:restaurant_manager_mobile/presentation/bindings/payment/payment_binding.dart';
import 'package:restaurant_manager_mobile/presentation/bindings/staff/add_staff_binding.dart';
import 'package:restaurant_manager_mobile/presentation/bindings/staff/staff_binding.dart';
import 'package:restaurant_manager_mobile/presentation/bindings/staff/work_schedule_binding.dart';
import 'package:restaurant_manager_mobile/presentation/bindings/statistic/statistic_binding.dart';
import 'package:restaurant_manager_mobile/presentation/bindings/table/add_table_binding.dart';
import 'package:restaurant_manager_mobile/presentation/bindings/table/table_binding.dart';
import 'package:restaurant_manager_mobile/presentation/layouts/main_layout.dart';
import 'package:restaurant_manager_mobile/presentation/screens/auth/confirm_phone_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/auth/forgot_password.dart';
import 'package:restaurant_manager_mobile/presentation/screens/auth/login_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/auth/sign_up_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/auth/verify_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/bills/bill_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/foods/add_food_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/foods/food_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/menu/add_menu_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/menu/menu_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/payment/payment_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/staff/add_staff_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/staff/staff_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/staff/work_schedule_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/statistic/statistic_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/tables/add_table_screen.dart';
import 'package:restaurant_manager_mobile/presentation/screens/tables/table_screen.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: RouteNames.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),

    GetPage(
      name: RouteNames.signUp,
      page: () => const SignUpScreen(),
      binding: SignUpBinding(),
    ),

    GetPage(
      name: RouteNames.verify,
      page: () => const VerifyScreen(),
      binding: VerifyBinding(),
    ),

    GetPage(
      name: RouteNames.confirmPhone,
      page: () => const ConfirmPhoneScreen(),
      binding: ConfirmPhoneBinding(),
    ),

    GetPage(
      name: RouteNames.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: ForgotPasswordBinding(),
    ),

//Protect route
    GetPage(
      name: RouteNames.splash,
      page: () => const MainLayout(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: RouteNames.menu,
      page: () => const MenuScreen(),
      binding: MenuBinding(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: RouteNames.tables,
      page: () => const TableScreen(),
      binding: TablesBinding(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: RouteNames.addMenu,
      page: () => const AddMenuScreen(),
      binding: AddMenuBinding(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: RouteNames.food,
      page: () => const FoodScreen(),
      binding: FoodBinding(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: RouteNames.addFood,
      page: () => const AddFoodScreen(),
      binding: AddFoodBinding(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: RouteNames.addTable,
      page: () => const AddTableScreen(),
      binding: AddTableBinding(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: RouteNames.bill,
      page: () => const BillScreen(),
      binding: BillBinding(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: RouteNames.staff,
      page: () => const StaffScreen(),
      binding: StaffBinding(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: RouteNames.addStaff,
      page: () => const AddStaffScreen(),
      binding: AddStaffBinding(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: RouteNames.payment,
      page: () => const PaymentScreen(),
      binding: PaymentBinding(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: RouteNames.statistic,
      page: () => const StatisticScreen(),
      binding: StatisticBinding(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: RouteNames.workSchedule,
      page: () => const WorkScheduleScreen(),
      binding: WorkSheduleBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
