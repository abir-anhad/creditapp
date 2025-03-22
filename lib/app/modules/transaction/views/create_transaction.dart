import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/data/models/shop_model.dart';
import '../controllers/transaction_controller.dart';
import '../../../core/values/app_colors.dart';

class CreateTransactionView extends GetView<TransactionController> {
  const CreateTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Create Transaction'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderCard(),
            _buildTransactionForm(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color.fromARGB(255, 81, 120, 240)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'New Transaction',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Fill in the details below to record a new transaction',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionForm(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: controller.createTransactionFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transaction Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Shop selection dropdown
            Obx(() => _buildShopDropdown()),

            const SizedBox(height: 16),

            // Date picker
            _buildDatePicker(context),

            const SizedBox(height: 16),

            // Amount field
            TextFormField(
              controller: controller.amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: controller.validateAmount,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '₹ ',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),

            const SizedBox(height: 16),

            // Description field
            TextFormField(
              controller: controller.descriptionController,
              validator: controller.validateDescription,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),

            const SizedBox(height: 24),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(() => ElevatedButton(
                onPressed: controller.isCreatingTransaction.value
                    ? null
                    : () => controller.createTransaction(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: controller.isCreatingTransaction.value
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text(
                  'Create Transaction',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
            ),

            // Error message
            Obx(() => controller.errorMessage.value.isNotEmpty
                ? Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                controller.errorMessage.value,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            )
                : const SizedBox.shrink()),

            // Success message
            Obx(() => controller.successMessage.value.isNotEmpty
                ? Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                controller.successMessage.value,
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                ),
              ),
            )
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  Widget _buildShopDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<ShopModel>(
          value: controller.selectedShop.value,
          decoration: const InputDecoration(
            labelText: 'Shop',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (value) => controller.validateShopId(value?.id.toString()),
          items: controller.shopList.map((shop) {
            return DropdownMenuItem<ShopModel>(
              value: shop,
              child: Text(shop.shopName ?? 'Unknown Shop'),
            );
          }).toList(),
          onChanged: controller.onShopSelected,
          isExpanded: true,
        ),
        if (controller.isLoadingShops.value)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Loading shops...',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return TextFormField(
      controller: controller.dateController,
      readOnly: true,
      validator: controller.validateDate,
      decoration: InputDecoration(
        labelText: 'Date',
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => controller.selectDate(context),
        ),
      ),
      onTap: () => controller.selectDate(context),
    );
  }
}