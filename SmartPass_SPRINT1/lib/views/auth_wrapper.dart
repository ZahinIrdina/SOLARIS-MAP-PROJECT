import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_ui/material_ui.dart';

import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import 'invigilator_dashboard.dart';
import 'login_view.dart';
import 'student_dashboard.dart';

/// Decides what to show after sign-in. The role comes ONLY from the user-info
/// tables: found in `students` -> student dashboard, found in `lecturers` ->
/// invigilator dashboard, found in neither -> error and sign out.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges, // Listens to login state
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _Loading();
        }

        // Not logged in -> Login Page
        if (!snapshot.hasData || snapshot.data == null) {
          return const StudentLoginView();
        }

        // Logged in -> look the account up in students / lecturers
        return FutureBuilder<UserProfile?>(
          future: UserService.instance.findByUid(snapshot.data!.uid),
          builder: (context, recordSnapshot) {
            if (recordSnapshot.connectionState == ConnectionState.waiting) {
              return const _Loading();
            }

            final record = recordSnapshot.data;
            if (record == null) {
              return _NotRegistered(onLogout: authService.logout);
            }

            if (record.isStudent) {
              // Streams live from students/{matricNo}, so edits show at once.
              return StreamBuilder<UserProfile?>(
                stream: UserService.instance.watchProfile(
                  record.role,
                  record.idNumber,
                ),
                initialData: record,
                builder: (context, live) =>
                    StudentDashboard(profile: live.data ?? record),
              );
            }
            return const InvigilatorDashboardView();
          },
        );
      },
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}

class _NotRegistered extends StatelessWidget {
  const _NotRegistered({required this.onLogout});

  final Future<void> Function() onLogout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'This account is not registered as a student or lecturer.\n'
                'Please contact the exam office.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: onLogout, child: const Text('Log out')),
            ],
          ),
        ),
      ),
    );
  }
}
