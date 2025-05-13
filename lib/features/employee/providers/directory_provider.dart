import 'package:flutter/foundation.dart';
import '../services/directory_service.dart';
import '../../../data/models/user.dart';

class DirectoryProvider with ChangeNotifier {
  final DirectoryService _service = DirectoryService();
  List<User> _employees = [];
  List<User> _filteredEmployees = [];
  bool _loading = false;
  String _selectedDepartment = 'All';

  List<User> get employees => _filteredEmployees.isEmpty 
      ? _employees 
      : _filteredEmployees;
  bool get loading => _loading;
  String get selectedDepartment => _selectedDepartment;

  Future<void> loadEmployees() async {
    _loading = true;
    notifyListeners();

    try {
      _employees = await _service.getAllEmployees();
      _filterEmployees();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void setDepartmentFilter(String department) {
    _selectedDepartment = department;
    _filterEmployees();
    notifyListeners();
  }

  Future<void> searchEmployees(String query) async {
    if (query.isEmpty) {
      _filteredEmployees = [];
      notifyListeners();
      return;
    }

    _loading = true;
    notifyListeners();

    try {
      _filteredEmployees = await _service.searchEmployees(query);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void _filterEmployees() {
    if (_selectedDepartment == 'All') {
      _filteredEmployees = [];
    } else {
      _filteredEmployees = _employees
          .where((e) => e.department == _selectedDepartment)
          .toList();
    }
  }
}