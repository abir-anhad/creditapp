import 'package:get/get.dart';
import '../../../core/data/models/shop_model.dart';
import '../../../core/data/models/user_model.dart';
import '../../../core/domain/repositories/shop_repository.dart';
import '../../../core/domain/repositories/transaction_repository.dart';
import '../../../core/domain/repositories/users_list_repository.dart';
import '../../../core/services/auth_service.dart';
import '../../../routes/app_pages.dart';
import '../../transaction/controllers/transaction_controller.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final TransactionRepository _transactionRepository = Get.find<TransactionRepository>();
  final ShopRepository _shopRepository = Get.find<ShopRepository>();
  final UserRepository _userRepository = Get.find<UserRepository>();

  final RxString username = ''.obs;
  final RxString userImageUrl = ''.obs;

  // Dashboard data
  final RxDouble totalPendingAmount = 0.0.obs;
  final RxDouble totalShoppingAmount = 0.0.obs;
  final RxInt activeShops = 0.obs;
  final RxString payoffDate = "".obs;

  // Shops list
  final RxList<ShopModel> shops = <ShopModel>[].obs;

  // Users list
  final RxList<UserModel> users = <UserModel>[].obs;
  final Rx<UserModel?> selectedUser = Rx<UserModel?>(null);

  // Loading states
  final RxBool isLoadingShops = false.obs;
  final RxBool isLoadingTransactions = false.obs;
  final RxBool isLoadingUsers = false.obs;

  // Error state
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    fetchPendingTransactions();
    if (currentUserRole() == 'sender') {
      fetchUsers();
    }
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

  String? currentUserRole() {
    final user = _authService.currentUser.value;
    return user?.role;
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
        double total = 0.0;
        for (var shop in shops) {
          total += double.tryParse(shop.initialAmount!) ?? 0.0;
        }
        totalShoppingAmount.value = total;
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

  Future<void> fetchUsers() async {
    isLoadingUsers.value = true;
    errorMessage.value = '';

    try {
      final response = await _userRepository.getUsers();

      if (response.success && response.data != null) {
        users.assignAll(response.data as Iterable<UserModel>);
        // If users list is not empty, set the first user as selected by default


        if (users.isNotEmpty) {
          print("##########################Got users");
          selectedUser.value = users.first;
          fetchShopsByUser('${selectedUser.value?.id}');
        }
      } else {
        // print("##########################NO users");
        errorMessage.value = response.message;
      }
    } catch (e) {
      print("##########################NO users");
      errorMessage.value = 'Failed to load users: ${e.toString()}';
    } finally {
      isLoadingUsers.value = false;
    }
  }

  Future<void> onUserSelected(UserModel user) async {
    selectedUser.value = user;
    // Fetch shops for the selected user
    await fetchShopsByUser('${user.id}');
  }

  Future<void> fetchShopsByUser(String userId) async {
    isLoadingShops.value = true;
    errorMessage.value = '';

    try {

      final response = await _shopRepository.getShopByUser(userId, currentUserRole() == 'sender'? 'receiver': 'sender');

      if (response.success && response.data != null) {
        shops.assignAll(response.data as Iterable<ShopModel>);
        double total = 0.0;
        for (var shop in shops) {
          total += double.tryParse(shop.initialAmount!) ?? 0.0;
        }
        totalShoppingAmount.value = total;
        activeShops.value = shops.length;
      } else {
        errorMessage.value = response.message;
        shops.clear();
        activeShops.value = 0;
      }
    } catch (e) {
      errorMessage.value = 'Failed to load shops for user: ${e.toString()}';
      shops.clear();
      activeShops.value = 0;
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

  void navigateToCreateTransaction(ShopModel? shop) {
    TransactionController transactionController =
    Get.find<TransactionController>();
    transactionController.errorMessage.value = '';
    print("^^^^^^^^^${shop?.toJson().toString()}");
    transactionController.onShopSelected(shop);
    Get.toNamed(Routes.CREATE_TRANSACTION);
  }

  void navigateToProfile() {
    Get.toNamed(Routes.PROFILE);
  }

  void logout() {
    _authService.logout();
  }
}