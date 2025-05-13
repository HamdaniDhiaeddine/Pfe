import 'package:flutter/foundation.dart';
import '../services/department_service.dart';
import '../../../data/models/department.dart';
import '../../../data/models/user.dart';

class DepartmentProvider with ChangeNotifier {
  final DepartmentService _service = DepartmentService();
  List<Department> _departments = [];
  Map<int, List<User>> _departmentEmployees = {};
  bool _loading = false;

  List<Department> get departments => _departments;
  bool get loading => _loading;

  List<User>? getDepartmentEmployees(int departmentId) => 
      _departmentEmployees[departmentId];

  Future<void> loadDepartments() async {
    _loading = true;
    notifyListeners();

    try {
      _departments = await _service.getAllDepartments();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadDepartmentEmployees(int departmentId) async {
    if (_departmentEmployees.containsKey(departmentId)) return;

    _loading = true;
    notifyListeners();

    try {
      final employees = await _service.getDepartmentEmployees(departmentId);
      _departmentEmployees[departmentId] = employees;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> createDepartment({
    required String name,
    required String description,
    required int managerId,
  }) async {
    try {
      final department = await _service.createDepartment(
        name: name,
        description: description,
        managerId: managerId,
      );
      _departments.add(department);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateDepartment(
    int departmentId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _service.updateDepartment(departmentId, data);
      await loadDepartments(); // Reload to get updated data
    } catch (e) {
      rethrow;
    }
  }
}