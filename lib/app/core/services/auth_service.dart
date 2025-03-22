import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../data/models/user_model.dart';
import '../domain/repositories/auth_repository.dart';


class AuthService extends GetxService {
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoggedIn = false.obs;

  Future<AuthService> init() async {
    // Check if user is logged in
    isLoggedIn.value = _authRepository.isLoggedIn();

    // Get current user if logged in
    if (isLoggedIn.value) {
      currentUser.value = _authRepository.getCurrentUser();
    }

    return this;
  }

  // Handle navigation based on authentication status
  void handleAuthNavigation() {
    if (isLoggedIn.value) {
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  // Update user data
  void updateUser(UserModel user) {
    currentUser.value = user;
  }

  // Handle logout
  Future<void> logout() async {
    await _authRepository.logout();
    isLoggedIn.value = false;
    currentUser.value = null;
    Get.offAllNamed(Routes.LOGIN);
  }

  // Check if user has specific role
  bool hasRole(String role) {
    return currentUser.value?.role == role;
  }

  // Check if user is a sender
  bool isSender() {
    return hasRole('sender');
  }

  // Check if user is a receiver
  bool isReceiver() {
    return hasRole('receiver');
  }
}