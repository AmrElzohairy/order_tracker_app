import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracker_app/core/routing/app_routes.dart';
import 'package:order_tracker_app/core/utils/service_locator.dart';
import 'package:order_tracker_app/features/order/presentation/cubits/order_cubit/order_cubit.dart';
import 'package:order_tracker_app/features/order/presentation/views/add_order_screen.dart';
import 'package:order_tracker_app/features/order/presentation/views/place_picker_screen.dart';
import 'package:order_tracker_app/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';
import 'package:order_tracker_app/features/auth/presentation/views/login_screen.dart';
import 'package:order_tracker_app/features/auth/presentation/views/register_screen.dart';
import 'package:order_tracker_app/features/home/presentation/views/home_screen.dart';
import 'package:order_tracker_app/features/home/presentation/views/orders_screen.dart';
import 'package:order_tracker_app/features/splash_screen/splash_screen.dart';

class RouterGenerationConfig {
  static GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.splashScreen,
    routes: [
      GoRoute(
        name: AppRoutes.splashScreen,
        path: AppRoutes.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: AppRoutes.loginScreen,
        path: AppRoutes.loginScreen,
        builder:
            (context, state) => BlocProvider(
              create: (context) => sl<AuthCubit>(),
              child: const LoginScreen(),
            ),
      ),
      GoRoute(
        name: AppRoutes.registerScreen,
        path: AppRoutes.registerScreen,
        builder:
            (context, state) => BlocProvider(
              create: (context) => sl<AuthCubit>(),
              child: const RegisterScreen(),
            ),
      ),
      GoRoute(
        name: AppRoutes.homeScreen,
        path: AppRoutes.homeScreen,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        name: AppRoutes.addOrderScreen,
        path: AppRoutes.addOrderScreen,
        builder:
            (context, state) => BlocProvider(
              create: (context) => sl<OrderCubit>(),
              child: const AddOrderScreen(),
            ),
      ),
      GoRoute(
        name: AppRoutes.ordersScreen,
        path: AppRoutes.ordersScreen,
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        name: AppRoutes.palcePikerScreen,
        path: AppRoutes.palcePikerScreen,
        builder: (context, state) => const PlacePickerScreen(),
      ),
    ],
  );
}
