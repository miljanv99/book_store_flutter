class ServerResponse {
  final String message;
  final dynamic data;

  ServerResponse({required this.message, required this.data});

  factory ServerResponse.fromJson(Map<String, dynamic> json) {
    return ServerResponse(
      message: json['message'],
      data: json['data'],
    );
  }
}