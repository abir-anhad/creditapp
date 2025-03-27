import 'package:credit_app/app/core/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app/core/controllers/loading_controller.dart';
import 'app/core/data/providers/api_provider.dart';
import 'app/core/data/providers/local_storage_provider.dart';
import 'app/core/domain/repositories/auth_repository.dart';
import 'app/core/domain/repositories/onboarding_repository.dart';
import 'app/core/domain/repositories/profile_repository.dart';
import 'app/core/domain/repositories/shop_repository.dart';
import 'app/core/domain/repositories/transaction_repository.dart';
import 'app/core/domain/repositories/users_list_repository.dart';
import 'app/core/theme/app_theme.dart';
import 'app/core/services/auth_service.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  Get.put(LoadingController(), permanent: true);

  // Initialize services
  await initServices();

  runApp(MyApp());
}

Future<void> initServices() async {
  // Initialize providers
  await Get.putAsync(() => LocalStorageProvider().init());
  await Get.putAsync(() => ApiProvider().init());

  // Initialize repositories
  Get.put(OnboardingRepository());
  Get.put(AuthRepository());
  Get.put(ProfileRepository());
  Get.put(TransactionRepository());
  Get.put(ShopRepository());
  Get.put(UserRepository());

  // Initialize services
  await Get.putAsync(() => AuthService().init());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final loadingController = Get.find<LoadingController>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Cool Credit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      defaultTransition: Transition.fade,

    );
  }
}