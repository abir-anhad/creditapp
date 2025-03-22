import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../values/app_constants.dart';
import '../models/onboarding_model.dart';
import '../models/user_model.dart';

class LocalStorageProvider extends GetxService {
  late SharedPreferences _prefs;

  // Keys for stored credentials
  static const String userEmailKey = 'user_email';
  static const String userPasswordKey = 'user_password';

  Future<LocalStorageProvider> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // Onboarding methods
  bool isFirstTime() {
    return _prefs.getBool(AppConstants.isFirstTimeKey) ?? true;
  }

  Future<void> setFirstTimeCompleted() async {
    await _prefs.setBool(AppConstants.isFirstTimeKey, false);
  }

  // Load onboarding data from local JSON file
  Future<List<OnboardingModel>> getOnboardingData() async {
    try {
      final String response = await rootBundle.loadString(AppConstants.onboardingDataPath);
      final List<dynamic> data = json.decode(response);
      return data.map((item) => OnboardingModel.fromJson(item)).toList();
    } catch (e) {
      // Fallback to hardcoded data in case of error
      print("Error loading onboarding data: $e");
      return [
        OnboardingModel(
          id: 1,
          title: "Quick Loan",
          description: "You can easily enter a loan without having to be complicated and fast.",
          image: "assets/images/quick_loan.svg",
        ),
        OnboardingModel(
          id: 2,
          title: "Secure",
          description: "Comes with a transaction pin making it safe without fear.",
          image: "assets/images/secure.svg",
        ),
        OnboardingModel(
          id: 3,
          title: "Easy Access",
          description: "Manage your finances anywhere, anytime. Transfer money, pay bills, and monitor your cards with ease.",
          image: "assets/images/easy_access.svg",
        ),
      ];
    }
  }

  // Auth methods
  Future<void> saveToken(String token) async {
    await _prefs.setString(AppConstants.userTokenKey, token);
  }

  String? getToken() {
    return _prefs.getString(AppConstants.userTokenKey);
  }

  Future<void> clearToken() async {
    await _prefs.remove(AppConstants.userTokenKey);
  }

  bool isLoggedIn() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }

  // User data methods
  Future<void> saveUser(UserModel user) async {
    await _prefs.setString(AppConstants.userDataKey, json.encode(user.toJson()));
  }

  UserModel? getUser() {
    final userString = _prefs.getString(AppConstants.userDataKey);
    if (userString != null) {
      return UserModel.fromJson(json.decode(userString));
    }
    return null;
  }

  Future<void> clearUser() async {
    await _prefs.remove(AppConstants.userDataKey);
  }

  // User credentials methods (for internal re-login)
  Future<void> saveUserCredentials(String email, String password) async {
    await _prefs.setString(userEmailKey, email);
    await _prefs.setString(userPasswordKey, password);
  }

  String? getStoredEmail() {
    return _prefs.getString(userEmailKey);
  }

  String? getStoredPassword() {
    return _prefs.getString(userPasswordKey);
  }

  Future<void> clearUserCredentials() async {
    await _prefs.remove(userEmailKey);
    await _prefs.remove(userPasswordKey);
  }

  // Clear all data (for logout)
  Future<void> clearAll() async {
    await clearToken();
    await clearUser();
    await clearUserCredentials();
    // Keep onboarding status
  }
}