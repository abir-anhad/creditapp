import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class AuthMiddleware extends GetMiddleware {
  final AuthService _authService = Get.find<AuthService>();

  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final bool isLoggedIn = _authService.isLoggedIn.value;

    // Redirect logged-in users away from auth pages
    if (isLoggedIn && {Routes.LOGIN, Routes.REGISTER}.contains(route)) {
      return const RouteSettings(name: Routes.HOME);
    }

    // Redirect non-logged-in users trying to access protected routes
    if (!isLoggedIn &&
        !{Routes.LOGIN, Routes.REGISTER, Routes.ONBOARDING, Routes.SPLASH}.contains(route)) {
      return const RouteSettings(name: Routes.LOGIN);
    }

    // Redirect non-logged-in users from HOME to LOGIN
    if (!isLoggedIn && route == Routes.HOME) {
      return const RouteSettings(name: Routes.LOGIN);
    }

    return null; // Allow normal navigation
  }
}
