import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/exam.dart';
import '../models/washroom_break.dart';

class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Mock streams returning empty data for now until you build the real features
  Stream<Exam?> watchExam(String examId) {
    if (examId.isEmpty) return Stream.value(null);
    return _db.collection('exams').doc(examId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return Exam.fromDoc(doc);
    });
  }

  Stream<List<WashroomBreak>> watchBreaksForStudent(String uid) {
    // Return empty list for now so the UI doesn't crash
    return Stream.value([]);
  }

  Stream<List<WashroomBreak>> watchBreaksForExam(String examId) {
    // Return empty list for now so the UI doesn't crash
    return Stream.value([]);
  }

  Future<void> updateProfile(String uid, {required String fullName, required String phone, required String faculty}) async {
    await _db.collection('users').doc(uid).update({
      'name': fullName,
      'phone': phone,
      'faculty': faculty,
    });
  }
}