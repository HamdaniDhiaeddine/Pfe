import 'user.dart';

class Department {
  final int id;
  final String name;
  final String description;
  final User? manager;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<User>? employees;
  final int employeeCount;

  Department({
    required this.id,
    required this.name,
    required this.description,
    this.manager,
    required this.createdAt,
    this.updatedAt,
    this.employees,
    required this.employeeCount,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      manager: json['manager'] != null ? User.fromJson(json['manager']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      employees: (json['employees'] as List?)?.map((e) => User.fromJson(e)).toList(),
      employeeCount: json['employeeCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'managerId': manager?.id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}