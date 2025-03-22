import 'package:get/get.dart';

import '../../data/models/api_response_model.dart';
import '../../data/models/shop_model.dart';
import '../../data/providers/api_provider.dart';
import '../../values/api_constants.dart';


class ShopRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  // Get list of shops
  Future<ApiResponse<List<ShopModel>>> getShops() async {
    try {
      // Send shop list request
      final response = await _apiProvider.post(
        ApiConstants.shop,
      );

      if (response.success && response.data != null) {
        final shopResponse = ShopListResponse.fromJson(response.data);

        // Check if type is success
        if (shopResponse.type == 'success') {
          return ApiResponse.success(
            message: shopResponse.text,
            data: shopResponse.shops,
          );
        } else {
          return ApiResponse.error(
            message: shopResponse.text,
          );
        }
      }

      return ApiResponse.error(
        message: response.message,
        errors: response.errors,
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'Failed to fetch shops: ${e.toString()}',
      );
    }
  }
}