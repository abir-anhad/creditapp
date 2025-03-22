class AppConstants {
  // API URLs
  static const String baseUrl = 'https://api.coolcredit.com';

  // Storage keys
  static const String isFirstTimeKey = 'is_first_time';
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';

  // Asset paths
  static const String logoPath = 'assets/images/logo.svg';
  static const String onboardingDataPath = 'assets/data/onboarding_data.json';

  // Animation durations
  static const int splashDuration = 2500; // milliseconds

  // Texts
  static const String appName = 'Cool Credit';
  static const String getStarted = 'Get Started';
  static const String next = 'Next';
  static const String skip = 'Skip';

  // User roles
  static const String roleSender = 'sender';
  static const String roleReceiver = 'receiver';

  // Transaction statuses
  static const String statusPending = 'pending';
  static const String statusApproved = 'approved';
  static const String statusRejected = 'rejected';

  // Error messages
  static const String errorNetworkMessage = 'Please check your internet connection';
  static const String errorServerMessage = 'Server error occurred. Please try again later';
  static const String errorUnknownMessage = 'An unknown error occurred';
}