import 'user.dart';

class Contract {
  final int id;
  final String contractType;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final double salary;
  final int workingHours;
  final String benefits;
  final bool signed;
  final String status;
  final bool archived;
  final User employee;
  final String? document;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Contract({
    required this.id,
    required this.contractType,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.salary,
    required this.workingHours,
    required this.benefits,
    required this.signed,
    required this.status,
    required this.archived,
    required this.employee,
    this.document,
    required this.createdAt,
    this.updatedAt,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      id: json['id'],
      contractType: json['contractType'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      salary: json['salary'].toDouble(),
      workingHours: json['workingHours'],
      benefits: json['benefits'],
      signed: json['signed'],
      status: json['status'],
      archived: json['archived'],
      employee: User.fromJson(json['employee']),
      document: json['document'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contractType': contractType,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'salary': salary,
      'workingHours': workingHours,
      'benefits': benefits,
      'employeeId': employee.id,
    };
  }
}