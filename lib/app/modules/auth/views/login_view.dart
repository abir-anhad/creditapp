import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../core/values/app_colors.dart';


class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
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
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 32, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: 16),
                    Text(
                      'Welcome to Our Company Credit App. Sign In and Clear!' ,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    // Text(
                    //   'Please read terms/conditions before login.',
                    //   style: TextStyle(
                    //     color: Colors.white70,
                    //     fontSize: 16,
                    //   ),
                    // ),
                  ],
                ),
              ),

              // Login form
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
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
                            height: 48,
                            child: Obx(
                                  () => Row(
                                children: [
                                  Expanded(
                                    child: _buildTab(
                                      title: 'Login',
                                      isSelected: controller.selectedTab.value == 0,
                                      onTap: () => controller.changeTab(0),
                                    ),
                                  ),
                                  const SizedBox(width: 10,),
                                  Expanded(
                                    child: _buildTab(
                                      title: 'Terms',
                                      isSelected: controller.selectedTab.value == 1,
                                      onTap: () => controller.changeTab(1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Content based on selected tab
                          Obx(() => controller.selectedTab.value == 0
                              ? _buildLoginForm()
                              : _buildTermsContent()),
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
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email Field
        const Text(
          'Email',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: 'Sample@gmail.com',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: Colors.grey.shade400,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Password Field
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
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
              decoration: InputDecoration(
                hintText: 'Enter Your Password',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: Colors.grey.shade400,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscurePassword.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey.shade400,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Remember me & Forgot password
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Row(
            //   children: [
            //     SizedBox(
            //       height: 24,
            //       width: 24,
            //       child: Obx(
            //             () => Checkbox(
            //           value: controller.rememberMe.value,
            //           onChanged: (val) => controller.toggleRememberMe(),
            //           activeColor: AppColors.primary,
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(4),
            //           ),
            //         ),
            //       ),
            //     ),
            //     const SizedBox(width: 8),
            //     // const Text(
            //     //   'Remember me',
            //     //   style: TextStyle(
            //     //     fontSize: 14,
            //     //     color: Colors.black87,
            //     //   ),
            //     // ),
            //   ],
            // ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Forget Password',
                style: TextStyle(
                  color: Colors.purple,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Login Button
        SizedBox(
          width: double.infinity,
          height: 54,
          child: Obx(() => ElevatedButton(
            onPressed: controller.isLoggingIn.value ? null : controller.login,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: controller.isLoggingIn.value
                ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
                : const Text(
              'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
        ),

        const SizedBox(height: 24),

        // Or login with


      ],
    );
  }

  Widget _buildTermsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Terms and Conditions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Last updated: March 13, 2025',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Please read these terms and conditions carefully before using our application.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        _buildTermsSection(
          title: '1. Acceptance of Terms',
          content: 'By accessing or using the Cool Credit application, you agree to be bound by these Terms and Conditions and our Privacy Policy. If you disagree with any part of the terms, you may not access the application.',
        ),
        _buildTermsSection(
          title: '2. User Accounts',
          content: 'When you create an account with us, you must provide accurate, complete, and current information. You are responsible for safeguarding the password and for all activities that occur under your account.',
        ),
        _buildTermsSection(
          title: '3. Financial Transactions',
          content: 'You understand that you are responsible for all transactions made through your account. We strive to ensure secure transactions but cannot guarantee that unauthorized third parties will never be able to defeat our security measures.',
        ),
        _buildTermsSection(
          title: '4. Privacy Policy',
          content: 'Our Privacy Policy describes how we handle the information you provide to us when you use our application. You understand that by using our app, you consent to the collection and use of information as set forth in our Privacy Policy.',
        ),
        _buildTermsSection(
          title: '5. Application Changes',
          content: 'We reserve the right to modify or replace these terms of service at any time. If a revision is material, we will try to provide at least 30 days\' notice prior to any new terms taking effect.',
        ),
      ],
    );
  }

  Widget _buildTermsSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}