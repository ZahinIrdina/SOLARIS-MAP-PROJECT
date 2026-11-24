import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_profile.dart';

/// Reads and writes the user-info tables in Firestore:
///   students/{matricNo}   (role: student)
///   lecturers/{staffId}   (role: invigilator)
///
/// Stand-in written for the profile screens. Replace with the shared
/// version from smartpass_updated.zip when it is available.
class UserService {
  UserService._();
  static final UserService instance = UserService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static String collectionFor(UserRole role) =>
      role == UserRole.student ? 'students' : 'lecturers';

  DocumentReference<Map<String, dynamic>> _doc(UserRole role, String id) =>
      _db.collection(collectionFor(role)).doc(id);

  UserProfile _toProfile(
    UserRole role,
    String id,
    Map<String, dynamic> data,
  ) {
    final uid = (data['uid'] as String?) ?? '';
    return UserProfile.fromMap(uid, {
      ...data,
      'role': role.name,
      'idNumber': id,
    });
  }

  /// One-off read. Returns null when the ID is not in the table.
  Future<UserProfile?> getProfile(UserRole role, String id) async {
    final snap = await _doc(role, id).get();
    final data = snap.data();
    return data == null ? null : _toProfile(role, id, data);
  }

  /// Live updates, so the profile shows new data straight after an edit.
  Stream<UserProfile?> watchProfile(UserRole role, String id) {
    return _doc(role, id).snapshots().map((snap) {
      final data = snap.data();
      return data == null ? null : _toProfile(role, id, data);
    });
  }

  /// Saves the three fields the Edit Profile screen exposes.
  /// Uses set(merge) so the first save creates students/{matricNo} (or
  /// lecturers/{staffId}) if it does not exist yet; later saves only change
  /// these fields.
  Future<void> updateProfile(
    UserProfile profile, {
    required String fullName,
    required String phone,
    required String faculty,
  }) {
    return _doc(profile.role, profile.idNumber).set({
      'fullName': fullName,
      'phone': phone,
      'faculty': faculty,
      'email': profile.email.toLowerCase(),
    }, SetOptions(merge: true));
  }
}
