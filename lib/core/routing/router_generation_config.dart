import 'package:go_router/go_router.dart';
import 'package:order_tracker_app/core/routing/app_routes.dart';
import 'package:order_tracker_app/features/auth/login_screen.dart';
import 'package:order_tracker_app/features/auth/register_screen.dart';
import 'package:order_tracker_app/features/splash_screen/splash_screen.dart';


class RouterGenerationConfig {
  static GoRouter goRouter =
      GoRouter(initialLocation: AppRoutes.splashScreen, routes: [
    GoRoute(
      name: AppRoutes.splashScreen,
      path: AppRoutes.splashScreen,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      name: AppRoutes.loginScreen,
      path: AppRoutes.loginScreen,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: AppRoutes.registerScreen,
      path: AppRoutes.registerScreen,
      builder: (context, state) => const RegisterScreen(),
    ),
  ]);
}
