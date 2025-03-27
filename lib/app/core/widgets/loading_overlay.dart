import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/loading_controller.dart';

class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final LoadingController controller;

  const LoadingOverlay({
    Key? key,
    required this.child,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center, // Use non-directional alignment
      children: [
        child,
        Obx(() => controller.isLoading.value
            ? Container(
          color: Colors.black54,
          width: double.infinity,
          height: double.infinity,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        )
            : const SizedBox.shrink(),
        ),
      ],
    );
  }
}