// lib/app/modules/profile/views/profile_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/values/api_constants.dart';
import '../controllers/profile_controller.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/state/profile_state.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive layout
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    // Define responsive sizes
    final contentPadding = isTablet ? 24.0 : 16.0;
    final titleFontSize = isTablet ? 28.0 : 22.0;
    final subtitleFontSize = isTablet ? 18.0 : 14.0;
    final bodyFontSize = isTablet ? 16.0 : 14.0;
    final iconSize = isTablet ? 28.0 : 20.0;
    final buttonHeight = isTablet ? 56.0 : 48.0;
    final imageSize = isTablet ? 120.0 : 100.0;
    final coverHeight = screenHeight * 0.25;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        // User information
        final currentUser = controller.user.value;

        return Column(
          children: [
            // Cover image and profile picture section
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Cover image
                Container(
                  height: coverHeight,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.7),
                  ),
                  child: Stack(
                    children: [
                      // Cover image
                      if (currentUser?.coverImage != null && currentUser!.coverImage!.isNotEmpty)
                        Image.network(
                         '${ApiConstants.staticUrl}${currentUser.coverImage!}',
                          width: double.infinity,
                          height: coverHeight,
                          fit: BoxFit.cover,
                        ),
                      // Cover image overlay with edit button
                      Positioned(
                        top: MediaQuery.of(context).padding.top + contentPadding,
                        right: contentPadding,
                        child: Row(
                          children: [
                            // Edit button
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: AppColors.primary,
                                  size: iconSize * 0.8,
                                ),
                                onPressed: controller.selectCoverImage,
                              ),
                            ),
                            SizedBox(width: contentPadding * 0.5),
                            // Back button
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: AppColors.primary,
                                  size: iconSize * 0.8,
                                ),
                                onPressed: controller.navigateBack,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Profile picture with GestureDetector for tap functionality
                Positioned(
                  bottom: -imageSize / 2,
                  child: GestureDetector(
                    onTap: controller.selectProfileImage,
                    child: Stack(
                      children: [
                        // Profile image
                        Container(
                          width: imageSize,
                          height: imageSize,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            image: currentUser?.image != null && currentUser!.image!.isNotEmpty
                                ? DecorationImage(
                              image: NetworkImage('${ApiConstants.staticUrl}${currentUser.image!}'),
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                          child: currentUser?.image == null || currentUser!.image!.isEmpty
                              ? Icon(
                            Icons.person,
                            size: imageSize * 0.6,
                            color: Colors.grey[400],
                          )
                              : null,
                        ),
                        // Edit profile image button
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: iconSize * 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Profile information section
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: imageSize / 2 + contentPadding,
                  left: contentPadding,
                  right: contentPadding,
                  bottom: contentPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // User name and email
                    Text(
                      currentUser?.name ?? 'User Name',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: contentPadding * 0.3),
                    Text(
                      currentUser?.email ?? 'email@example.com',
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: contentPadding * 0.3),
                    Text(
                      'Role: ${currentUser?.role ?? 'User'}',
                      style: TextStyle(
                        fontSize: bodyFontSize,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: contentPadding * 1.5),

                    // Edit profile form
                    Container(
                      padding: EdgeInsets.all(contentPadding),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Form(
                        key: controller.profileFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontSize: subtitleFontSize * 1.1,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: contentPadding),

                            // Name field
                            TextFormField(
                              controller: controller.nameController,
                              validator: controller.validateName,
                              style: TextStyle(fontSize: bodyFontSize),
                              decoration: InputDecoration(
                                labelText: 'Name',
                                labelStyle: TextStyle(fontSize: bodyFontSize),
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  size: iconSize * 0.8,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: contentPadding,
                                  vertical: contentPadding * 0.75,
                                ),
                              ),
                            ),
                            SizedBox(height: contentPadding),

                            // Address field
                            TextFormField(
                              controller: controller.addressController,
                              validator: controller.validateAddress,
                              style: TextStyle(fontSize: bodyFontSize),
                              decoration: InputDecoration(
                                labelText: 'Address',
                                labelStyle: TextStyle(fontSize: bodyFontSize),
                                prefixIcon: Icon(
                                  Icons.location_on_outlined,
                                  size: iconSize * 0.8,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: contentPadding,
                                  vertical: contentPadding * 0.75,
                                ),
                              ),
                            ),
                            SizedBox(height: contentPadding * 1.5),
                            TextFormField(
                              controller: controller.emailController,
                              validator: controller.validateEmail,
                              style: TextStyle(fontSize: bodyFontSize),
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(fontSize: bodyFontSize),
                                prefixIcon: Icon(
                                  Icons.location_on_outlined,
                                  size: iconSize * 0.8,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: contentPadding,
                                  vertical: contentPadding * 0.75,
                                ),
                              ),
                            ),
                            SizedBox(height: contentPadding * 1.5),
                            TextFormField(
                              controller: controller.phoneController,
                              validator: controller.validatePhone,
                              style: TextStyle(fontSize: bodyFontSize),
                              decoration: InputDecoration(
                                labelText: 'Phone',
                                labelStyle: TextStyle(fontSize: bodyFontSize),
                                prefixIcon: Icon(
                                  Icons.location_on_outlined,
                                  size: iconSize * 0.8,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: contentPadding,
                                  vertical: contentPadding * 0.75,
                                ),
                              ),
                            ),
                            SizedBox(height: contentPadding * 1.5),
                            // Show selected images preview if available
                            if (controller.selectedProfileImage.value != null || controller.selectedCoverImage.value != null)
                              Padding(
                                padding: EdgeInsets.only(bottom: contentPadding),
                                child: Row(
                                  children: [
                                    if (controller.selectedProfileImage.value != null) ...[
                                      Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.file(
                                              controller.selectedProfileImage.value!,
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Profile',
                                            style: TextStyle(
                                              fontSize: bodyFontSize * 0.8,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                    const SizedBox(width: 16),
                                    if (controller.selectedCoverImage.value != null) ...[
                                      Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.file(
                                              controller.selectedCoverImage.value!,
                                              width: 80,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Cover',
                                            style: TextStyle(
                                              fontSize: bodyFontSize * 0.8,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                            // Update profile button
                            SizedBox(
                              width: double.infinity,
                              height: buttonHeight,
                              child: CustomButton(
                                text: 'Update Profile',
                                onPressed: controller.updateProfile,
                                isLoading: controller.profileState.value is ProfileUpdateLoadingState,
                                backgroundColor: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: contentPadding),

                    // Additional options
                    Container(
                      padding: EdgeInsets.all(contentPadding),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Change password button
                          ListTile(
                            leading: Icon(
                              Icons.lock_outline,
                              color: AppColors.primary,
                              size: iconSize,
                            ),
                            title: Text(
                              'Change Password',
                              style: TextStyle(
                                fontSize: bodyFontSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: iconSize * 0.6,
                              color: Colors.grey,
                            ),
                            onTap: controller.navigateToPasswordChange,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: contentPadding * 0.5,
                              vertical: contentPadding * 0.3,
                            ),
                          ),
                          Divider(color: Colors.grey[200]),
                          // Logout button
                          ListTile(
                            leading: Icon(
                              Icons.logout,
                              color: Colors.red,
                              size: iconSize,
                            ),
                            title: Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: bodyFontSize,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              ),
                            ),
                            onTap: () => Get.find<AuthService>().logout(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: contentPadding * 0.5,
                              vertical: contentPadding * 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}