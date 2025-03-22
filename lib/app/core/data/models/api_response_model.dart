class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final List<String>? errors;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>)? fromJsonT) {
    final data = json['data'];

    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: data != null && fromJsonT != null ? fromJsonT(data) : null,
      errors: json['errors'] != null
          ? List<String>.from(json['errors'].map((x) => x.toString()))
          : null,
    );
  }

  factory ApiResponse.success({required String message, T? data}) {
    return ApiResponse(
      success: true,
      message: message,
      data: data,
    );
  }

  factory ApiResponse.error({required String message, List<String>? errors}) {
    return ApiResponse(
      success: false,
      message: message,
      errors: errors,
    );
  }
}