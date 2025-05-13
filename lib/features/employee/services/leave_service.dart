import '../../../core/services/api_service.dart';
import '../../../data/models/leave_request.dart';

class LeaveService {
  final ApiService _api = ApiService();

  Future<List<LeaveRequest>> getLeaveRequests() async {
    try {
      final response = await _api.get('/holidays/user');
      return (response.data as List)
          .map((json) => LeaveRequest.fromJson(json))
          .toList();
    } catch (e) {
      throw 'Failed to fetch leave requests';
    }
  }

  Future<void> createLeaveRequest({
    required DateTime startDate,
    required DateTime endDate,
    required String type,
    required String reason,
  }) async {
    try {
      await _api.post('/holidays', {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'type': type,
        'reason': reason,
      });
    } catch (e) {
      throw 'Failed to create leave request';
    }
  }
}