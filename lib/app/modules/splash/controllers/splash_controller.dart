import 'package:get/get.dart';
import '../../../core/domain/repositories/onboarding_repository.dart';
import '../../../core/values/app_constants.dart';
import '../../../core/services/auth_service.dart';
import '../../../routes/app_pages.dart';


class SplashController extends GetxController {
  final OnboardingRepository _onboardingRepository = Get.find<OnboardingRepository>();
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(milliseconds: AppConstants.splashDuration));

    // Check if it's the first time opening the app
    if (_onboardingRepository.isFirstTime()) {
      // Navigate to onboarding if it's the first time
      Get.offAllNamed(Routes.ONBOARDING);
    } else {
      // Check if user is already logged in
      if (_authService.isLoggedIn.value) {
        // Navigate to home if already logged in
        Get.offAllNamed(Routes.HOME);
      } else {
        // Navigate to login if not logged in
        Get.offAllNamed(Routes.LOGIN);
      }
    }
  }
}