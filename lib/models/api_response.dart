// Mirrors a standard .NET ApiResponse<T> / ActionResult pattern
// Makes it trivial to swap mock for real HTTP — just parse the same shape

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int statusCode;
  final List<String> errors;

  const ApiResponse({
    required this.success,
    required this.statusCode,
    this.data,
    this.message,
    this.errors = const [],
  });

  // 200 OK with data
  factory ApiResponse.ok(T data, {String? message}) =>
      ApiResponse(success: true, statusCode: 200, data: data, message: message);

  // 201 Created
  factory ApiResponse.created(T data) => ApiResponse(
    success: true,
    statusCode: 201,
    data: data,
    message: 'Created successfully.',
  );

  // 400 Bad Request
  factory ApiResponse.badRequest(List<String> errors) => ApiResponse(
    success: false,
    statusCode: 400,
    errors: errors,
    message: 'Validation failed.',
  );

  // 404 Not Found
  factory ApiResponse.notFound(String message) =>
      ApiResponse(success: false, statusCode: 404, message: message);

  // 500 Internal Server Error
  factory ApiResponse.serverError() => ApiResponse(
    success: false,
    statusCode: 500,
    message: 'An internal server error occurred.',
  );

  // Parse from real HTTP JSON later:
  // factory ApiResponse.fromJson(Map<String,dynamic> json, T Function(dynamic) fromData) => ...

  bool get isOk => success && statusCode >= 200 && statusCode < 300;

  @override
  String toString() =>
      'ApiResponse($statusCode, success=$success, message=$message)';
}
