import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/exam.dart';
import '../models/washroom_break.dart';

class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─────────────────────────────────────────────
  // EXAMS
  // ─────────────────────────────────────────────
  Stream<Exam?> watchExam(String examId) {
    if (examId.isEmpty) return Stream.value(null);
    return _db.collection('exams').doc(examId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return Exam.fromDoc(doc);
    });
  }

  // ─────────────────────────────────────────────
  // WASHROOM BREAKS
  // ─────────────────────────────────────────────
  
  // Get breaks for a specific student
  Stream<List<WashroomBreak>> watchBreaksForStudent(String uid) {
    return _db
        .collection('washroomBreaks')
        .where('studentId', isEqualTo: uid)
        .orderBy('outAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WashroomBreak.fromDoc(doc))
            .toList());
  }

    // Fetch a student's profile using their matric number
    Future<Map<String, dynamic>?> getStudentByMatric(String matric) async {
    final query = await _db
        .collection('users') // Look in 'users' because your app saves there
        .where('universityId', isEqualTo: matric.toUpperCase()) // Ensure this matches your registration field
        .where('role', isEqualTo: 'student') // Filter out invigilators
        .get();

    if (query.docs.isNotEmpty) {
      return query.docs.first.data();
    }
    return null;
  }

  // Get breaks for an entire exam hall
  Stream<List<WashroomBreak>> watchBreaksForExam(String examId) {
    if (examId.isEmpty) return Stream.value([]);
    return _db
        .collection('washroomBreaks')
        .where('examId', isEqualTo: examId)
        .orderBy('outAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WashroomBreak.fromDoc(doc))
            .toList());
  }

  // Check if the quota is full for a specific gender in a specific exam
  Future<bool> isQuotaFull(String examId, String gender, int maxQuota) async {
    final snapshot = await _db
        .collection('washroomBreaks')
        .where('examId', isEqualTo: examId)
        .where('gender', isEqualTo: gender)
        .where('inAt', isNull: true)
        .get();
    
    return snapshot.docs.length >= maxQuota;
  }

  // Save a new manual check-in log
  Future<void> logManualCheckIn({
    required String examId,
    required String studentId,
    required String studentName,
    required String seatNumber,
    required String gender,
    required bool metalDetectorChecked,
  }) async {
    await _db.collection('washroomBreaks').add({
      'examId': examId,
      'studentId': studentId,
      'studentName': studentName,
      'seatNumber': seatNumber,
      'gender': gender,
      'metalDetectorChecked': metalDetectorChecked,
      'outAt': FieldValue.serverTimestamp(),
      'inAt': null, 
    });
  }

    // Get completed washroom breaks for a specific exam/course
  Stream<List<WashroomBreak>> getCompletedBreaksForCourse(String courseCode) {
    return _db
        .collection('washroomBreaks')
        .where('examId', isEqualTo: courseCode)
        .where('inAt', isNotEqualTo: null) // Only completed breaks
        .orderBy('outAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WashroomBreak.fromDoc(doc))
            .toList());
  }

  // ─────────────────────────────────────────────
  // USERS
  // ─────────────────────────────────────────────
  Future<void> updateProfile(
    String uid, {
    required String fullName,
    required String phone,
    required String faculty,
  }) async {
    await _db.collection('users').doc(uid).update({
      'name': fullName,
      'phone': phone,
      'faculty': faculty,
    });
  }
}