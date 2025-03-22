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
  Future<ApiResponse<UserModel>> updateProfile({
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
        final responseData = response.data;

        // Parse user data
        final user = UserModel.fromJson(responseData['user'] ?? {});

        // Save updated user data
        await _localStorageProvider.saveUser(user);

        return ApiResponse.success(
          message: response.message,
          data: user,
        );
      }

      // Return the error response
      return response as ApiResponse<UserModel>;
    } catch (e) {
      return ApiResponse.error(
        message: 'Profile update failed: ${e.toString()}',
      );
    }
  }

  // Get current user
  UserModel? getCurrentUser() {
    return _localStorageProvider.getUser();
  }
}