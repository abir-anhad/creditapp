import 'package:get/get.dart';

// Modules
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/middlewares/auth_middleware.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/change_password_view.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/transaction/views/approved_transaction_view.dart';
import '../modules/transaction/views/create_transaction.dart';
import '../modules/transaction/views/pending_transaction_view.dart';
import '../modules/transaction/views/transaction_details_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    // Core routes
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),

    // Auth routes
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
      middlewares: [AuthMiddleware()],
    ),
    // GetPage(
    //   name: Routes.REGISTER,
    //   page: () => const RegisterView(),
    //   binding: AuthBinding(),
    // ),
    //
    // // Main app routes
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      middlewares: [AuthMiddleware()],
      binding: HomeBinding(),
    ),
    //
    // // Profile routes
    // GetPage(
    //   name: Routes.PROFILE,
    //   page: () => const ProfileView(),
    //   binding: ProfileBinding(),
    // ),
    // GetPage(
    //   name: Routes.CHANGE_PASSWORD,
    //   page: () => const ChangePasswordView(),
    //   binding: ProfileBinding(),
    // ),
    //
    // // Shop routes
    // GetPage(
    //   name: Routes.SHOP,
    //   page: () => const ShopView(),
    //   binding: ShopBinding(),
    // ),
    //
    // // Transaction routes
    GetPage(
      name: Routes.CREATE_TRANSACTION,
      page: () => const CreateTransactionView(),
      // binding: TransactionBinding(),
    ),
    GetPage(
      name: Routes.PENDING_TRANSACTIONS,
      page: () => const PendingTransactionsView(),
      // binding: TransactionBinding(),
    ),
    GetPage(
      name: Routes.APPROVED_TRANSACTIONS,
      page: () => const ApprovedTransactionsView(),
      // binding: TransactionBinding(),
    ),
    GetPage(
      name: Routes.TRANSACTION_DETAILS,
      page: () => const TransactionDetailView(),
      // binding: TransactionBinding(),
    ),
  ];
}
