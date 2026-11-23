import 'package:material_ui/material_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import '../models/user_profile.dart';
import '../screens/app_shell.dart'; // Import their main UI shell

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("Not logged in")));
    }

    return FutureBuilder<DocumentSnapshot>(
      // Fetch the user's data from Firestore using their UID
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: Text("User data not found in Firestore.")),
          );
        }

        // 1. Map Firestore data to your UserModel
        final data = snapshot.data!.data() as Map<String, dynamic>;
        final authUser = UserModel(
          uid: user.uid,
          email: data['email'] ?? '',
          fullName: data['name'] ?? 'Student', // Their code uses 'name'
          matricNo: data['universityId'] ?? '',
          role: data['role'] ?? 'student',
        );

        // 2. Convert it to their UserProfile UI model
        final userProfile = UserProfile.fromAuthModel(authUser);

        // 3. Load their UI Shell
        return AppShell(profile: userProfile);
      },
    );
  }
}
