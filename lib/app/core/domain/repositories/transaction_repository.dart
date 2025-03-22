import 'package:get/get.dart';
import '../../data/models/api_response_model.dart';
import '../../data/models/transaction_model.dart';
import '../../data/providers/api_provider.dart';
import '../../values/api_constants.dart';


class TransactionRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  // Create a new transaction
  Future<ApiResponse<bool>> createTransaction({
    required int shopId,
    required String date,
    required double amount,
    required String description,
  }) async {
    try {
      // Create data
      Map<String, dynamic> data = {
        'shop_id': shopId.toString(),
        'date': date,
        'amount': amount.toString(),
        'description': description,
      };

      // Send transaction creation request
      final response = await _apiProvider.post(
        ApiConstants.transaction,
        data: data,
      );

      if (response.success && response.data != null) {
        final createResponse = CreateTransactionResponse.fromJson(response.data);

        // Check if type is success
        if (createResponse.type == 'success') {
          return ApiResponse.success(
            message: createResponse.text,
            data: true,
          );
        } else {
          return ApiResponse.error(
            message: createResponse.text,
          );
        }
      }

      return ApiResponse.error(
        message: response.message,
        errors: response.errors,
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'Transaction creation failed: ${e.toString()}',
      );
    }
  }

  // Get pending transaction list
  Future<ApiResponse<TransactionListResponse>> getPendingTransactions({
    String? date,
  }) async {
    try {
      // Create data
      Map<String, dynamic> data = {};

      if (date != null && date.isNotEmpty) {
        data['date'] = date;
      }

      // Send pending transactions request
      final response = await _apiProvider.post(
        ApiConstants.transactionPendingList,
        data: data,
      );

      if (response.success && response.data != null) {
        final transactionList = TransactionListResponse.fromJson(response.data);

        return ApiResponse.success(
          message: transactionList.text,
          data: transactionList,
        );
      }

      return ApiResponse.error(
        message: response.message,
        errors: response.errors,
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'Failed to fetch pending transactions: ${e.toString()}',
      );
    }
  }

  // Get pending transaction details
  Future<ApiResponse<TransactionDetailsResponse>> getPendingTransactionDetails({
    required String date,
  }) async {
    try {
      // Create data
      Map<String, dynamic> data = {
        'date': date,
      };

      // Send pending transaction details request
      final response = await _apiProvider.post(
        ApiConstants.transactionPendingDetails,
        data: data,
      );

      if (response.success && response.data != null) {
        final transactionDetails = TransactionDetailsResponse.fromJson(response.data);

        return ApiResponse.success(
          message: transactionDetails.text,
          data: transactionDetails,
        );
      }

      return ApiResponse.error(
        message: response.message,
        errors: response.errors,
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'Failed to fetch transaction details: ${e.toString()}',
      );
    }
  }

  // Get approved transaction list
  Future<ApiResponse<TransactionListResponse>> getApprovedTransactions({
    String? date,
  }) async {
    try {
      // Create data
      Map<String, dynamic> data = {};

      if (date != null && date.isNotEmpty) {
        data['date'] = date;
      }

      // Send approved transactions request
      final response = await _apiProvider.post(
        ApiConstants.transactionApproveList,
        data: data,
      );

      if (response.success && response.data != null) {
        final transactionList = TransactionListResponse.fromJson(response.data);

        return ApiResponse.success(
          message: transactionList.text,
          data: transactionList,
        );
      }

      return ApiResponse.error(
        message: response.message,
        errors: response.errors,
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'Failed to fetch approved transactions: ${e.toString()}',
      );
    }
  }

  // Get approved transaction details
  Future<ApiResponse<TransactionDetailsResponse>> getApprovedTransactionDetails({
    required String date,
  }) async {
    try {
      // Create data
      Map<String, dynamic> data = {
        'date': date,
      };

      // Send approved transaction details request
      final response = await _apiProvider.post(
        ApiConstants.transactionApproveDetails,
        data: data,
      );



      if (response.success && response.data != null) {
        print("Respnse 1: ${response.success}");
        final transactionDetails = TransactionDetailsResponse.fromJson(response.data);
        print("Transacton details: $transactionDetails");
        return ApiResponse.success(
          message: transactionDetails.text,
          data: transactionDetails,
        );
      }

      return ApiResponse.error(
        message: response.message,
        errors: response.errors,
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'Failed to fetch transaction details: ${e.toString()}',
      );
    }
  }
}