import 'department.dart';

class User {
  final int id;
  final String username;
  final String email;
  final String fullname;
  final String address;
  final String nationalID;
  final String gender;
  final String telNumber;
  final DateTime hireDate;
  final bool isDisabled;
  final List<String> roles;
  final Department? department;
  final String position;
  final String? profileImage;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.fullname,
    required this.address,
    required this.nationalID,
    required this.gender,
    required this.telNumber,
    required this.hireDate,
    required this.isDisabled,
    required this.roles,
    this.department,
    required this.position,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'] ?? json['username'],
      fullname: json['fullname'],
      address: json['address'] ?? '',
      nationalID: json['nationalID'] ?? '',
      gender: json['gender'] ?? '',
      telNumber: json['telNumber'] ?? '',
      hireDate: DateTime.parse(json['hireDate'] ?? DateTime.now().toIso8601String()),
      isDisabled: json['isDisabled'] ?? false,
      roles: (json['roles'] as List?)?.map((r) => r['name'].toString()).toList() ?? [],
      department: json['department'] != null ? Department.fromJson(json['department']) : null,
      position: json['position'] ?? '',
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'fullname': fullname,
      'address': address,
      'nationalID': nationalID,
      'gender': gender,
      'telNumber': telNumber,
      'hireDate': hireDate.toIso8601String(),
      'isDisabled': isDisabled,
      'position': position,
      'profileImage': profileImage,
    };
  }
}