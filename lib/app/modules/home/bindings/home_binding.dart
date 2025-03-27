// Update your HomeBinding class to include the TransactionController

import 'package:get/get.dart';
import '../../transaction/controllers/transaction_controller.dart';
import '../controllers/home_controller.dart';


class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<TransactionController>(() => TransactionController());

  }
}