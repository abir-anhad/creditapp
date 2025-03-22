// lib/app/modules/transaction/views/pending_transaction_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transaction_controller.dart';
import '../../../core/values/app_colors.dart';

class PendingTransactionsView extends GetView<TransactionController> {
  const PendingTransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    // Get screen dimensions for responsive layout
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    // Define responsive sizes
    final contentPadding = isTablet ? 24.0 : 20.0;
    final titleFontSize = isTablet ? 32.0 : 24.0;
    final bodyFontSize = isTablet ? 18.0 : 14.0;
    final smallFontSize = isTablet ? 14.0 : 12.0;
    final iconSize = isTablet ? 28.0 : 20.0;
    final cardPadding = isTablet ? 20.0 : 15.0;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchPendingTransactions();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with user info
              Container(
                margin: EdgeInsets.fromLTRB(0, screenHeight * 0.04, 0, 0),
                child: _buildHeader(statusBarHeight, titleFontSize, contentPadding),
              ),

              // Transactions list
              _buildTransactionsList(
                screenWidth,
                bodyFontSize,
                smallFontSize,
                iconSize,
                cardPadding,
                contentPadding,
                isTablet,
              ),

              // Bottom spacing
              SizedBox(height: screenHeight * 0.1),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(bodyFontSize, iconSize),
    );
  }

  Widget _buildHeader(double statusBarHeight, double fontSize, double padding) {
    return Container(
      padding: EdgeInsets.fromLTRB(padding, statusBarHeight + padding, padding, padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Pending Transactions',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.filter_list,
              color: Colors.black87,
              size: fontSize * 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(
      double screenWidth,
      double fontSize,
      double smallFontSize,
      double iconSize,
      double cardPadding,
      double contentPadding,
      bool isTablet,
      ) {
    return Obx(() {
      if (controller.isLoadingPendingTransactions.value) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(contentPadding),
            child: const CircularProgressIndicator(),
          ),
        );
      }

      if (controller.pendingTransactions.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(contentPadding),
            child: Column(
              children: [
                Icon(
                  Icons.hourglass_empty,
                  size: iconSize * 2,
                  color: Colors.grey[400],
                ),
                SizedBox(height: contentPadding * 0.5),
                Text(
                  'No pending transactions found',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: fontSize,
                  ),
                ),
                SizedBox(height: contentPadding),
                ElevatedButton.icon(
                  onPressed: () {
                    controller.navigateToCreateTransaction();
                  },
                  icon: Icon(Icons.add, size: iconSize * 0.8),
                  label: Text(
                    'Create Transaction',
                    style: TextStyle(fontSize: fontSize),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: contentPadding,
                      vertical: contentPadding * 0.6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Create responsive grid or list based on screen width
      return isTablet
          ? GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: contentPadding),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: contentPadding * 0.5,
          mainAxisSpacing: contentPadding * 0.5,
        ),
        itemCount: controller.pendingTransactions.length,
        itemBuilder: (context, index) {
          final transaction = controller.pendingTransactions[index];
          return _buildTransactionCard(
            transaction,
            fontSize,
            smallFontSize,
            iconSize,
            cardPadding,
          );
        },
      )
          : ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: contentPadding),
        itemCount: controller.pendingTransactions.length,
        itemBuilder: (context, index) {
          final transaction = controller.pendingTransactions[index];
          return _buildTransactionCard(
            transaction,
            fontSize,
            smallFontSize,
            iconSize,
            cardPadding,
          );
        },
      );
    });
  }

  Widget _buildTransactionCard(
      transaction,
      double fontSize,
      double smallFontSize,
      double iconSize,
      double padding,
      ) {
    return Container(
      margin: EdgeInsets.only(bottom: padding),
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
        onTap: () {
          controller.navigateToTransactionDetails(transaction.transactionDate, true);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Transaction icon
                  Container(
                    padding: EdgeInsets.all(padding * 0.7),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.pending_actions,
                      color: Colors.orange[700],
                      size: iconSize,
                    ),
                  ),
                  SizedBox(width: padding * 0.8),
                  // Transaction details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date: ${transaction.transactionDate}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize,
                          ),
                        ),
                        Text(
                          'Multiple transactions',
                          style: TextStyle(
                            fontSize: smallFontSize,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Status indicator
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: padding * 0.5,
                      vertical: padding * 0.25,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Pending',
                      style: TextStyle(
                        color: Colors.orange[800],
                        fontWeight: FontWeight.bold,
                        fontSize: smallFontSize,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: padding * 0.7),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Amount
                  Text(
                    '₹ ${transaction.totalAmount}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize * 1.2,
                    ),
                  ),
                  // View details button
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.navigateToTransactionDetails(transaction.transactionDate, true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: padding,
                          vertical: 0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: const Size(80, 36),
                        maximumSize: const Size(120, 36),
                      ),
                      child: Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: smallFontSize,
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

  Widget _buildBottomNavBar(double fontSize, double iconSize) {
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
                isSelected: false,
                onTap: () {
                  controller.navigateToHome();
                },
                fontSize: fontSize,
                iconSize: iconSize,
              ),
              _buildNavItem(
                icon: Icons.pending_actions,
                label: 'Pending',
                isSelected: true,
                onTap: () {},
                fontSize: fontSize,
                iconSize: iconSize,
              ),
              _buildNavItem(
                icon: Icons.check_circle_outline,
                label: 'Approved',
                isSelected: false,
                onTap: () {
                  controller.navigateToApprovedTransactions();
                },
                fontSize: fontSize,
                iconSize: iconSize,
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
    required double fontSize,
    required double iconSize,
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
              fontSize: fontSize * 0.7,
              color: isSelected ? AppColors.primary : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}