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

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        // appBar: AppBar(
        //   backgroundColor: isPending ? AppColors.primary : Colors.green,
        //   foregroundColor: Colors.white,
        //   elevation: 0,
        //   title: const Text(
        //     'Transaction Details',
        //     style: TextStyle(
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
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
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No transaction details found',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
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
                      _buildSummaryCard(isPending),
                      _buildTransactionsDetailList(isPending),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              // Using a container instead of BottomAppBar to avoid layout issues
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
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
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 16,
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

  Widget _buildSummaryCard(bool isPending) {
    // Get date from the first transaction detail
    final date = controller.transactionDetails.isNotEmpty
        ? controller.transactionDetails.first.date
        : 'N/A';

    // Calculate total amount - convert string to double first
    double totalAmount = 0.0;
    if (controller.transactionDetails.isNotEmpty) {
      for (var detail in controller.transactionDetails) {
        totalAmount += double.tryParse(detail.amount) ?? 0.0;
      }
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isPending ? AppColors.primary : Colors.green,
        borderRadius: BorderRadius.circular(12),
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
              const Text(
                'Transaction Date',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isPending ? 'Pending' : 'Approved',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            date,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Total Amount',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '₹ ${totalAmount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Items',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    '${controller.transactionDetails.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              // if (isPending)
                // Material(
                //   color: Colors.white,
                //   borderRadius: BorderRadius.circular(20),
                //   child: InkWell(
                //     onTap: () {
                //       controller.navigateToCreateTransaction();
                //     },
                //     borderRadius: BorderRadius.circular(20),
                //     child: Container(
                //       height: 36,
                //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                //       child: const Row(
                //         mainAxisSize: MainAxisSize.min,
                //         children: [
                //           // Icon(
                //           //   Icons.add,
                //           //   size: 16,
                //           //   color: AppColors.primary,
                //           // ),
                //           SizedBox(width: 4),
                //           // Text(
                //           //   'Add Item',
                //           //   style: TextStyle(
                //           //     fontWeight: FontWeight.bold,
                //           //     fontSize: 12,
                //           //     color: AppColors.primary,
                //           //   ),
                //           // ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsDetailList(bool isPending) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.transactionDetails.length,
      itemBuilder: (context, index) {
        final detail = controller.transactionDetails[index];
        return _buildTransactionDetailCard(detail, isPending);
      },
    );
  }

  Widget _buildTransactionDetailCard(detail, bool isPending) {
    // Convert string amount to double for display
    final double amount = double.tryParse(detail.amount) ?? 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
        padding: const EdgeInsets.all(16),
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
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              detail.shopName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        detail.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            detail.ownerName,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  '₹ ${amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      detail.shopPhone,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Text(
                  detail.transactionType,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: detail.transactionType.toLowerCase() == 'cash'
                        ? Colors.green[700]
                        : Colors.blue[700],
                  ),
                ),
              ],
            ),
            if (detail.image != null && detail.image!.isNotEmpty) ...[
              const SizedBox(height: 12),
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