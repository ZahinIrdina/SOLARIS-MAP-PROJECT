import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String matricNo;
  final String role; // 'student' or 'invigilator'
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.matricNo,
    required this.role,
    this.createdAt,
  });

  // Convert Firestore Document to UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      matricNo: map['matricNo'] ?? '',
      role: map['role'] ?? 'student', // Default to student if missing
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'matricNo': matricNo,
      'role': role,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}