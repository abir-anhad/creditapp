class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://124124.site/credit_manage/public/api';
  static const String staticUrl = 'https://124124.site/credit_manage/public/manual_storage/';

  // Authentication endpoints
  static const String register = '/register';
  static const String login = '/login';

  // User profile endpoints
  static const String usersList = '/all-user-list';
  static const String profile = '/profile';
  static const String password = '/password';

  // Shop endpoint
  static const String shop = '/shop';
  static const String shopByUser = '/shop-by-user';

  // Transaction endpoints
  static const String transaction = '/transaction';
  static const String transactionPendingList = '/transaction-pending-list';
  static const String transactionPendingDetails = '/transaction-pending-details';
  static const String transactionApproveList = '/transaction-approve-list';
  static const String transactionApproveDetails = '/transaction-approve-details';


  // Headers
  static const Map<String, String> headers = {
    'Accept': 'application/json',
  };

  // Timeout durations in seconds
  static const int connectTimeout = 30;
  static const int receiveTimeout = 30;
}