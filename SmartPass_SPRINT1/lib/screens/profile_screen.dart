import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_profile.dart';
import '../theme/app_theme.dart';
import '../widgets/info_row.dart';
import '../widgets/profile_avatar.dart';
import 'edit_profile_screen.dart';
import '../viewmodels/auth_viewmodel.dart'; // Import your viewmodel

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 28, bottom: 16),
      child: Column(
        children: [
          ProfileAvatar(size: 180, photoUrl: profile.photoUrl),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              profile.fullName.isEmpty ? 'User' : profile.fullName,
              textAlign: TextAlign.center,
              style: AppFonts.serif(size: 19, weight: FontWeight.w700),
            ),
          ),
          if (profile.idNumber.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              profile.idNumber,
              style: AppFonts.sans(size: 15, color: AppColors.labelGrey),
            ),
          ],
          const SizedBox(height: 20),
          FilledButton(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => EditProfileScreen(profile: profile),
              ),
            ),
            child: const Text('Edit Profile'),
          ),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              children: [
                InfoRow(
                  icon: Icons.account_circle_outlined,
                  label: 'Full Name',
                  value: profile.fullName,
                ),
                InfoRow(
                  icon: Icons.mail_outline,
                  label: 'Email',
                  value: profile.email,
                ),
                InfoRow(
                  icon: Icons.phone_outlined,
                  label: 'Phone Number',
                  value: profile.phone,
                ),
                InfoRow(
                  icon: Icons.school_outlined,
                  label: 'Faculty',
                  value: profile.faculty,
                ),
                
                // --- ADDED LOGOUT BUTTON HERE ---
                const SizedBox(height: 20),
                TextButton.icon(
                  onPressed: () {
                    // Call your ViewModel to log out
                    context.read<AuthViewModel>().logout();
                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                // --------------------------------
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}