class RouteNames {
  // Prevent instantiation
  const RouteNames._();
  
  // Auth Routes
  static const String splash = '/';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';
  static const String verify = '/verify';
  
  // Main Routes
  static const String home = '/home';
  static const String menu = '/menu';
  static const String orders = '/orders';
  static const String tables = '/tables';
  static const String profile = '/profile';
  
  // Feature Routes
  static const String orderDetails = '/orders/details';
  static const String tableDetails = '/tables/details';
  static const String menuItemDetails = '/menu/details';
  static const String settings = '/settings';
}
