import 'package:get/get.dart';
import '../../../core/data/models/shop_model.dart';
import '../../../core/domain/repositories/shop_repository.dart';
import '../../../core/domain/repositories/transaction_repository.dart';
import '../../../core/services/auth_service.dart';
import '../../../routes/app_pages.dart';


class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final TransactionRepository _transactionRepository = Get.find<TransactionRepository>();
  final ShopRepository _shopRepository = Get.find<ShopRepository>();

  final RxString username = ''.obs;
  final RxString userImageUrl = ''.obs;

  // Dashboard data
  final RxDouble totalPendingAmount = 0.0.obs;
  final RxInt activeShops = 0.obs;
  final RxString payoffDate = "".obs;

  // Shops list
  final RxList<ShopModel> shops = <ShopModel>[].obs;

  // Loading states
  final RxBool isLoadingShops = false.obs;
  final RxBool isLoadingTransactions = false.obs;

  // Error state
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    fetchPendingTransactions();
    fetchShops();
  }

  void loadUserData() {
    final user = _authService.currentUser.value;
    if (user != null) {
      username.value = user.name ?? 'User';
      userImageUrl.value = user.image ?? '';

      // Set a default payoff date (for demo purposes)
      payoffDate.value = "05 May, 2024";
    }
  }

  Future<void> fetchPendingTransactions() async {
    isLoadingTransactions.value = true;
    errorMessage.value = '';

    try {
      final response = await _transactionRepository.getPendingTransactions();

      if (response.success && response.data != null) {
        // Calculate total pending amount
        double total = 0.0;
        for (var transaction in response.data!.transactions) {
          total += double.tryParse(transaction.totalAmount) ?? 0.0;
        }
        totalPendingAmount.value = total;
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = 'Failed to load transactions: ${e.toString()}';
    } finally {
      isLoadingTransactions.value = false;
    }
  }

  Future<void> fetchShops() async {
    isLoadingShops.value = true;
    errorMessage.value = '';

    try {
      final response = await _shopRepository.getShops();

      if (response.success && response.data != null) {
        shops.assignAll(response.data as Iterable<ShopModel>);
        activeShops.value = shops.length;
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = 'Failed to load shops: ${e.toString()}';
    } finally {
      isLoadingShops.value = false;
    }
  }

  void navigateToShopDetails(int shopId) {
    // Navigate to shop details screen
    Get.toNamed(Routes.SHOP, arguments: {'shopId': shopId});
  }

  void navigateToTransactions() {
    Get.toNamed(Routes.PENDING_TRANSACTIONS);
  }

  void navigateToCreateTransaction() {
    Get.toNamed(Routes.CREATE_TRANSACTION);
  }

  void logout() {
    _authService.logout();
  }
}