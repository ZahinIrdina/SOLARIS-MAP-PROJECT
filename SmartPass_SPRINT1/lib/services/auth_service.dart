import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  // Updated Register Method
  Future<void> registerUser({
    required String email,
    required String password,
    required String fullName,
    required String universityId,
    required String phone,
    required String role,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = credential.user!;

      try {
        await _firestore.collection('users').doc(user.uid).set({
          'name': fullName,
          'email': email,
          'universityId': universityId,
          'phone': phone,
          'role': role,
          'status': 'approved',
          'createdAt': FieldValue.serverTimestamp(),
        });
      } catch (error) {
        await user.delete(); // Rollback if Firestore fails
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<String?> getUserRole(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.exists ? (doc.data() as Map<String, dynamic>)['role'] : null;
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    } 
  }
}
