import 'dart:io';
import 'package:get/get.dart';

import '../../data/models/api_response_model.dart';
import '../../data/models/user_model.dart';
import '../../data/providers/api_provider.dart';
import '../../data/providers/local_storage_provider.dart';
import '../../values/api_constants.dart';


class AuthRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  final LocalStorageProvider _localStorageProvider = Get.find<LocalStorageProvider>();

  // Register a new user
  Future<ApiResponse<UserModel>> register({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String password,
    required String passwordConfirmation,
    required String role,
    File? image,
  }) async {
    try {
      // Create form data
      Map<String, dynamic> formData = {
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'role': role,
      };

      // Add image if provided
      Map<String, File>? files;
      if (image != null) {
        files = {'image': image};
      }

      // Send registration request
      final response = await _apiProvider.postFormData(
        ApiConstants.register,
        formData: formData,
        files: files,
      );

      // Check for success response
      if (response.success && response.data != null) {
        final responseData = response.data;

        // Check if token is provided
        if (responseData['token'] != null) {
          // Save token
          await _localStorageProvider.saveToken(responseData['token']);

          // Parse user data
          final user = UserModel.fromJson(responseData['user'] ?? {});

          // Save user data
          await _localStorageProvider.saveUser(user);

          return ApiResponse.success(
            message: response.message,
            data: user,
          );
        }

        return ApiResponse.error(
          message: 'Registration failed: No token received',
        );
      }

      // Return the error response
      return response as ApiResponse<UserModel>;
    } catch (e) {
      return ApiResponse.error(
        message: 'Registration failed: ${e.toString()}',
      );
    }
  }

  // Login user
  Future<ApiResponse<UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Create form data
      Map<String, dynamic> data = {
        'email': email,
        'password': password,
      };

      // Send login request
      final response = await _apiProvider.post(
        ApiConstants.login,
        data: data,
      );

      // Check for success response
      if (response.success && response.data != null) {
        final responseData = response.data;

        // Check if token is provided
        if (responseData['token'] != null) {
          // Save token
          await _localStorageProvider.saveToken(responseData['token']);

          // Parse user data
          final user = UserModel.fromJson(responseData['user'] ?? {});

          // Save user data
          await _localStorageProvider.saveUser(user);

          return ApiResponse.success(
            message: response.message,
            data: user,
          );
        }

        return ApiResponse.error(
          message: 'Login failed: No token received',
        );
      }

      // Return the error response
      return response as ApiResponse<UserModel>;
    } catch (e) {
      return ApiResponse.error(
        message: 'Login failed: ${e.toString()}',
      );
    }
  }

  // Change user password
  Future<ApiResponse<bool>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    try {
      // Create form data
      Map<String, dynamic> data = {
        'old_password': oldPassword,
        'password': newPassword,
        'password_confirmation': passwordConfirmation,
      };

      // Send password change request
      final response = await _apiProvider.post(
        ApiConstants.password,
        data: data,
      );

      // Check for success response
      if (response.success) {
        return ApiResponse.success(
          message: response.message,
          data: true,
        );
      }

      // Return the error response
      return ApiResponse.error(
        message: response.message,
        errors: response.errors,
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'Password change failed: ${e.toString()}',
      );
    }
  }

  // Logout user
  Future<void> logout() async {
    await _localStorageProvider.clearAll();
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _localStorageProvider.isLoggedIn();
  }

  // Get current user
  UserModel? getCurrentUser() {
    return _localStorageProvider.getUser();
  }

  // Perform an internal re-login to refresh user data
  Future<ApiResponse<UserModel>> refreshUserData() async {
    // Get stored credentials
    final storedEmail = _localStorageProvider.getStoredEmail();
    final storedPassword = _localStorageProvider.getStoredPassword();

    // If we don't have stored credentials, we can't refresh
    if (storedEmail == null || storedPassword == null) {
      return ApiResponse.error(
        message: 'Cannot refresh user data: No stored credentials',
      );
    }

    // Perform login with stored credentials
    return await login(
      email: storedEmail,
      password: storedPassword,
    );
  }
}