class ServerResponse {
  final String message;
  final dynamic data;
  final Map<String, dynamic>? errors;

  ServerResponse({
    required this.message,
    required this.data,
    this.errors,
  });

  factory ServerResponse.fromJson(Map<String, dynamic> json) {
    return ServerResponse(
      message: json['message'],
      data: json['data'],
      errors: json['errors'],
    );
  }
}