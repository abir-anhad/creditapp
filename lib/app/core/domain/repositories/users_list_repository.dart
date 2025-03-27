import 'package:credit_app/app/core/data/models/user_model.dart';
import 'package:get/get.dart';

import '../../data/models/api_response_model.dart';
import '../../data/providers/api_provider.dart';
import '../../values/api_constants.dart';

class UserRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  // Get list of shops
  Future<ApiResponse<List<UserModel>>> getUsers() async {
    try {

      final formData = {
        'role': 'receiver',
      };
      // Send shop list request
      final response = await _apiProvider.postFormData(
        ApiConstants.usersList,
        formData: formData,
      );

      if (response.success && response.data != null) {
        final userListResponse = UserListResponse.fromJson(response.data);

        // Check if type is success
        if (userListResponse.type == 'success') {
          return ApiResponse.success(
            message: userListResponse.text,
            data: userListResponse.userlist,
          );
        } else {
          return ApiResponse.error(
            message: userListResponse.text,
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
