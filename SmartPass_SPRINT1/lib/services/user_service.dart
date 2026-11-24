import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_profile.dart';

/// Reads and writes the user-info tables in Firestore:
///   students/{matricNo}   -> student
///   lecturers/{staffId}   -> invigilator
///
/// A person's role is decided ONLY by which table their ID is found in.
/// Documents are created by the exam office with the email filled in and the
/// `uid` left empty; the app fills `uid` when that person registers.
class UserService {
  UserService._();
  static final UserService instance = UserService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static String collectionFor(UserRole role) =>
      role == UserRole.student ? 'students' : 'lecturers';

  DocumentReference<Map<String, dynamic>> _doc(UserRole role, String id) =>
      _db.collection(collectionFor(role)).doc(id);

  UserProfile _toProfile(UserRole role, String id, Map<String, dynamic> data) {
    final uid = (data['uid'] as String?) ?? '';
    return UserProfile.fromMap(uid, {
      ...data,
      'role': role.name,
      'idNumber': id,
    });
  }

  /// Finds [id] in `students`, then in `lecturers`. Null if it is in neither.
  Future<UserProfile?> findById(String id) async {
    for (final role in UserRole.values) {
      final snap = await _doc(role, id).get();
      final data = snap.data();
      if (data != null) return _toProfile(role, id, data);
    }
    return null;
  }

  /// Finds the record that belongs to a signed-in account (by its uid).
  Future<UserProfile?> findByUid(String uid) async {
    for (final role in UserRole.values) {
      final q = await _db
          .collection(collectionFor(role))
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();
      if (q.docs.isNotEmpty) {
        final d = q.docs.first;
        return _toProfile(role, d.id, d.data());
      }
    }
    return null;
  }

  /// Links a registered account to its record. Only works while `uid` is empty.
  Future<void> claim(UserProfile record, String uid) {
    return _doc(record.role, record.idNumber).update({'uid': uid});
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

  /// Saves the three fields the Edit Profile screen exposes, straight into
  /// the user's own row in students / lecturers.
  Future<void> updateProfile(
    UserProfile profile, {
    required String fullName,
    required String phone,
    required String faculty,
  }) {
    return _doc(profile.role, profile.idNumber).update({
      'fullName': fullName,
      'phone': phone,
      'faculty': faculty,
    });
  }
}
