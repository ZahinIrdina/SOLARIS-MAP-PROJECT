import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import 'login_view.dart';
import 'student_dashboard.dart'; 
import 'invigilator_dashboard.dart'; 

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
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            final role = roleSnapshot.data;

            // 4. Route based on Role
            if (role == 'student') {
              return const StudentDashboard(); 
            } else if (role == 'invigilator') {
              return const InvigilatorDashboardView(); 
            } else {
              return const Scaffold(body: Center(child: Text("Error: Role not found.")));
            }
          },
        );
      },
    );
  }
}
