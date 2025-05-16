import 'package:flutter/foundation.dart';

class User {
  final int id;
  final String username;
  final String fullName;
  final String email;
  final List<String> roles;
  final String? department;
  final DateTime? createdAt;
  final bool enabled;
  final String? phoneNumber;
  final String? address;
  final String? position;
  final String? gender;
  final DateTime? birthDate;
  final String? nationalId;
  final DateTime? hireDate;
  final String? profileImagePath;
  final bool active;
  final int leaveBalance;
  final bool accountVerified;
  final bool isDisabled;
  final String? telNumber;
  final bool loginDisabled;
  final bool accountNonLocked;
  final bool credentialsNonExpired;
  final bool accountNonExpired;
  final double? salary;
  final List<Map<String, dynamic>> authorities;
  final Map<String, dynamic>? additionalInfo;

  User({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.roles,
    this.department,
    this.createdAt,
    required this.enabled,
    this.phoneNumber,
    this.address,
    this.position,
    this.gender,
    this.birthDate,
    this.nationalId,
    this.hireDate,
    this.profileImagePath,
    required this.active,
    required this.leaveBalance,
    required this.accountVerified,
    required this.isDisabled,
    this.telNumber,
    required this.loginDisabled,
    required this.accountNonLocked,
    required this.credentialsNonExpired,
    required this.accountNonExpired,
    this.salary,
    required this.authorities,
    this.additionalInfo,
  });

  // Add getters for convenience
  bool get isAdmin => roles.contains('ROLE_ADMIN');
  bool get isSuperAdmin => roles.contains('ROLE_SUPERADMIN');
  bool get isEmployee => roles.contains('ROLE_EMPLOYEE');
  bool get isManager => roles.contains('ROLE_MANAGER');
  bool get isHR => roles.contains('ROLE_RH');

  factory User.fromJson(Map<String, dynamic> json) {
    debugPrint('Parsing user from JSON: $json');
    
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      fullName: json['fullname'] as String, 
      email: json['email'] as String,
      roles: (json['roles'] as List<dynamic>)
          .map((role) => (role['name'] as String))
          .toList(),
      department: json['department'] as String?,
      createdAt: null, 
      enabled: json['enabled'] as bool? ?? true,
      phoneNumber: json['telNumber'] as String?, 
      address: json['address'] as String?,
      position: json['position'] as String?,
      gender: json['gender'] as String?,
      birthDate: json['dateOfBirth'] != null 
          ? DateTime.parse(json['dateOfBirth'] as String) 
          : null,
      nationalId: json['nationalID'] as String?, 
      hireDate: json['hireDate'] != null 
          ? DateTime.parse(json['hireDate'] as String) 
          : null,
      profileImagePath: json['profileImagePath'] as String?,
      active: json['active'] as bool? ?? true,
      leaveBalance: json['leave_balance'] as int? ?? 0,
      accountVerified: json['accountVerified'] as bool? ?? false,
      isDisabled: json['isDisabled'] as bool? ?? false,
      telNumber: json['telNumber'] as String?,
      loginDisabled: json['loginDisabled'] as bool? ?? false,
      accountNonLocked: json['accountNonLocked'] as bool? ?? true,
      credentialsNonExpired: json['credentialsNonExpired'] as bool? ?? true,
      accountNonExpired: json['accountNonExpired'] as bool? ?? true,
      salary: json['salary']?.toDouble(),
      authorities: (json['authorities'] as List<dynamic>?)
          ?.map((auth) => auth as Map<String, dynamic>)
          .toList() ?? [],
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'fullname': fullName, 
      'email': email,
      'roles': roles.map((role) => {'name': role}).toList(),
      'department': department,
      'enabled': enabled,
      'telNumber': telNumber, 
      'address': address,
      'position': position,
      'gender': gender,
      'dateOfBirth': birthDate?.toIso8601String(), 
      'nationalID': nationalId, 
      'hireDate': hireDate?.toIso8601String(),
      'profileImagePath': profileImagePath,
      'active': active,
      'leave_balance': leaveBalance,
      'accountVerified': accountVerified,
      'isDisabled': isDisabled,
      'loginDisabled': loginDisabled,
      'accountNonLocked': accountNonLocked,
      'credentialsNonExpired': credentialsNonExpired,
      'accountNonExpired': accountNonExpired,
      'salary': salary,
      'authorities': authorities,
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
    String? profileImagePath,
    bool? active,
    int? leaveBalance,
    bool? accountVerified,
    bool? isDisabled,
    String? telNumber,
    bool? loginDisabled,
    bool? accountNonLocked,
    bool? credentialsNonExpired,
    bool? accountNonExpired,
    double? salary,
    List<Map<String, dynamic>>? authorities,
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
      profileImagePath: profileImagePath ?? this.profileImagePath,
      active: active ?? this.active,
      leaveBalance: leaveBalance ?? this.leaveBalance,
      accountVerified: accountVerified ?? this.accountVerified,
      isDisabled: isDisabled ?? this.isDisabled,
      telNumber: telNumber ?? this.telNumber,
      loginDisabled: loginDisabled ?? this.loginDisabled,
      accountNonLocked: accountNonLocked ?? this.accountNonLocked,
      credentialsNonExpired: credentialsNonExpired ?? this.credentialsNonExpired,
      accountNonExpired: accountNonExpired ?? this.accountNonExpired,
      salary: salary ?? this.salary,
      authorities: authorities ?? this.authorities,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username, fullName: $fullName, roles: $roles)';
  }
}