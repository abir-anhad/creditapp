import 'package:get/get.dart';
import '../../data/models/onboarding_model.dart';
import '../../data/providers/local_storage_provider.dart';

class OnboardingRepository {
  final LocalStorageProvider _localStorageProvider = Get.find<LocalStorageProvider>();

  Future<List<OnboardingModel>> getOnboardingData() async {
    return await _localStorageProvider.getOnboardingData();
  }

  bool isFirstTime() {
    return _localStorageProvider.isFirstTime();
  }

  Future<void> setFirstTimeCompleted() async {
    await _localStorageProvider.setFirstTimeCompleted();
  }
}