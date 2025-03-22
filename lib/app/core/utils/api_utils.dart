import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiUtils {
  // Log API request
  static void logRequest(String method, String url, Map<String, String> headers, dynamic body) {
    if (kDebugMode) {
      print('🚀 REQUEST[$method] => $url');
      print('Headers: $headers');

      if (body != null) {
        if (body is String) {
          try {
            final jsonData = json.decode(body);
            print('Body: ${json.encode(jsonData)}');
          } catch (e) {
            print('Body: $body');
          }
        } else {
          print('Body: $body');
        }
      }
    }
  }

  // Log API response
  static void logResponse(http.Response response) {
    if (kDebugMode) {
      print('📩 RESPONSE[${response.statusCode}] => ${response.request?.url}');

      try {
        final jsonData = json.decode(response.body);
        print('Response: ${json.encode(jsonData)}');
      } catch (e) {
        print('Response: ${response.body}');
      }
    }
  }

  // Log API error
  static void logError(dynamic error, StackTrace? stackTrace) {
    if (kDebugMode) {
      print('🛑 ERROR: $error');
      if (stackTrace != null) {
        print('StackTrace: $stackTrace');
      }
    }
  }

  // Parse JSON safely
  static dynamic parseJson(String body) {
    try {
      return json.decode(body);
    } catch (e) {
      logError('Failed to parse JSON: $e', null);
      return null;
    }
  }

  // Format JSON for logging
  static String formatJson(dynamic json) {
    const encoder = JsonEncoder.withIndent('  ');
    try {
      return encoder.convert(json);
    } catch (e) {
      return json.toString();
    }
  }

  // Check if response is successful
  static bool isSuccessful(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  // Extract error messages from response
  static List<String>? extractErrors(Map<String, dynamic> responseData) {
    try {
      if (responseData['errors'] != null) {
        if (responseData['errors'] is Map) {
          final Map<String, dynamic> errors = responseData['errors'];
          return errors.values
              .map((e) => e is List ? e.join(', ') : e.toString())
              .toList();
        } else if (responseData['errors'] is List) {
          return List<String>.from(responseData['errors']);
        }
      }
      return null;
    } catch (e) {
      logError('Failed to extract errors: $e', null);
      return null;
    }
  }
}