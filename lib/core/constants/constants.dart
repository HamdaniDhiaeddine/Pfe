class ApiConstants {
  static const String baseUrl = 'http://localhost:8082/api';
  
  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh-token';
  
  // User endpoints
  static const String currentUser = '/users/profile';
  static const String changePassword = '/users/change-password';
  
}