// lib/app/core/domain/repositories/profile_repository.dart
import 'dart:io';
import 'package:get/get.dart';

import '../../data/models/api_response_model.dart';
import '../../data/models/user_model.dart';
import '../../data/providers/api_provider.dart';
import '../../data/providers/local_storage_provider.dart';
import '../../values/api_constants.dart';

class ProfileRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  final LocalStorageProvider _localStorageProvider = Get.find<LocalStorageProvider>();

  // Update user profile
  Future<ApiResponse<bool>> updateProfile({
    String? name,
    String? address,
    File? image,
    File? coverImage,
  }) async {
    try {
      // Create form data
      Map<String, dynamic> formData = {};

      if (name != null && name.isNotEmpty) {
        formData['name'] = name;
      }

      if (address != null && address.isNotEmpty) {
        formData['address'] = address;
      }

      // Add image if provided
      Map<String, File>? files = {};

      if (image != null) {
        files['image'] = image;
      }

      if (coverImage != null) {
        files['cover_image'] = coverImage;
      }

      // If no files, set to null
      if (files.isEmpty) {
        files = null;
      }

      // Send profile update request
      final response = await _apiProvider.postFormData(
        ApiConstants.profile,
        formData: formData,
        files: files,
      );

      // Check for success response
      if (response.success && response.data != null) {
        // Based on the response format: {"type":"success","text":"Profile Updated Successfully"}
        final type = response.data['type'] as String?;
        final text = response.data['text'] as String?;

        if (type == 'success') {
          return ApiResponse.success(
            message: text ?? 'Profile updated successfully',
            data: true,
          );
        }
      }

      // Return the error response
      return ApiResponse.error(
        message: response.message,
        errors: response.errors,
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'Profile update failed: ${e.toString()}',
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

      // Just check if the API response was successful
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

  // Get current user
  UserModel? getCurrentUser() {
    return _localStorageProvider.getUser();
  }
}