import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tailorhouse/src/core/di/injection.dart';
import 'package:tailorhouse/src/features/auth/presentation/screens/login_screen.dart';
import 'package:tailorhouse/src/features/auth/presentation/screens/signup_screen.dart';
import 'package:tailorhouse/src/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:tailorhouse/src/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:tailorhouse/src/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:tailorhouse/src/features/onboarding/presentation/screens/choose_language_screen.dart';
import 'package:tailorhouse/src/features/onboarding/presentation/screens/enable_location_screen.dart';
import 'package:tailorhouse/src/features/measurement/presentation/screens/home_screen.dart';
import 'package:tailorhouse/src/features/measurement/presentation/screens/ai_measurement_screen.dart';
import 'package:tailorhouse/src/features/measurement/presentation/screens/manual_measurement_screen.dart';
import 'package:tailorhouse/src/features/measurement/presentation/screens/measurement_results_screen.dart';
import 'package:tailorhouse/src/features/measurement/presentation/screens/measurement_profile_details_screen.dart';
import 'package:tailorhouse/src/features/orders/presentation/screens/orders_list_screen.dart';
import 'package:tailorhouse/src/features/orders/presentation/screens/order_details_screen.dart';
import 'package:tailorhouse/src/features/orders/presentation/screens/create_order_screen.dart';
import 'package:tailorhouse/src/features/orders/presentation/screens/alteration_request_screen.dart';
import 'package:tailorhouse/src/features/workflow/presentation/screens/worker_queue_screen.dart';
import 'package:tailorhouse/src/features/customer/presentation/screens/customer_search_screen.dart';
import 'package:tailorhouse/src/features/customer/presentation/screens/customer_order_status_screen.dart';
import 'package:tailorhouse/src/features/profile/presentation/screens/profile_screen.dart';
import 'package:tailorhouse/src/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:tailorhouse/src/features/profile/presentation/screens/settings_screen.dart';
import 'package:tailorhouse/src/features/profile/presentation/screens/change_password_screen.dart';
import 'package:tailorhouse/src/features/shop/presentation/screens/category_screen.dart';
import 'package:tailorhouse/src/features/shop/presentation/screens/cart_screen.dart';
import 'package:tailorhouse/src/core/router/app_shell.dart';
import 'package:tailorhouse/src/features/orders/presentation/bloc/order_bloc.dart';
import 'package:tailorhouse/src/features/measurement/presentation/bloc/measurement_bloc.dart';
import 'package:tailorhouse/src/features/customer/presentation/bloc/customer_bloc.dart';
import 'package:tailorhouse/src/domain/domain.dart';

/// Route names
abstract class AppRoutes {
  // Onboarding
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const chooseLanguage = '/choose-language';
  static const enableLocation = '/enable-location';
  
  // Auth
  static const login = '/login';
  static const signup = '/signup';
  static const forgotPassword = '/forgot-password';
  
  // Main tabs
  static const home = '/home';
  static const category = '/category';
  static const aiCamera = '/ai-camera';
  static const cart = '/cart';
  static const profile = '/profile';
  
  // Measurements
  static const aiMeasurement = '/measurements/ai';
  static const manualMeasurement = '/measurements/manual';
  static const measurementResults = '/measurements/results';
  static const measurementProfile = '/measurements/profile';
  
  // Orders
  static const orders = '/orders';
  static const orderDetails = '/orders/details';
  static const createOrder = '/orders/create';
  static const alterationRequest = '/alteration-request';
  
  // Workflow/Worker
  static const workerQueue = '/workflow/queue';
  
  // Customer
  static const customerSearch = '/customers/search';
  static const customerOrderStatus = '/customers/order-status';
  
  // Profile sub-screens
  static const editProfile = '/profile/edit';
  static const settings = '/settings';
  static const changePassword = '/settings/password';
}

/// Application router configuration
class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash Screen
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      
      // Choose Language
      GoRoute(
        path: AppRoutes.chooseLanguage,
        builder: (context, state) => const ChooseLanguageScreen(),
      ),
      
      // Enable Location
      GoRoute(
        path: AppRoutes.enableLocation,
        builder: (context, state) => const EnableLocationScreen(),
      ),

      // Auth routes
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Main shell with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.category,
            builder: (context, state) => const CategoryScreen(),
          ),
          GoRoute(
            path: AppRoutes.aiCamera,
            builder: (context, state) => const AiMeasurementScreen(orderId: 'TEMP'), // TODO: Get from context
          ),
          GoRoute(
            path: AppRoutes.cart,
            builder: (context, state) => const CartScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Measurement routes
      GoRoute(
        path: AppRoutes.aiMeasurement,
        builder: (context, state) {
          final orderId = state.uri.queryParameters['orderId'] ?? '';
          return BlocProvider(
            create: (context) => sl<MeasurementBloc>(),
            child: AiMeasurementScreen(orderId: orderId),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.manualMeasurement,
        builder: (context, state) {
          final orderId = state.uri.queryParameters['orderId'] ?? '';
          final garmentTypeStr = state.uri.queryParameters['garmentType'] ?? 'thobe';
          final garmentType = GarmentType.values.firstWhere(
            (e) => e.englishName == garmentTypeStr,
            orElse: () => GarmentType.thobe,
          );
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<MeasurementBloc>()),
            ],
            child: ManualMeasurementScreen(
              orderId: orderId,
              garmentType: garmentType,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.measurementResults,
        builder: (context, state) {
          final orderId = state.uri.queryParameters['orderId'] ?? '';
          return MeasurementResultsScreen(orderId: orderId);
        },
      ),
      GoRoute(
        path: AppRoutes.measurementProfile,
        builder: (context, state) {
          final profileId = state.uri.queryParameters['id'] ?? '';
          return MeasurementProfileDetailsScreen(profileId: profileId);
        },
      ),

      // Order routes
      GoRoute(
        path: AppRoutes.orders,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<OrderBloc>(),
          child: const OrdersListScreen(),
        ),
      ),
      GoRoute(
        path: '${AppRoutes.orderDetails}/:orderId',
        builder: (context, state) {
          final orderId = state.pathParameters['orderId']!;
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<OrderBloc>()),
            ],
            child: OrderDetailsScreen(orderId: orderId),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.createOrder,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => sl<OrderBloc>()),
            BlocProvider(create: (context) => sl<CustomerBloc>()),
          ],
          child: const CreateOrderScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.alterationRequest,
        builder: (context, state) => const AlterationRequestScreen(),
      ),

      // Workflow/Worker routes
      GoRoute(
        path: AppRoutes.workerQueue,
        builder: (context, state) {
          final roleStr = state.uri.queryParameters['role'] ?? 'cutter';
          final role = UserRole.values.firstWhere(
            (e) => e.englishName == roleStr,
            orElse: () => UserRole.cutter,
          );
          return WorkerQueueScreen(workerRole: role);
        },
      ),

      // Customer routes
      GoRoute(
        path: AppRoutes.customerSearch,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<CustomerBloc>(),
          child: const CustomerSearchScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.customerOrderStatus,
        builder: (context, state) => const CustomerOrderStatusScreen(),
      ),

      // Profile sub-routes
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
    ],
  );
}
