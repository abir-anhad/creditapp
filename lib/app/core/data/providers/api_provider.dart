import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import '../../utils/api_utils.dart';
import '../../values/api_constants.dart';
import '../models/api_response_model.dart';
import 'local_storage_provider.dart';

class ApiProvider extends GetxService {
  late http.Client _client;
  final LocalStorageProvider _localStorageProvider = Get.find<LocalStorageProvider>();

  Future<ApiProvider> init() async {
    _client = http.Client();
    return this;
  }

  // Helper to create headers with token if available
  Map<String, String> _getHeaders() {
    final headers = Map<String, String>.from(ApiConstants.headers);
    final token = _localStorageProvider.getToken();

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // Generic GET request
  Future<ApiResponse<dynamic>> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$path')
          .replace(queryParameters: queryParameters);

      final headers = _getHeaders();

      // Log request
      ApiUtils.logRequest('GET', uri.toString(), headers, null);

      final response = await _client.get(
        uri,
        headers: headers,
      ).timeout(const Duration(seconds: ApiConstants.connectTimeout));

      // Log response
      ApiUtils.logResponse(response);

      return _processResponse(response);
    } catch (e, stackTrace) {
      ApiUtils.logError(e, stackTrace);
      return _handleError(e);
    }
  }

  // Generic POST request
  Future<ApiResponse<dynamic>> post(String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$path')
          .replace(queryParameters: queryParameters);

      final headers = _getHeaders();
      headers['Content-Type'] = 'application/json';

      final body = data != null ? json.encode(data) : null;

      // Log request
      ApiUtils.logRequest('POST', uri.toString(), headers, body);

      final response = await _client.post(
        uri,
        headers: headers,
        body: body,
      ).timeout(const Duration(seconds: ApiConstants.connectTimeout));

      // Log response
      ApiUtils.logResponse(response);

      return _processResponse(response);
    } catch (e, stackTrace) {
      ApiUtils.logError(e, stackTrace);
      return _handleError(e);
    }
  }

  // POST request with form data (for file uploads)
  Future<ApiResponse<dynamic>> postFormData(String path, {
    required Map<String, dynamic> formData,
    Map<String, File>? files,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$path')
          .replace(queryParameters: queryParameters);

      final request = http.MultipartRequest('POST', uri);

      // Add headers
      final headers = _getHeaders();
      request.headers.addAll(headers);

      // Add form fields
      formData.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      // Add files
      if (files != null) {
        for (var entry in files.entries) {
          if (entry.value.existsSync()) {
            request.files.add(
              await http.MultipartFile.fromPath(
                entry.key,
                entry.value.path,
                filename: basename(entry.value.path),
              ),
            );
          }
        }
      }

      // Log request
      ApiUtils.logRequest('POST (FormData)', uri.toString(), headers, {
        'fields': request.fields,
        'files': files?.map((key, value) => MapEntry(key, value.path)),
      });

      final streamedResponse = await request.send()
          .timeout(const Duration(seconds: ApiConstants.connectTimeout));

      final response = await http.Response.fromStream(streamedResponse);

      // Log response
      ApiUtils.logResponse(response);

      return _processResponse(response);
    } catch (e, stackTrace) {
      ApiUtils.logError(e, stackTrace);
      return _handleError(e);
    }
  }

  // Generic PUT request
  Future<ApiResponse<dynamic>> put(String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$path')
          .replace(queryParameters: queryParameters);

      final headers = _getHeaders();
      headers['Content-Type'] = 'application/json';

      final body = data != null ? json.encode(data) : null;

      // Log request
      ApiUtils.logRequest('PUT', uri.toString(), headers, body);

      final response = await _client.put(
        uri,
        headers: headers,
        body: body,
      ).timeout(const Duration(seconds: ApiConstants.connectTimeout));

      // Log response
      ApiUtils.logResponse(response);

      return _processResponse(response);
    } catch (e, stackTrace) {
      ApiUtils.logError(e, stackTrace);
      return _handleError(e);
    }
  }

  // Generic DELETE request
  Future<ApiResponse<dynamic>> delete(String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$path')
          .replace(queryParameters: queryParameters);

      final headers = _getHeaders();
      headers['Content-Type'] = 'application/json';

      final body = data != null ? json.encode(data) : null;

      // Log request
      ApiUtils.logRequest('DELETE', uri.toString(), headers, body);

      final response = await _client.delete(
        uri,
        headers: headers,
        body: body,
      ).timeout(const Duration(seconds: ApiConstants.connectTimeout));

      // Log response
      ApiUtils.logResponse(response);

      return _processResponse(response);
    } catch (e, stackTrace) {
      ApiUtils.logError(e, stackTrace);
      return _handleError(e);
    }
  }

  // Process HTTP response
  ApiResponse<dynamic> _processResponse(http.Response response) {
    try {
      // Parse response body
      final dynamic responseData = response.body.isNotEmpty
          ? ApiUtils.parseJson(response.body)
          : {'message': 'No data'};

      if (responseData == null) {
        return ApiResponse.error(
          message: 'Failed to parse response',
        );
      }

      // Check if response is successful
      if (ApiUtils.isSuccessful(response.statusCode)) {
        return ApiResponse.success(
          message: responseData['message'] ?? 'Success',
          data: responseData,
        );
      } else {
        // Extract error message
        String errorMessage = responseData['message'] ?? 'Request failed';

        // Extract errors list
        List<String>? errors = ApiUtils.extractErrors(responseData);

        return ApiResponse.error(
          message: errorMessage,
          errors: errors,
        );
      }
    } catch (e, stackTrace) {
      ApiUtils.logError(e, stackTrace);
      return ApiResponse.error(
        message: 'Error processing response: ${e.toString()}',
      );
    }
  }

  // Error handling
  ApiResponse<dynamic> _handleError(dynamic error) {
    String errorMessage;

    if (error is SocketException) {
      errorMessage = 'No internet connection';
    } else if (error is FormatException) {
      errorMessage = 'Invalid response format';
    } else if (error is TimeoutException) {
      errorMessage = 'Request timeout';
    } else {
      errorMessage = 'Unknown error occurred: ${error.toString()}';
    }

    return ApiResponse.error(
      message: errorMessage,
    );
  }
}