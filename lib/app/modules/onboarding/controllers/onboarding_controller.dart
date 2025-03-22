import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/data/models/onboarding_model.dart';
import '../../../core/domain/repositories/onboarding_repository.dart';
import '../../../routes/app_pages.dart';

class OnboardingController extends GetxController {
  final OnboardingRepository _onboardingRepository = Get.find<OnboardingRepository>();

  final pageController = PageController();
  final currentPage = 0.obs;
  final onboardingPages = <OnboardingModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadOnboardingData();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  Future<void> _loadOnboardingData() async {
    try {
      isLoading.value = true;
      final data = await _onboardingRepository.getOnboardingData();
      onboardingPages.assignAll(data);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load onboarding data',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void nextPage() {
    if (currentPage.value < onboardingPages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      completeOnboarding();
    }
  }

  void goToPage(int page) {
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void onPageChanged(int page) {
    currentPage.value = page;
  }

  void skip() {
    completeOnboarding();
  }

  void completeOnboarding() async {
    await _onboardingRepository.setFirstTimeCompleted();
    Get.offAllNamed(Routes.HOME);
  }
}