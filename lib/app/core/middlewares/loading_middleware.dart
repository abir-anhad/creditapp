import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/loading_controller.dart';

class LoadingMiddleware extends GetMiddleware {
  final loadingController = Get.find<LoadingController>();

  @override
  RouteSettings? redirect(String? route) {
    return null;
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    loadingController.showLoading();
    return page;
  }

  @override
  Widget onPageBuilt(Widget page) {
    loadingController.hideLoading();
    return page;
  }

  @override
  void onPageDispose() {
    loadingController.hideLoading();
  }
}
