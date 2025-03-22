// lib/app/modules/transaction/views/transaction_details_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transaction_controller.dart';
import '../../../core/values/app_colors.dart';

class TransactionDetailView extends GetView<TransactionController> {
  const TransactionDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final bool isPending = args['isPending'] ?? true;

    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Define responsive sizes
    final isTablet = screenWidth > 600;
    final cardPadding = isTablet ? 24.0 : 16.0;
    final titleFontSize = isTablet ? 22.0 : 18.0;
    final bodyFontSize = isTablet ? 16.0 : 14.0;
    final smallFontSize = isTablet ? 14.0 : 12.0;
    final iconSize = isTablet ? 28.0 : 20.0;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Obx(() {
          if (controller.isLoadingTransactionDetails.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.transactionDetails.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: iconSize * 2.5,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'No transaction details found',
                    style: TextStyle(
                      fontSize: bodyFontSize,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  TextButton(
                    onPressed: () {
                      isPending
                          ? controller.navigateToPendingTransactions()
                          : controller.navigateToApprovedTransactions();
                    },
                    child: Text(
                      isPending ? 'Back to Pending' : 'Back to Approved',
                      style: TextStyle(
                        color: isPending ? AppColors.primary : Colors.green,
                        fontSize: bodyFontSize,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummaryCard(isPending, screenWidth, titleFontSize,
                          bodyFontSize, smallFontSize, cardPadding),
                      _buildTransactionsDetailList(
                          isPending,
                          screenWidth,
                          titleFontSize,
                          bodyFontSize,
                          smallFontSize,
                          iconSize,
                          cardPadding),
                      SizedBox(height: screenHeight * 0.03),
                    ],
                  ),
                ),
              ),
              // Bottom navigation bar
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(cardPadding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: () {
                      isPending
                          ? controller.navigateToPendingTransactions()
                          : controller.navigateToApprovedTransactions();
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: cardPadding * 0.75),
                      alignment: Alignment.center,
                      child: Text(
                        'Back',
                        style: TextStyle(
                          fontSize: bodyFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSummaryCard(bool isPending, double screenWidth, double titleSize,
      double bodySize, double smallSize, double padding) {
    // Get date from the first transaction detail
    final date = controller.transactionDetails.isNotEmpty
        ? controller.transactionDetails.first.date
        : 'N/A';

    // Calculate total amount
    double totalAmount = 0.0;
    if (controller.transactionDetails.isNotEmpty) {
      for (var detail in controller.transactionDetails) {
        totalAmount += double.tryParse(detail.amount) ?? 0.0;
      }
    }

    return Container(
      margin: EdgeInsets.all(screenWidth * 0.04),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: isPending ? AppColors.primary : Colors.green,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transaction Date',
                style: TextStyle(
                  fontSize: smallSize,
                  color: Colors.white70,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: padding * 0.75, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isPending ? 'Pending' : 'Approved',
                  style: TextStyle(
                    fontSize: smallSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: padding * 0.5),
          Text(
            date,
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: padding),
          Text(
            'Total Amount',
            style: TextStyle(
              fontSize: smallSize,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: padding * 0.25),
          Text(
            '₹ ${totalAmount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: titleSize * 1.2,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: padding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Items',
                    style: TextStyle(
                      fontSize: smallSize,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    '${controller.transactionDetails.length}',
                    style: TextStyle(
                      fontSize: bodySize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsDetailList(
      bool isPending,
      double screenWidth,
      double titleSize,
      double bodySize,
      double smallSize,
      double iconSize,
      double padding) {
    final isTablet = screenWidth > 600;

    return isTablet
        ? GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: controller.transactionDetails.length,
            itemBuilder: (context, index) {
              final detail = controller.transactionDetails[index];
              return _buildTransactionDetailCard(detail, isPending, titleSize,
                  bodySize, smallSize, iconSize, padding);
            },
          )
        : ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            itemCount: controller.transactionDetails.length,
            itemBuilder: (context, index) {
              final detail = controller.transactionDetails[index];
              return _buildTransactionDetailCard(detail, isPending, titleSize,
                  bodySize, smallSize, iconSize, padding);
            },
          );
  }

  Widget _buildTransactionDetailCard(detail, bool isPending, double titleSize,
      double bodySize, double smallSize, double iconSize, double padding) {
    // Convert string amount to double for display
    final double amount = double.tryParse(detail.amount) ?? 0.0;

    return Container(
      margin: EdgeInsets.only(bottom: padding * 0.75),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: isPending
                                  ? Colors.orange[50]
                                  : Colors.green[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Icon(
                                isPending ? Icons.pending : Icons.check_circle,
                                color: isPending
                                    ? Colors.orange[700]
                                    : Colors.green[700],
                                size: iconSize * 0.7,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              detail.shopName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: bodySize * 1.1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: padding * 0.75),
                      Text(
                        detail.description,
                        style: TextStyle(
                          fontSize: smallSize,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: padding * 0.5),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: iconSize * 0.6,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              detail.ownerName,
                              style: TextStyle(
                                fontSize: smallSize,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  '₹ ${amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: bodySize,
                  ),
                ),
              ],
            ),
            Divider(height: padding * 1.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      size: iconSize * 0.6,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      detail.shopPhone,
                      style: TextStyle(
                        fontSize: smallSize,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Text(
                  detail.transactionType,
                  style: TextStyle(
                    fontSize: smallSize,
                    fontWeight: FontWeight.bold,
                    color: detail.transactionType.toLowerCase() == 'cash'
                        ? Colors.green[700]
                        : Colors.blue[700],
                  ),
                ),
              ],
            ),
            if (detail.image != null && detail.image!.isNotEmpty) ...[
              SizedBox(height: padding * 0.75),
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(detail.image!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
