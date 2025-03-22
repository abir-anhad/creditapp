// lib/app/modules/profile/controllers/profile_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/domain/repositories/auth_repository.dart';
import '../../../core/domain/repositories/profile_repository.dart';
import '../../../core/data/models/user_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/utils/validators.dart';
import '../../../core/state/profile_state.dart';

class ProfileController extends GetxController {
  final ProfileRepository _profileRepository = Get.find<ProfileRepository>();
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final AuthService _authService = Get.find<AuthService>();

  // Reactive state variables
  final Rx<ProfileState> profileState = Rx<ProfileState>(const ProfileState());
  final Rx<PasswordState> passwordState = Rx<PasswordState>(const PasswordState());

  // User data
  final Rx<UserModel?> user = Rx<UserModel?>(null);

  // Form controllers
  final GlobalKey<FormState> profileFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();

  // Profile form fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Password form fields
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final RxBool obscureOldPassword = true.obs;
  final RxBool obscureNewPassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;

  // Image selection
  final Rx<File?> selectedProfileImage = Rx<File?>(null);
  final Rx<File?> selectedCoverImage = Rx<File?>(null);
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Load current user data
  void loadUserData() {
    final currentUser = _authService.currentUser.value;

    if (currentUser != null) {
      user.value = currentUser;
      nameController.text = currentUser.name ?? '';
      addressController.text = currentUser.address ?? '';
      profileState.value = ProfileLoadedState(currentUser);
    }
  }

  // Toggle password visibility
  void toggleOldPasswordVisibility() => obscureOldPassword.value = !obscureOldPassword.value;
  void toggleNewPasswordVisibility() => obscureNewPassword.value = !obscureNewPassword.value;
  void toggleConfirmPasswordVisibility() => obscureConfirmPassword.value = !obscureConfirmPassword.value;

  // Select profile image
  Future<void> selectProfileImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedProfileImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    }
  }

  // Select cover image
  Future<void> selectCoverImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedCoverImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    }
  }

  // Update profile
  Future<void> updateProfile() async {
    if (profileFormKey.currentState?.validate() ?? false) {
      profileState.value = const ProfileUpdateLoadingState();

      try {
        final response = await _profileRepository.updateProfile(
          name: nameController.text.trim(),
          address: addressController.text.trim(),
          image: selectedProfileImage.value,
          coverImage: selectedCoverImage.value,
        );

        if (response.success) {
          // Reset selected images
          selectedProfileImage.value = null;
          selectedCoverImage.value = null;

          // Perform internal re-login to refresh user data
          final refreshResponse = await _authRepository.refreshUserData();

          if (refreshResponse.success && refreshResponse.data != null) {
            // Update auth service with fresh user data
            _authService.updateUser(refreshResponse.data!);

            // Update local user variable
            user.value = refreshResponse.data;

            // Show success message
            Get.snackbar(
              'Success',
              response.message,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withOpacity(0.7),
              colorText: Colors.white,
            );

            profileState.value = ProfileUpdateSuccessState(response.message);
          } else {
            // If refresh fails, still mark the update as successful
            // but log the refresh failure
            print('Profile updated but failed to refresh user data: ${refreshResponse.message}');

            // Show partial success message
            Get.snackbar(
              'Success',
              'Profile updated successfully, but some changes may require you to log in again to take effect.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.yellow.withOpacity(0.7),
              colorText: Colors.black,
            );

            profileState.value = ProfileUpdateSuccessState(response.message);
          }
        } else {
          profileState.value = ProfileUpdateErrorState(
            message: response.message,
            errors: response.errors,
          );

          // Show error message
          Get.snackbar(
            'Error',
            response.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.7),
            colorText: Colors.white,
          );
        }
      } catch (e) {
        profileState.value = ProfileUpdateErrorState(
          message: 'Profile update failed: ${e.toString()}',
        );

        // Show error message
        Get.snackbar(
          'Error',
          'Profile update failed: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white,
        );
      }
    }
  }

  // Change password
  Future<void> changePassword() async {
    if (passwordFormKey.currentState?.validate() ?? false) {
      passwordState.value = const PasswordLoadingState();

      try {
        final response = await _profileRepository.changePassword(
          oldPassword: oldPasswordController.text,
          newPassword: newPasswordController.text,
          passwordConfirmation: confirmPasswordController.text,
        );

        if (response.success) {
          // Clear password fields
          oldPasswordController.clear();
          newPasswordController.clear();
          confirmPasswordController.clear();

          passwordState.value = PasswordSuccessState(response.message);

          // Show success message
          Get.snackbar(
            'Success',
            response.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.7),
            colorText: Colors.white,
          );
        } else {
          passwordState.value = PasswordErrorState(
            message: response.message,
            errors: response.errors,
          );

          // Show error message
          Get.snackbar(
            'Error',
            response.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.7),
            colorText: Colors.white,
          );
        }
      } catch (e) {
        passwordState.value = PasswordErrorState(
          message: 'Password change failed: ${e.toString()}',
        );

        // Show error message
        Get.snackbar(
          'Error',
          'Password change failed: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white,
        );
      }
    }
  }

  // Navigation methods
  void navigateToPasswordChange() {
    Get.toNamed('/change-password');
  }

  void navigateBack() {
    Get.back();
  }

  // Validation methods
  String? validateName(String? value) {
    return Validators.required(value, 'Name');
  }

  String? validateAddress(String? value) {
    return Validators.required(value, 'Address');
  }

  String? validateOldPassword(String? value) {
    return Validators.required(value, 'Current password');
  }

  String? validateNewPassword(String? value) {
    return Validators.password(value);
  }

  String? validateConfirmPassword(String? value) {
    if (value != newPasswordController.text) {
      return 'Passwords do not match';
    }
    return Validators.required(value, 'Confirm password');
  }
}