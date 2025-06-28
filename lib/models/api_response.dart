class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({required this.success, required this.message, this.data});

  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Object? json)? fromJsonT,
      ) =>
      ApiResponse(
        success: json['success'] as bool,
        message: json['message'] as String,
        data: json['data'] != null ? fromJsonT!(json['data']) : null,
      );
}

class Mode {
  final bool isActive;
  final String description;

  Mode({
    required this.isActive,
    required this.description,
  });

  factory Mode.fromJson(Map<String, dynamic> json) {
    return Mode(
      isActive: json['isActive'] ?? false,
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isActive': isActive,
      'description': description,
    };
  }
}
