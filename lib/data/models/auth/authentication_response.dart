class AuthenticationResponse {
  final String token;
  final Map<String, dynamic> user;

  AuthenticationResponse({
    required this.token,
    required this.user,
  });

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) {
    return AuthenticationResponse(
      token: json['token'] as String,
      user: json['user'] as Map<String, dynamic>,
    );
  }
}