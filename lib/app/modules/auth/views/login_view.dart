// lib/app/modules/auth/views/login_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../core/values/app_colors.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive layout
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    // Define responsive sizes
    final contentPadding = isTablet ? 32.0 : 24.0;
    final titleFontSize = isTablet ? 36.0 : 28.0;
    final subtitleFontSize = isTablet ? 18.0 : 16.0;
    final buttonHeight = isTablet ? 60.0 : 54.0;
    final buttonFontSize = isTablet ? 18.0 : 16.0;
    final inputFontSize = isTablet ? 16.0 : 14.0;
    final inputHeight = isTablet ? 60.0 : 50.0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              Color(0xFF1A2234), // Dark blue
              Color(0xFF2A3548), // Slightly lighter blue
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Padding(
                padding: EdgeInsets.fromLTRB(
                    contentPadding,
                    screenHeight * 0.04,
                    contentPadding,
                    screenHeight * 0.02
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'Welcome to Our Company Credit App. Sign In and Clear!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                  ],
                ),
              ),

              // Login form
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(contentPadding),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: controller.loginFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tabs for Login / Terms
                          SizedBox(
                            height: inputHeight,
                            child: Obx(
                                  () => Row(
                                children: [
                                  Expanded(
                                    child: _buildTab(
                                      title: 'Login',
                                      isSelected: controller.selectedTab.value == 0,
                                      onTap: () => controller.changeTab(0),
                                      fontSize: inputFontSize,
                                    ),
                                  ),
                                  SizedBox(width: contentPadding * 0.4),
                                  Expanded(
                                    child: _buildTab(
                                      title: 'Terms',
                                      isSelected: controller.selectedTab.value == 1,
                                      onTap: () => controller.changeTab(1),
                                      fontSize: inputFontSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          // Content based on selected tab
                          Obx(() => controller.selectedTab.value == 0
                              ? _buildLoginForm(
                            inputHeight,
                            inputFontSize,
                            buttonHeight,
                            buttonFontSize,
                            contentPadding,
                          )
                              : _buildTermsContent(inputFontSize, subtitleFontSize, contentPadding)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required double fontSize,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? Colors.grey.shade300 : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(
      double inputHeight,
      double inputFontSize,
      double buttonHeight,
      double buttonFontSize,
      double padding,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email Field
        Text(
          'Email',
          style: TextStyle(
            fontSize: inputFontSize,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: padding * 0.3),
        Container(
          height: inputHeight,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            style: TextStyle(fontSize: inputFontSize),
            decoration: InputDecoration(
              hintText: 'Sample@gmail.com',
              hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: inputFontSize
              ),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: Colors.grey.shade400,
                size: inputFontSize * 1.5,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: inputHeight * 0.3),
            ),
          ),
        ),

        SizedBox(height: padding * 0.8),

        // Password Field
        Text(
          'Password',
          style: TextStyle(
            fontSize: inputFontSize,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: padding * 0.3),
        Container(
          height: inputHeight,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Obx(
                () => TextField(
              controller: controller.passwordController,
              obscureText: controller.obscurePassword.value,
              textInputAction: TextInputAction.done,
              style: TextStyle(fontSize: inputFontSize),
              decoration: InputDecoration(
                hintText: 'Enter Your Password',
                hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: inputFontSize
                ),
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: Colors.grey.shade400,
                  size: inputFontSize * 1.5,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscurePassword.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey.shade400,
                    size: inputFontSize * 1.5,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: inputHeight * 0.3),
              ),
            ),
          ),
        ),

        SizedBox(height: padding * 0.6),

        // Forget password


        SizedBox(height: padding),

        // Login Button
        SizedBox(
          width: double.infinity,
          height: buttonHeight,
          child: Obx(() => ElevatedButton(
            onPressed: controller.isLoggingIn.value ? null : controller.login,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: controller.isLoggingIn.value
                ? SizedBox(
              height: buttonHeight * 0.4,
              width: buttonHeight * 0.4,
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
                : Text(
              'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontSize: buttonFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
        ),

        SizedBox(height: padding),
      ],
    );
  }

  Widget _buildTermsContent(double fontSize, double titleSize, double padding) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Terms and Conditions',
          style: TextStyle(
            fontSize: titleSize * 1.1,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: padding * 0.6),
        Text(
          'Last updated: March 13, 2025',
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: padding),
        Text(
          'Please read these terms and conditions carefully before using our application.',
          style: TextStyle(
            fontSize: fontSize * 1.1,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: padding * 0.6),
        _buildTermsSection(
          title: '1. Acceptance of Terms',
          content: 'By accessing or using the Cool Credit application, you agree to be bound by these Terms and Conditions and our Privacy Policy. If you disagree with any part of the terms, you may not access the application.',
          fontSize: fontSize,
          titleSize: titleSize,
          padding: padding,
        ),
        _buildTermsSection(
          title: '2. User Accounts',
          content: 'When you create an account with us, you must provide accurate, complete, and current information. You are responsible for safeguarding the password and for all activities that occur under your account.',
          fontSize: fontSize,
          titleSize: titleSize,
          padding: padding,
        ),
        _buildTermsSection(
          title: '3. Financial Transactions',
          content: 'You understand that you are responsible for all transactions made through your account. We strive to ensure secure transactions but cannot guarantee that unauthorized third parties will never be able to defeat our security measures.',
          fontSize: fontSize,
          titleSize: titleSize,
          padding: padding,
        ),
        _buildTermsSection(
          title: '4. Privacy Policy',
          content: 'Our Privacy Policy describes how we handle the information you provide to us when you use our application. You understand that by using our app, you consent to the collection and use of information as set forth in our Privacy Policy.',
          fontSize: fontSize,
          titleSize: titleSize,
          padding: padding,
        ),
        _buildTermsSection(
          title: '5. Application Changes',
          content: 'We reserve the right to modify or replace these terms of service at any time. If a revision is material, we will try to provide at least 30 days\' notice prior to any new terms taking effect.',
          fontSize: fontSize,
          titleSize: titleSize,
          padding: padding,
        ),
      ],
    );
  }

  Widget _buildTermsSection({
    required String title,
    required String content,
    required double fontSize,
    required double titleSize,
    required double padding,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: padding * 0.3),
          Text(
            content,
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}