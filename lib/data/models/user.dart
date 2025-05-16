import 'package:flutter/foundation.dart';

class User {
  final int id;
  final String username;
  final String fullName;
  final String email;
  final List<String> roles;
  final String? department;
  final DateTime createdAt;
  final bool enabled;
  final String? phoneNumber;
  final String? address;
  final String? position;
  final String? gender;
  final DateTime? birthDate;
  final String? nationalId;
  final DateTime? hireDate;
  final String? imageUrl;
  final Map<String, dynamic>? additionalInfo;

  User({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.roles,
    this.department,
    required this.createdAt,
    required this.enabled,
    this.phoneNumber,
    this.address,
    this.position,
    this.gender,
    this.birthDate,
    this.nationalId,
    this.hireDate,
    this.imageUrl,
    this.additionalInfo,
  });

  // Add getters for convenience
  bool get isAdmin => roles.contains('ROLE_ADMIN');
  bool get isEmployee => roles.contains('ROLE_EMPLOYEE');
  bool get isManager => roles.contains('ROLE_MANAGER');

  factory User.fromJson(Map<String, dynamic> json) {
    debugPrint('Parsing user from JSON: $json');
    
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      roles: (json['roles'] as List<dynamic>).map((e) => e.toString()).toList(),
      department: json['department'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      enabled: json['enabled'] as bool? ?? true,
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] as String?,
      position: json['position'] as String?,
      gender: json['gender'] as String?,
      birthDate: json['birthDate'] != null ? DateTime.parse(json['birthDate'] as String) : null,
      nationalId: json['nationalId'] as String?,
      hireDate: json['hireDate'] != null ? DateTime.parse(json['hireDate'] as String) : null,
      imageUrl: json['imageUrl'] as String?,
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'fullName': fullName,
      'email': email,
      'roles': roles,
      'department': department,
      'createdAt': createdAt.toIso8601String(),
      'enabled': enabled,
      'phoneNumber': phoneNumber,
      'address': address,
      'position': position,
      'gender': gender,
      'birthDate': birthDate?.toIso8601String(),
      'nationalId': nationalId,
      'hireDate': hireDate?.toIso8601String(),
      'imageUrl': imageUrl,
      'additionalInfo': additionalInfo,
    };
  }

  User copyWith({
    int? id,
    String? username,
    String? fullName,
    String? email,
    List<String>? roles,
    String? department,
    DateTime? createdAt,
    bool? enabled,
    String? phoneNumber,
    String? address,
    String? position,
    String? gender,
    DateTime? birthDate,
    String? nationalId,
    DateTime? hireDate,
    String? imageUrl,
    Map<String, dynamic>? additionalInfo,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      roles: roles ?? this.roles,
      department: department ?? this.department,
      createdAt: createdAt ?? this.createdAt,
      enabled: enabled ?? this.enabled,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      position: position ?? this.position,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      nationalId: nationalId ?? this.nationalId,
      hireDate: hireDate ?? this.hireDate,
      imageUrl: imageUrl ?? this.imageUrl,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }
}