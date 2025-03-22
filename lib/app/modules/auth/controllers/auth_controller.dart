import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/data/providers/local_storage_provider.dart';
import '../../../core/domain/repositories/auth_repository.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/utils/validators.dart';
import '../../../routes/app_pages.dart';


class AuthController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final AuthService _authService = Get.find<AuthService>();
  final LocalStorageProvider _localStorageProvider = Get.find<LocalStorageProvider>();

  // Form controllers
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  // Login form fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final Rx<bool> obscurePassword = true.obs;
  final Rx<bool> rememberMe = true.obs;

  // Tab selection
  final RxInt selectedTab = 0.obs;

  // Register form fields
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final emailRegisterController = TextEditingController();
  final passwordRegisterController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final Rx<String> selectedRole = 'sender'.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);

  // Loading states
  final RxBool isLoggingIn = false.obs;
  final RxBool isRegistering = false.obs;

  // Error handling
  final RxString errorMessage = ''.obs;

  @override
  void onClose() {
    // Dispose controllers
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    emailRegisterController.dispose();
    passwordRegisterController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Change tab
  void changeTab(int index) {
    selectedTab.value = index;
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  // Toggle remember me
  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  Future<void> login() async {
    if (loginFormKey.currentState?.validate() ?? false) {
      isLoggingIn.value = true;
      errorMessage.value = '';

      try {
        final response = await _authRepository.login(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        if (response.success && response.data != null) {
          // Save user credentials if remember me is checked
          if (rememberMe.value) {
            // Save credentials securely
            await _localStorageProvider.saveUserCredentials(
                emailController.text.trim(),
                passwordController.text
            );

            // Update auth service with the new user
            _authService.updateUser(response.data!);
            _authService.isLoggedIn.value = true;
          }

          // Clear form
          emailController.clear();
          passwordController.clear();

          // Navigate to home
          Get.offAllNamed(Routes.HOME);
        } else {
          errorMessage.value = response.message;
          Get.snackbar(
              'Login Failed',
              response.message,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red.withOpacity(0.7),
              colorText: Colors.white
          );
        }
      } catch (e) {
        errorMessage.value = 'An error occurred during login. Please try again.';
        Get.snackbar(
            'Error',
            'An error occurred during login. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.7),
            colorText: Colors.white
        );
      } finally {
        isLoggingIn.value = false;
      }
    }
  }

  // Handle login
  Future<void> loginold() async {
    if (loginFormKey.currentState?.validate() ?? false) {
      isLoggingIn.value = true;
      errorMessage.value = '';

      try {
        final response = await _authRepository.login(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        if (response.success && response.data != null) {
          // Save user data if remember me is checked
          if (rememberMe.value) {
            // Update auth service with the new user
            _authService.updateUser(response.data!);
            _authService.isLoggedIn.value = true;
          }

          // Clear form
          emailController.clear();
          passwordController.clear();

          // Navigate to home
          Get.offAllNamed(Routes.HOME);
        } else {
          errorMessage.value = response.message;
          Get.snackbar(
              'Login Failed',
              response.message,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red.withOpacity(0.7),
              colorText: Colors.white
          );
        }
      } catch (e) {
        errorMessage.value = 'An error occurred during login. Please try again.';
        Get.snackbar(
            'Error',
            'An error occurred during login. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.7),
            colorText: Colors.white
        );
      } finally {
        isLoggingIn.value = false;
      }
    }
  }

  // Set selected image
  void setImage(File image) {
    selectedImage.value = image;
  }

  // Set role
  void setRole(String role) {
    selectedRole.value = role;
  }

  // Navigate to registration page
  void goToRegister() {
    Get.toNamed(Routes.REGISTER);
  }

  // Navigate to login page
  void goToLogin() {
    Get.toNamed(Routes.LOGIN);
  }

  // Validate login form
  String? validateEmail(String? value) {
    return Validators.email(value);
  }

  String? validatePassword(String? value) {
    return Validators.password(value);
  }
}