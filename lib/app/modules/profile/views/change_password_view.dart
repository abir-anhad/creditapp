// lib/app/modules/profile/views/change_password_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/state/profile_state.dart';

class ChangePasswordView extends GetView<ProfileController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive layout
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    // Define responsive sizes
    final contentPadding = isTablet ? 24.0 : 16.0;
    final titleFontSize = isTablet ? 28.0 : 22.0;
    final bodyFontSize = isTablet ? 16.0 : 14.0;
    final iconSize = isTablet ? 24.0 : 20.0;
    final buttonHeight = isTablet ? 56.0 : 48.0;
    final formWidth = isTablet ? screenWidth * 0.7 : double.infinity;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: TextStyle(
            fontSize: titleFontSize * 0.8,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(contentPadding),
          child: Center(
            child: Container(
              width: formWidth,
              padding: EdgeInsets.all(contentPadding),
              margin: EdgeInsets.only(top: contentPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: controller.passwordFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lock_outline,
                          color: AppColors.primary,
                          size: iconSize * 1.2,
                        ),
                        SizedBox(width: contentPadding * 0.5),
                        Text(
                          'Change Your Password',
                          style: TextStyle(
                            fontSize: titleFontSize * 0.9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: contentPadding * 0.5),
                    Text(
                      'Enter your current password and a new password to change it.',
                      style: TextStyle(
                        fontSize: bodyFontSize,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: contentPadding * 1.5),

                    // Current password field
                    Obx(() => TextFormField(
                      controller: controller.oldPasswordController,
                      obscureText: controller.obscureOldPassword.value,
                      validator: controller.validateOldPassword,
                      style: TextStyle(fontSize: bodyFontSize),
                      decoration: InputDecoration(
                        labelText: 'Current Password',
                        labelStyle: TextStyle(fontSize: bodyFontSize),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          size: iconSize,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.obscureOldPassword.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: iconSize,
                          ),
                          onPressed: controller.toggleOldPasswordVisibility,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: contentPadding,
                          vertical: contentPadding * 0.75,
                        ),
                      ),
                    )),
                    SizedBox(height: contentPadding),

                    // New password field
                    Obx(() => TextFormField(
                      controller: controller.newPasswordController,
                      obscureText: controller.obscureNewPassword.value,
                      validator: controller.validateNewPassword,
                      style: TextStyle(fontSize: bodyFontSize),
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        labelStyle: TextStyle(fontSize: bodyFontSize),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          size: iconSize,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.obscureNewPassword.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: iconSize,
                          ),
                          onPressed: controller.toggleNewPasswordVisibility,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: contentPadding,
                          vertical: contentPadding * 0.75,
                        ),
                      ),
                    )),
                    SizedBox(height: contentPadding),

                    // Confirm password field
                    Obx(() => TextFormField(
                      controller: controller.confirmPasswordController,
                      obscureText: controller.obscureConfirmPassword.value,
                      validator: controller.validateConfirmPassword,
                      style: TextStyle(fontSize: bodyFontSize),
                      decoration: InputDecoration(
                        labelText: 'Confirm New Password',
                        labelStyle: TextStyle(fontSize: bodyFontSize),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          size: iconSize,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.obscureConfirmPassword.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: iconSize,
                          ),
                          onPressed:
                          controller.toggleConfirmPasswordVisibility,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: contentPadding,
                          vertical: contentPadding * 0.75,
                        ),
                      ),
                    )),
                    SizedBox(height: contentPadding * 2),

                    // Change password button
                    SizedBox(
                      width: double.infinity,
                      height: buttonHeight,
                      child: Obx(() => CustomButton(
                        text: 'Change Password',
                        onPressed: controller.changePassword,
                        isLoading: controller.passwordState.value
                        is PasswordLoadingState,
                        backgroundColor: AppColors.primary,
                      )),
                    ),

                    SizedBox(height: contentPadding),

                    // Cancel button
                    SizedBox(
                      width: double.infinity,
                      height: buttonHeight,
                      child: CustomButton(
                        text: 'Cancel',
                        onPressed: controller.navigateBack,
                        isOutlined: true,
                        backgroundColor: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}