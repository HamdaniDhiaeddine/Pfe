import '../user.dart';

class AuthenticationResponse {
  final String token;
  final User user;

  AuthenticationResponse({
    required this.token,
    required this.user,
  });

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) {
    return AuthenticationResponse(
      token: json['token'],
      user: User.fromJson(json['user']),
    );
  }
}