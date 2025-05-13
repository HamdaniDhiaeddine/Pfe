import 'user.dart';

class LeaveRequest {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final String type;
  final String status;
  final String reason;
  final User employee;
  final User? approver;
  final String? approverComment;
  final DateTime requestDate;
  final DateTime? responseDate;

  LeaveRequest({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.status,
    required this.reason,
    required this.employee,
    this.approver,
    this.approverComment,
    required this.requestDate,
    this.responseDate,
  });

  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: json['id'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      type: json['type'],
      status: json['status'],
      reason: json['reason'],
      employee: User.fromJson(json['employee']),
      approver: json['approver'] != null ? User.fromJson(json['approver']) : null,
      approverComment: json['approverComment'],
      requestDate: DateTime.parse(json['requestDate']),
      responseDate: json['responseDate'] != null ? DateTime.parse(json['responseDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'type': type,
      'reason': reason,
      'employeeId': employee.id,
    };
  }
}