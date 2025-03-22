part of 'app_pages.dart';

abstract class Routes {
  // Core routes
  static const SPLASH = '/splash';
  static const ONBOARDING = '/onboarding';

  // Auth routes
  static const LOGIN = '/login';
  static const REGISTER = '/register';

  // Main app routes
  static const HOME = '/home';

  // Profile routes
  static const PROFILE = '/profile';
  static const CHANGE_PASSWORD = '/change-password';

  // Shop routes
  static const SHOP = '/shop';

  // Transaction routes
  static const CREATE_TRANSACTION = '/create-transaction';
  static const PENDING_TRANSACTIONS = '/pending-transactions';
  static const APPROVED_TRANSACTIONS = '/approved-transactions';
  static const TRANSACTION_DETAILS = '/transaction-details';
}