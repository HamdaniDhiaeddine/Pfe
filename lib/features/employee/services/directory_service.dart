import '../../../core/services/api_service.dart';
import '../../../data/models/user.dart';

class DirectoryService {
  final ApiService _api = ApiService();

  Future<List<User>> getAllEmployees() async {
    try {
      final response = await _api.get('/users');
      return (response.data as List)
          .map((json) => User.fromJson(json))
          .toList();
    } catch (e) {
      throw 'Failed to fetch employees';
    }
  }

  Future<User> getEmployeeById(int id) async {
    try {
      final response = await _api.get('/users/$id');
      return User.fromJson(response.data);
    } catch (e) {
      throw 'Failed to fetch employee details';
    }
  }

  Future<List<User>> searchEmployees(String query) async {
    try {
      final response = await _api.get('/users/search?query=$query');
      return (response.data as List)
          .map((json) => User.fromJson(json))
          .toList();
    } catch (e) {
      throw 'Failed to search employees';
    }
  }

  Future<List<User>> getEmployeesByDepartment(String department) async {
    try {
      final response = await _api.get('/users/department/$department');
      return (response.data as List)
          .map((json) => User.fromJson(json))
          .toList();
    } catch (e) {
      throw 'Failed to fetch department employees';
    }
  }
}