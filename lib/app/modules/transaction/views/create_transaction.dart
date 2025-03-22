// lib/app/modules/transaction/views/create_transaction.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/data/models/shop_model.dart';
import '../controllers/transaction_controller.dart';
import '../../../core/values/app_colors.dart';

class CreateTransactionView extends GetView<TransactionController> {
  const CreateTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive layout
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    // Define responsive sizes
    final contentPadding = isTablet ? 24.0 : 16.0;
    final titleFontSize = isTablet ? 28.0 : 24.0;
    final subtitleFontSize = isTablet ? 18.0 : 14.0;
    final bodyFontSize = isTablet ? 16.0 : 14.0;
    final labelFontSize = isTablet ? 16.0 : 14.0;
    final buttonHeight = isTablet ? 60.0 : 50.0;
    final formWidth = isTablet ? screenWidth * 0.8 : double.infinity;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Create Transaction',
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
        child: Column(
          children: [
            _buildHeaderCard(
              titleFontSize,
              subtitleFontSize,
              contentPadding,
              screenWidth,
            ),
            _buildTransactionForm(
              context,
              formWidth,
              labelFontSize,
              bodyFontSize,
              buttonHeight,
              contentPadding,
              isTablet,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(
      double titleSize,
      double subtitleSize,
      double padding,
      double screenWidth,
      ) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(padding),
      padding: EdgeInsets.all(padding * 1.25),
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
          Text(
            'New Transaction',
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: padding * 0.5),
          Text(
            'Fill in the details below to record a new transaction',
            style: TextStyle(
              fontSize: subtitleSize,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionForm(
      BuildContext context,
      double formWidth,
      double labelSize,
      double fontSize,
      double buttonHeight,
      double padding,
      bool isTablet,
      ) {
    return Center(
      child: Container(
        width: formWidth,
        margin: EdgeInsets.all(padding),
        padding: EdgeInsets.all(padding * 1.25),
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
              Text(
                'Transaction Details',
                style: TextStyle(
                  fontSize: labelSize * 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: padding * 1.25),

              // Shop selection dropdown
              Obx(() => _buildShopDropdown(fontSize, labelSize, padding)),

              SizedBox(height: padding),

              // Date picker
              _buildDatePicker(context, fontSize, labelSize, padding),

              SizedBox(height: padding),

              // Amount field
              TextFormField(
                controller: controller.amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: controller.validateAmount,
                style: TextStyle(fontSize: fontSize),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  labelStyle: TextStyle(fontSize: labelSize),
                  prefixText: '₹ ',
                  prefixStyle: TextStyle(fontSize: fontSize),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: padding, vertical: padding),
                ),
              ),

              SizedBox(height: padding),

              // Description field
              TextFormField(
                controller: controller.descriptionController,
                validator: controller.validateDescription,
                maxLines: 3,
                style: TextStyle(fontSize: fontSize),
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(fontSize: labelSize),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: padding, vertical: padding),
                ),
              ),

              SizedBox(height: padding * 1.5),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isCreatingTransaction.value
                      ? null
                      : () => controller.createTransaction(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: controller.isCreatingTransaction.value
                      ? SizedBox(
                    width: buttonHeight * 0.5,
                    height: buttonHeight * 0.5,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : Text(
                    'Create Transaction',
                    style: TextStyle(
                      fontSize: fontSize * 1.1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
              ),

              // Error message
              Obx(() => controller.errorMessage.value.isNotEmpty
                  ? Padding(
                padding: EdgeInsets.only(top: padding),
                child: Text(
                  controller.errorMessage.value,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: fontSize,
                  ),
                ),
              )
                  : const SizedBox.shrink()),

              // Success message
              Obx(() => controller.successMessage.value.isNotEmpty
                  ? Padding(
                padding: EdgeInsets.only(top: padding),
                child: Text(
                  controller.successMessage.value,
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: fontSize,
                  ),
                ),
              )
                  : const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShopDropdown(double fontSize, double labelSize, double padding) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<ShopModel>(
          value: controller.selectedShop.value,
          decoration: InputDecoration(
            labelText: 'Shop',
            labelStyle: TextStyle(fontSize: labelSize),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: padding, vertical: padding),
          ),
          style: TextStyle(fontSize: fontSize, color: Colors.black87),
          validator: (value) => controller.validateShopId(value?.id.toString()),
          items: controller.shopList.map((shop) {
            return DropdownMenuItem<ShopModel>(
              value: shop,
              child: Text(
                shop.shopName ?? 'Unknown Shop',
                style: TextStyle(fontSize: fontSize),
              ),
            );
          }).toList(),
          onChanged: controller.onShopSelected,
          isExpanded: true,
          itemHeight: 60,
          dropdownColor: Colors.white,
        ),
        if (controller.isLoadingShops.value)
          Padding(
            padding: EdgeInsets.only(top: padding * 0.5),
            child: Row(
              children: [
                SizedBox(
                  width: fontSize,
                  height: fontSize,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: padding * 0.5),
                Text(
                  'Loading shops...',
                  style: TextStyle(
                    fontSize: fontSize * 0.9,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context, double fontSize, double labelSize, double padding) {
    return TextFormField(
      controller: controller.dateController,
      readOnly: true,
      validator: controller.validateDate,
      style: TextStyle(fontSize: fontSize),
      decoration: InputDecoration(
        labelText: 'Date',
        labelStyle: TextStyle(fontSize: labelSize),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: padding, vertical: padding),
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today, size: fontSize * 1.2),
          onPressed: () => controller.selectDate(context),
        ),
      ),
      onTap: () => controller.selectDate(context),
    );
  }
}