import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore document: `washroomBreaks/{id}`.
class WashroomBreak {
  const WashroomBreak({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.examId,
    required this.outAt,
    this.inAt,
  });

  final String id;
  final String studentId;
  final String studentName;
  final String examId;
  final DateTime outAt;

  /// Null while the student is still out of the hall.
  final DateTime? inAt;

  factory WashroomBreak.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data();
    return WashroomBreak(
      id: doc.id,
      studentId: (d['studentId'] as String?) ?? '',
      studentName: (d['studentName'] as String?) ?? '',
      examId: (d['examId'] as String?) ?? '',
      outAt: (d['outAt'] as Timestamp?)?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0),
      inAt: (d['inAt'] as Timestamp?)?.toDate(),
    );
  }

  Duration? get duration => inAt?.difference(outAt);
}
