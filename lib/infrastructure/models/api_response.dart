class ApiResponse {
  final bool success;
  final String message;

  ApiResponse({required this.success, required this.message});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['message'] == 'Categoría creada exitosamente.' ||
        json['message'] == 'La categoría ha sido actualizada',
      message: json['message'] as String,
    );
  }
}