import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore document: `exams/{examId}`.
class Exam {
  const Exam({
    required this.id,
    required this.courseCode,
    required this.courseName,
    required this.hall,
    required this.location,
    this.startsAt,
    this.endsAt,
  });

  final String id;
  final String courseCode;
  final String courseName;

  /// Hall, e.g. "DK8".
  final String hall;

  /// Building line, e.g. "Faculty of Computing, UTM".
  final String location;
  final DateTime? startsAt;
  final DateTime? endsAt;

  factory Exam.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? const <String, dynamic>{};
    return Exam(
      id: doc.id,
      courseCode: (d['courseCode'] as String?) ?? '',
      courseName: (d['courseName'] as String?) ?? '',
      hall: (d['hall'] as String?) ?? '',
      location: (d['location'] as String?) ?? '',
      startsAt: (d['startsAt'] as Timestamp?)?.toDate(),
      endsAt: (d['endsAt'] as Timestamp?)?.toDate(),
    );
  }

  bool get isToday {
    final s = startsAt;
    if (s == null) return false;
    final now = DateTime.now();
    return s.year == now.year && s.month == now.month && s.day == now.day;
  }
}

