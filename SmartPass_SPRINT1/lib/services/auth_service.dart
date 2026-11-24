import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  /// Register against the exam office's records.
  /// The ID must exist in `students` or `lecturers`, the email must match the
  /// record, and the record must not already belong to another account. If any
  /// check fails the new account is deleted again and an error is thrown.
  Future<void> registerUser({
    required String email,
    required String password,
    required String fullName,
    required String universityId,
    required String phone,
    required String role, // role the user picked: 'student' / 'invigilator'
  }) async {
    final id = universityId.trim().toUpperCase();
    final cleanEmail = email.trim().toLowerCase();

    final credential = await _auth.createUserWithEmailAndPassword(
      email: cleanEmail,
      password: password,
    );
    final user = credential.user!;

    try {
      final record = await UserService.instance.findById(id);
      if (record == null) {
        throw Exception(
          'ID $id was not found in the student or lecturer records.',
        );
      }
      if (record.email.trim().toLowerCase() != cleanEmail) {
        throw Exception('This email does not match the email on record for $id.');
      }
      if (record.uid.isNotEmpty) {
        throw Exception('ID $id has already been registered.');
      }
      if (record.role.name != role.toLowerCase()) {
        throw Exception(
          'ID $id is a ${record.isStudent ? 'student' : 'lecturer'} ID, '
          'but you selected the other role.',
        );
      }

      await UserService.instance.claim(record, user.uid);
      if (record.fullName.isNotEmpty) {
        await user.updateDisplayName(record.fullName);
      }
    } catch (_) {
      await user.delete(); // roll back so the email can be used again
      rethrow;
    }
  }

  /// Signs in, then checks the account really belongs to a record in
  /// `students` or `lecturers`. If not, signs out again with an error.
  Future<void> login(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final record = await UserService.instance.findByUid(cred.user!.uid);
    if (record == null) {
      await _auth.signOut();
      throw Exception(
        'This account is not registered as a student or lecturer. '
        'Please contact the exam office.',
      );
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // --- Kept only because the invigilator dashboard's own ProfilePage still
  // --- calls these. They read/write the old `users` collection.
  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    return doc.exists ? doc.data() : null;
  }

  Future<void> updateUserProfile({
    required String fullName,
    required String phone,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User is not logged in.');
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'name': fullName,
      'phone': phone,
    });
    await user.updateDisplayName(fullName);
  }
}
