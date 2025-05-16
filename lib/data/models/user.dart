import 'package:flutter/material.dart';

class User {
  final int id;
  final String username;
  final String fullName;
  final String email;
  final List<String> roles;
  final String? department;
  final DateTime createdAt;
  final bool enabled;

  User({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.roles,
    this.department,
    required this.createdAt,
    required this.enabled,
  });

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
    );
  }
}