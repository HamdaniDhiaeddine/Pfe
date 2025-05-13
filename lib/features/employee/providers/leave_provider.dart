import 'package:flutter/foundation.dart';
import '../services/leave_service.dart';
import '../../../data/models/leave_request.dart';

class LeaveProvider with ChangeNotifier {
  final LeaveService _leaveService = LeaveService();
  List<LeaveRequest> _leaveRequests = [];
  bool _loading = false;

  List<LeaveRequest> get leaveRequests => _leaveRequests;
  bool get loading => _loading;

  Future<void> loadLeaveRequests() async {
    _loading = true;
    notifyListeners();

    try {
      _leaveRequests = await _leaveService.getLeaveRequests();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> createLeaveRequest({
    required DateTime startDate,
    required DateTime endDate,
    required String type,
    required String reason,
  }) async {
    try {
      await _leaveService.createLeaveRequest(
        startDate: startDate,
        endDate: endDate,
        type: type,
        reason: reason,
      );
      await loadLeaveRequests();
    } catch (e) {
      rethrow;
    }
  }
}