import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controllers/onboarding_controller.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_constants.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          return Column(
            children: [
              // Skip button at the top right
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, right: 16.0),
                  child: TextButton(
                    onPressed: controller.skip,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              // Page view of onboarding screens
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: controller.onboardingPages.length,
                  itemBuilder: (context, index) {
                    final page = controller.onboardingPages[index];

                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo at the top
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.accent,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'C',
                                      style: TextStyle(
                                        color: AppColors.textDark,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'COOL ',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Credit',
                                        style: TextStyle(
                                          color: AppColors.textDark,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Illustration
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              child: SvgPicture.asset(
                                page.image,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Title
                          Text(
                            page.title,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Description
                          Text(
                            page.description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textLight,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Bottom section with indicator and button
              Container(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Page indicator
                    Obx(() => SmoothPageIndicator(
                      controller: controller.pageController,
                      count: controller.onboardingPages.length,
                      effect: const WormEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 8,
                        activeDotColor: AppColors.primary,
                        dotColor: Colors.grey,
                      ),
                    )),

                    // Next or Get Started button - Fixed with explicit constraints
                    Obx(() {
                      final isLastPage = controller.currentPage.value == controller.onboardingPages.length - 1;

                      return ElevatedButton(
                        onPressed: controller.nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          minimumSize: const Size(100, 48), // Add explicit minimum width
                          maximumSize: const Size(200, 56), // Add explicit maximum width
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Important to prevent infinite width
                          children: [
                            Text(
                              isLastPage ? AppConstants.getStarted : AppConstants.next,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (isLastPage)
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Icon(Icons.arrow_forward, size: 16),
                              )
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),

              // Bottom indicator line
              Container(
                width: 100,
                height: 5,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}