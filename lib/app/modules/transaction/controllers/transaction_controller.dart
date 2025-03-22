import 'package:credit_app/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/data/models/shop_model.dart';
import '../../../core/data/models/transaction_model.dart';
import '../../../core/domain/repositories/shop_repository.dart';
import '../../../core/domain/repositories/transaction_repository.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/utils/validators.dart';
import '../../../routes/app_pages.dart';

class TransactionController extends GetxController {
  final TransactionRepository _transactionRepository = Get.find<TransactionRepository>();
  final ShopRepository _shopRepository = Get.find<ShopRepository>();
  final AuthService _authService = Get.find<AuthService>();

  // Form key for transaction creation
  final GlobalKey<FormState> createTransactionFormKey = GlobalKey<FormState>();

  // Create transaction form fields
  final TextEditingController shopIdController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Shop selection
  final RxList<ShopModel> shopList = <ShopModel>[].obs;
  final Rx<ShopModel?> selectedShop = Rx<ShopModel?>(null);

  // Transaction lists
  final RxList<TransactionSummary> pendingTransactions = <TransactionSummary>[].obs;
  final RxList<TransactionSummary> approvedTransactions = <TransactionSummary>[].obs;
  final RxList<TransactionDetail> transactionDetails = <TransactionDetail>[].obs;

  // Loading states
  final RxBool isLoadingShops = false.obs;
  final RxBool isCreatingTransaction = false.obs;
  final RxBool isLoadingPendingTransactions = false.obs;
  final RxBool isLoadingApprovedTransactions = false.obs;
  final RxBool isLoadingTransactionDetails = false.obs;

  // Error and success messages
  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;

  // Computed values for UI
  final Rx<double> totalPendingAmount = 0.0.obs;
  final Rx<double> totalApprovedAmount = 0.0.obs;
  final RxString nextPaymentDate = 'None'.obs;
  final RxString lastApprovalDate = 'None'.obs;

  @override
  void onInit() {
    super.onInit();
    // Set default date to today
    dateController.text = DateTime.now().toString().split(' ')[0];

    // Load shops
    fetchShops();

    // Load initial pending and approved transactions
    fetchPendingTransactions();
    fetchApprovedTransactions();
  }

  @override
  void onClose() {
    // Dispose controllers
    // shopIdController.dispose();
    // dateController.dispose();
    // amountController.dispose();
    // descriptionController.dispose();
    super.onClose();
  }

  // Update computed values whenever transaction lists change
  void _updateComputedValues() {
    // Calculate total pending amount
    if (pendingTransactions.isNotEmpty) {
      totalPendingAmount.value = pendingTransactions
          .map((transaction) => transaction.totalAmount)
          .reduce((sum, amount) => sum + amount) as double;

      // Update next payment date (using the earliest date)
      final sortedDates = pendingTransactions
          .map((transaction) => transaction.transactionDate)
          .toList()
        ..sort();
      nextPaymentDate.value = sortedDates.firstOrNull ?? 'None';
    } else {
      totalPendingAmount.value = 0.0;
      nextPaymentDate.value = 'None';
    }

    // Calculate total approved amount
    if (approvedTransactions.isNotEmpty) {
      totalApprovedAmount.value = approvedTransactions
          .map((transaction) => transaction.totalAmount)
          .reduce((sum, amount) => sum + amount) as double;

      // Update last approval date (using the most recent date)
      final sortedDates = approvedTransactions
          .map((transaction) => transaction.transactionDate)
          .toList()
        ..sort((a, b) => b.compareTo(a)); // Descending order
      lastApprovalDate.value = sortedDates.firstOrNull ?? 'None';
    } else {
      totalApprovedAmount.value = 0.0;
      lastApprovalDate.value = 'None';
    }
  }

  // Fetch shops for dropdown
  Future<void> fetchShops() async {
    isLoadingShops.value = true;
    errorMessage.value = '';

    try {
      final response = await _shopRepository.getShops();

      if (response.success && response.data != null) {
        shopList.assignAll(response.data as Iterable<ShopModel>);

        // Select first shop by default if available
        if (shopList.isNotEmpty) {
          selectedShop.value = shopList.first;
          shopIdController.text = shopList.first.id.toString();
        }
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = 'Failed to load shops: ${e.toString()}';
    } finally {
      isLoadingShops.value = false;
    }
  }

  // Handle shop selection
  void onShopSelected(ShopModel? shop) {
    if (shop != null) {
      selectedShop.value = shop;
      shopIdController.text = shop.id.toString();
    }
  }

  // Open date picker
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      dateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  // Create transaction
  Future<void> createTransaction() async {
    if (createTransactionFormKey.currentState!.validate()) {
      isCreatingTransaction.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      try {
        final response = await _transactionRepository.createTransaction(
          shopId: int.parse(shopIdController.text),
          date: dateController.text,
          amount: double.parse(amountController.text),
          description: descriptionController.text,
        );

        if (response.success) {
          successMessage.value = response.message;

          // Clear form
          amountController.clear();
          descriptionController.clear();


          // Refresh lists
          HomeController homeController = Get.find<HomeController>();
          homeController.fetchPendingTransactions();
          fetchPendingTransactions();

          // Show success message
          Get.snackbar(
            'Success',
            response.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.7),
            colorText: Colors.white,
          );
        } else {
          errorMessage.value = response.message;
          Get.snackbar(
            'Error',
            response.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.7),
            colorText: Colors.white,
          );
        }
      } catch (e) {
        errorMessage.value = 'Failed to create transaction: ${e.toString()}';
        Get.snackbar(
          'Error',
          'Failed to create transaction: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white,
        );
      } finally {
        isCreatingTransaction.value = false;
      }
    }
  }

  // Fetch pending transactions
  Future<void> fetchPendingTransactions({String? date}) async {
    isLoadingPendingTransactions.value = true;
    errorMessage.value = '';

    try {
      final response = await _transactionRepository.getPendingTransactions(date: date);

      if (response.success && response.data != null) {
        pendingTransactions.assignAll(response.data!.transactions);
        _updateComputedValues();
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = 'Failed to load pending transactions: ${e.toString()}';
    } finally {
      isLoadingPendingTransactions.value = false;
    }
  }

  // Fetch approved transactions
  Future<void> fetchApprovedTransactions({String? date}) async {
    isLoadingApprovedTransactions.value = true;
    errorMessage.value = '';

    try {
      final response = await _transactionRepository.getApprovedTransactions(date: date);

      if (response.success && response.data != null) {
        approvedTransactions.assignAll(response.data!.transactions);
        _updateComputedValues();
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = 'Failed to load approved transactions: ${e.toString()}';
    } finally {
      isLoadingApprovedTransactions.value = false;
    }
  }

  // Fetch transaction details
  Future<void> fetchTransactionDetails({required String date, required bool isPending}) async {
    isLoadingTransactionDetails.value = true;
    errorMessage.value = '';
    transactionDetails.clear();

    try {
      final response = isPending
          ? await _transactionRepository.getPendingTransactionDetails(date: date)
          : await _transactionRepository.getApprovedTransactionDetails(date: date);
      print(response.data);
      if (response.success && response.data != null) {
        print("Got Response");
        transactionDetails.assignAll(response.data!.transaction);
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = 'Failed to load transaction details: ${e.toString()}';
    } finally {
      isLoadingTransactionDetails.value = false;
    }
  }

  // Note: The following methods would need to be implemented in your repository
  // They're included here but commented out until you implement them in your repository

  // Implement mock approve functionality that shows a success message but doesn't call the backend
  void mockApproveTransaction(int transactionId) {
    Get.snackbar(
      'Success',
      'Transaction approved successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.7),
      colorText: Colors.white,
    );

    // Navigate back after "success"
    Get.back();
  }

  // Implement mock approve all functionality that shows a success message but doesn't call the backend
  void mockApproveAllTransactions(String date) {
    Get.snackbar(
      'Success',
      'All transactions approved successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.7),
      colorText: Colors.white,
    );

    // Navigate back after "success"
    Get.back();
  }

  // Implement mock delete functionality that shows a success message but doesn't call the backend
  void mockDeleteTransaction(int transactionId) {
    Get.snackbar(
      'Success',
      'Transaction deleted successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.7),
      colorText: Colors.white,
    );
  }

  // Validation methods
  String? validateShopId(String? value) {
    return Validators.required(value, 'Shop');
  }

  String? validateDate(String? value) {
    return Validators.date(value);
  }

  String? validateAmount(String? value) {
    return Validators.amount(value);
  }

  String? validateDescription(String? value) {
    return Validators.required(value, 'Description');
  }

  // Navigation methods
  void navigateToCreateTransaction() {
    Get.toNamed(Routes.CREATE_TRANSACTION);
  }

  void navigateToTransactionDetails(String date, bool isPending) async {
    await fetchTransactionDetails(date: date, isPending: isPending);
    Get.toNamed(Routes.TRANSACTION_DETAILS, arguments: {'isPending': isPending});
  }

  void navigateToPendingTransactions() {
    Get.toNamed(Routes.PENDING_TRANSACTIONS);
  }

  void navigateToApprovedTransactions() {
    Get.toNamed(Routes.APPROVED_TRANSACTIONS);
  }

  void navigateToHome() {
    Get.offAllNamed(Routes.HOME);
  }

  // Logout method (reuses the AuthService)
  void logout() {
    _authService.logout();
  }
}