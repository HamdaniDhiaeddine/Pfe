import '../../../core/services/api_service.dart';
import '../../../data/models/department.dart';
import '../../../data/models/user.dart';

class DepartmentService {
  final ApiService _api = ApiService();

  Future<List<Department>> getAllDepartments() async {
    try {
      final response = await _api.get('/departments');
      return (response.data as List)
          .map((json) => Department.fromJson(json))
          .toList();
    } catch (e) {
      throw 'Failed to fetch departments';
    }
  }

  Future<Department> createDepartment({
    required String name,
    required String description,
    required int managerId,
  }) async {
    try {
      final response = await _api.post('/departments', {
        'name': name,
        'description': description,
        'managerId': managerId,
      });
      return Department.fromJson(response.data);
    } catch (e) {
      throw 'Failed to create department';
    }
  }

  Future<List<User>> getDepartmentEmployees(int departmentId) async {
    try {
      final response = await _api.get('/departments/$departmentId/employees');
      return (response.data as List)
          .map((json) => User.fromJson(json))
          .toList();
    } catch (e) {
      throw 'Failed to fetch department employees';
    }
  }

  Future<void> updateDepartment(
    int departmentId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _api.put('/departments/$departmentId', data);
    } catch (e) {
      throw 'Failed to update department';
    }
  }
}