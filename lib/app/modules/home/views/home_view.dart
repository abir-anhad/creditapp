// lib/app/modules/home/views/home_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../transaction/controllers/transaction_controller.dart';
import '../controllers/home_controller.dart';
import '../../../core/values/app_colors.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Define responsive sizes
    final isTablet = screenWidth > 600;
    final cardPadding = isTablet ? 24.0 : 16.0;
    final headerFontSize = isTablet ? 32.0 : 24.0;
    final titleFontSize = isTablet ? 22.0 : 18.0;
    final bodyFontSize = isTablet ? 16.0 : 14.0;
    final iconSize = isTablet ? 28.0 : 20.0;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchPendingTransactions();
          await controller.fetchShops();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Green header with user info
              Container(
                margin: EdgeInsets.symmetric(vertical: screenHeight * 0.04),
                child: _buildHeader(statusBarHeight, headerFontSize),
              ),

              // Transaction card
              Padding(
                padding: EdgeInsets.fromLTRB(
                    screenWidth * 0.05,
                    0,
                    screenWidth * 0.05,
                    0
                ),
                child: _buildTransactionCard(titleFontSize, bodyFontSize),
              ),

              // Shops list header
              Padding(
                padding: EdgeInsets.fromLTRB(
                    screenWidth * 0.05,
                    screenHeight * 0.025,
                    screenWidth * 0.05,
                    screenHeight * 0.015
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Shops',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to shops list
                      },
                      child: Text(
                        'View more',
                        style: TextStyle(fontSize: bodyFontSize),
                      ),
                    ),
                  ],
                ),
              ),

              // Shops list
              _buildShopsList(screenWidth, bodyFontSize, iconSize, cardPadding),

              // Bottom spacing
              SizedBox(height: screenHeight * 0.1),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(iconSize, bodyFontSize),
    );
  }

  Widget _buildHeader(double statusBarHeight, double fontSize) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, statusBarHeight + 20, 24, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Obx(
                    () => controller.userImageUrl.value.isNotEmpty
                    ? CircleAvatar(
                  radius: 24,
                  backgroundImage:
                  NetworkImage(controller.userImageUrl.value),
                )
                    : const CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary,
                  child: Icon(
                    Icons.person,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: fontSize * 0.6,
                      color: Colors.black87,
                    ),
                  ),
                  Obx(() => Text(
                    controller.username.value,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )),
                ],
              ),
            ],
          ),
          // IconButton(
          //   onPressed: () {
          //     controller.logout();
          //   },
          //   icon: Icon(
          //     Icons.logout,
          //     color: Colors.black87,
          //     size: fontSize * 0.9,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(double titleSize, double bodySize) {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pending Amount',
                style: TextStyle(
                  fontSize: titleSize,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                    '₹ ${controller.totalPendingAmount.value.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: titleSize * 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Obx(() => Text(
                        '${controller.activeShops.value}',
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next Date',
                        style: TextStyle(
                          fontSize: bodySize * 0.9,
                          color: Colors.white70,
                        ),
                      ),
                      Obx(() => Text(
                        controller.payoffDate.value,
                        style: TextStyle(
                          fontSize: bodySize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Shops Active',
                        style: TextStyle(
                          fontSize: bodySize * 0.9,
                          color: Colors.white70,
                        ),
                      ),
                      Obx(() => Text(
                        '${controller.activeShops.value}',
                        style: TextStyle(
                          fontSize: bodySize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShopsList(double screenWidth, double fontSize, double iconSize, double padding) {
    return Obx(() {
      if (controller.isLoadingShops.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (controller.shops.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(
                  Icons.store_outlined,
                  size: iconSize * 2,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 10),
                Text(
                  'No shops found',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: fontSize,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Create a responsive grid or list based on screen width
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: screenWidth > 600
            ? GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: controller.shops.length,
          itemBuilder: (context, index) {
            final shop = controller.shops[index];
            final percentage = (index + 1) * 25;
            return _buildShopCard(shop, percentage, fontSize, iconSize, padding);
          },
        )
            : ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.shops.length,
          itemBuilder: (context, index) {
            final shop = controller.shops[index];
            final percentage = (index + 1) * 25;
            return _buildShopCard(shop, percentage, fontSize, iconSize, padding);
          },
        ),
      );
    });
  }

  Widget _buildShopCard(shop, int percentage, double fontSize, double iconSize, double padding) {
    // Format the amount for display
    double amount = double.tryParse(shop.initialAmount ?? '0') ?? 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => controller.navigateToShopDetails(shop.id ?? 0),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shop icon or image
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.store,
                      color: Colors.green[700],
                      size: iconSize,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Shop details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shop.shopName ?? 'Unknown Shop',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize * 1.1,
                          ),
                        ),
                        Text(
                          '${shop.address} • GST: ${shop.gstNo}',
                          style: TextStyle(
                            fontSize: fontSize * 0.9,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Percentage indicator
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.green,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$percentage%',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize * 0.8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Amount
                  Text(
                    '₹ ${amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize * 1.2,
                    ),
                  ),
                  // Pay button
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {
                        TransactionController transactionController = Get.find<TransactionController>();
                        transactionController.errorMessage.value = '';
                        controller.navigateToCreateTransaction();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: const Size(80, 36),
                        maximumSize: const Size(120, 36),
                      ),
                      child: Text(
                        'Pay off',
                        style: TextStyle(
                          fontSize: fontSize,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // lib/app/modules/home/views/home_view.dart (update the _buildBottomNavBar method)
  Widget _buildBottomNavBar(double iconSize, double fontSize) {
    // Get TransactionController to navigate to transaction screens
    final TransactionController transactionController = Get.find<TransactionController>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home,
                label: 'Home',
                isSelected: true,
                onTap: () {}, // Already on home
                iconSize: iconSize,
                fontSize: fontSize,
              ),
              _buildNavItem(
                icon: Icons.pending_actions,
                label: 'Pending',
                isSelected: false,
                onTap: () {
                  transactionController.navigateToPendingTransactions();
                },
                iconSize: iconSize,
                fontSize: fontSize,
              ),
              _buildNavItem(
                icon: Icons.check_circle_outline,
                label: 'Approved',
                isSelected: false,
                onTap: () {
                  transactionController.navigateToApprovedTransactions();
                },
                iconSize: iconSize,
                fontSize: fontSize,
              ),
              _buildNavItem(
                icon: Icons.person,
                label: 'Profile',
                isSelected: false,
                onTap: () {
                  controller.navigateToProfile();
                },
                iconSize: iconSize,
                fontSize: fontSize,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required double iconSize,
    required double fontSize,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primary : Colors.grey,
            size: iconSize * 0.8,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize * 0.8,
              color: isSelected ? AppColors.primary : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}