// lib/app/modules/profile/controllers/profile_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/domain/repositories/profile_repository.dart';
import '../../../core/data/models/user_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/utils/validators.dart';
import '../../../core/state/base_state.dart';

// Profile-specific states
class ProfileState extends BaseState {
  const ProfileState();
}

class ProfileLoadingState extends ProfileState {
  const ProfileLoadingState();
}

class ProfileLoadedState extends ProfileState {
  final UserModel user;
  const ProfileLoadedState(this.user);
}

class ProfileUpdateLoadingState extends ProfileState {
  const ProfileUpdateLoadingState();
}

class ProfileUpdateSuccessState extends ProfileState {
  final String message;
  const ProfileUpdateSuccessState(this.message);
}

class ProfileUpdateErrorState extends ProfileState {
  final String message;
  final List<String>? errors;
  const ProfileUpdateErrorState({required this.message, this.errors});
}

class PasswordState extends BaseState {
  const PasswordState();
}

class PasswordLoadingState extends PasswordState {
  const PasswordLoadingState();
}

class PasswordSuccessState extends PasswordState {
  final String message;
  const PasswordSuccessState(this.message);
}

class PasswordErrorState extends PasswordState {
  final String message;
  final List<String>? errors;
  const PasswordErrorState({required this.message, this.errors});
}

class ProfileController extends GetxController {
  final ProfileRepository _profileRepository = Get.find<ProfileRepository>();
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
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedProfileImage.value = File(image.path);
    }
  }

  // Select cover image
  Future<void> selectCoverImage() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedCoverImage.value = File(image.path);
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

        if (response.success && response.data != null) {
          // Update auth service with new user data
          _authService.updateUser(response.data!);
          user.value = response.data;

          // Reset selected images
          selectedProfileImage.value = null;
          selectedCoverImage.value = null;

          profileState.value = ProfileUpdateSuccessState(response.message);

          // Show success message
          Get.snackbar(
            'Success',
            response.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.7),
            colorText: Colors.white,
          );
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