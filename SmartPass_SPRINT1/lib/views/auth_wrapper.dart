import 'package:material_ui/material_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import 'login_view.dart';
import 'student_dashboard.dart';
import 'invigilator_dashboard.dart';

/// Builds the student's [UserProfile] for [StudentDashboard].
/// The ID comes from the sign-up record in `users/{uid}`; after that the
/// profile streams live from `students/{matricNo}` so edits show straight
/// away. If that document does not exist yet, the sign-up data is shown.
class _StudentGate extends StatelessWidget {
  const _StudentGate({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future:
          FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final d = snap.data?.data() ?? const <String, dynamic>{};
        final base = UserProfile(
          uid: user.uid,
          role: UserRole.student,
          fullName: (d['name'] as String?) ?? user.displayName ?? '',
          email: (d['email'] as String?) ?? user.email ?? '',
          phone: (d['phone'] as String?) ?? '',
          idNumber: (d['universityId'] as String?) ?? '',
        );
        if (base.idNumber.isEmpty) return StudentDashboard(profile: base);

        return StreamBuilder<UserProfile?>(
          stream: UserService.instance.watchProfile(
            UserRole.student,
            base.idNumber,
          ),
          initialData: base,
          builder: (context, p) =>
              StudentDashboard(profile: p.data ?? base),
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges, // Listens to login state
      builder: (context, snapshot) {
        // 1. Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. Not logged in -> Login Page
        if (!snapshot.hasData || snapshot.data == null) {
          return const StudentLoginView();
        }

        // 3. Logged in -> Check Role
        return FutureBuilder<String?>(
          future: authService.getUserRole(snapshot.data!.uid),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final role = roleSnapshot.data;

            // 4. Route based on Role
            if (role == 'student') {
              return _StudentGate(user: snapshot.data!);
            } else if (role == 'invigilator') {
              return const InvigilatorDashboardView();
            } else {
              return const Scaffold(
                body: Center(child: Text("Error: Role not found.")),
              );
            }
          },
        );
      },
    );
  }
}
