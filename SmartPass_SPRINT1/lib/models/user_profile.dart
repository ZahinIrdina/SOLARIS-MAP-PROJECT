import 'user_model.dart';

enum UserRole {
  student,
  invigilator;

  static UserRole parse(String? value) =>
      value == 'invigilator' ? UserRole.invigilator : UserRole.student;
}

/// Firestore document: `users/{uid}`.
class UserProfile {
  const UserProfile({
    required this.uid,
    required this.role,
    required this.fullName,
    required this.email,
    this.phone = '',
    this.faculty = '',
    this.idNumber = '',
    this.seat = '',
    this.examId = '',
    this.photoUrl = '',
  });

  /// Placeholder used while there is no login. Replace with the signed-in
  /// user's profile once backend/auth integration is done.
  static const UserProfile demo = UserProfile(
    uid: 'demo',
    role: UserRole.student,
    fullName: 'Demo Student',
    email: 'demo@graduate.utm.my',
    faculty: 'Faculty of Computing',
    idNumber: 'A23CS0000',
    seat: 'N24',
  );

  static const UserProfile demoInvigilator = UserProfile(
    uid: 'demo-invigilator',
    role: UserRole.invigilator,
    fullName: 'Demo Invigilator',
    email: 'demo@utm.my',
    faculty: 'Faculty of Computing',
    idNumber: 'S12345',
  );

  final String uid;
  final UserRole role;
  final String fullName;
  final String email;
  final String phone;
  final String faculty;

  /// Matric number (student) or staff number (invigilator).
  final String idNumber;

  /// Seat label such as "N24". Assigned by the exam office, not editable here.
  final String seat;

  /// `exams/{examId}` this user sits / invigilates. Assigned by the exam office.
  final String examId;
  final String photoUrl;

  factory UserProfile.fromMap(String uid, Map<String, dynamic> d) => UserProfile(
        uid: uid,
        role: UserRole.parse(d['role'] as String?),
        fullName: (d['fullName'] as String?) ?? '',
        email: (d['email'] as String?) ?? '',
        phone: (d['phone'] as String?) ?? '',
        faculty: (d['faculty'] as String?) ?? '',
        idNumber: (d['idNumber'] as String?) ?? '',
        seat: (d['seat'] as String?) ?? '',
        examId: (d['examId'] as String?) ?? '',
        photoUrl: (d['photoUrl'] as String?) ?? '',
      );

  bool get isStudent => role == UserRole.student;

  String get firstName {
    final name = fullName.trim();
    return name.isEmpty ? 'User' : name.split(RegExp(r'\s+')).first;
  }

  String get profileTitle =>
      isStudent ? "Student's Profile" : "Invigilator's Profile";

  factory UserProfile.fromAuthModel(UserModel authUser) {
  return UserProfile(
    uid: authUser.uid,
    role: authUser.role == 'invigilator' ? UserRole.invigilator : UserRole.student,
    fullName: authUser.fullName, 
    email: authUser.email,
    idNumber: authUser.matricNo, 
    // These will be empty for now until they are assigned by the exam office
    phone: '', 
    faculty: '', 
    seat: '', 
    examId: '', 
  );
}
}
