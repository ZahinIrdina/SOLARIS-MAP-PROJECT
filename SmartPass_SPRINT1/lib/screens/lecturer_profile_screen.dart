import 'package:material_ui/material_ui.dart';

import '../models/user_profile.dart';
import '../services/user_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/info_row.dart';
import '../widgets/profile_avatar.dart';
import 'edit_profile_screen.dart';

/// Lecturer / invigilator profile. Same look as the student ProfileScreen.
/// Data comes live from `lecturers/{staffId}`, so edits show straight away.
class LecturerProfileScreen extends StatelessWidget {
  const LecturerProfileScreen({
    super.key,
    required this.profile,
    required this.roleLabel,
  });

  final UserProfile profile;

  /// "Hall Invigilator" / "Observer" from the dashboard switch.
  final String roleLabel;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserProfile?>(
      stream: UserService.instance.watchProfile(profile.role, profile.idNumber),
      initialData: profile,
      builder: (context, snap) {
        final p = snap.data ?? profile;
        return Scaffold(
          appBar: AppHeader(title: p.profileTitle, showBack: true),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 28, bottom: 16),
            child: Column(
              children: [
                ProfileAvatar(size: 180, photoUrl: p.photoUrl),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    p.fullName.isEmpty ? 'User' : p.fullName,
                    textAlign: TextAlign.center,
                    style: AppFonts.serif(size: 19, weight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  [p.idNumber, roleLabel].where((s) => s.isNotEmpty).join('  ·  '),
                  style: AppFonts.sans(size: 15, color: AppColors.labelGrey),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => EditProfileScreen(profile: p),
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
                        icon: Icons.badge_outlined,
                        label: 'Staff ID',
                        value: p.idNumber,
                      ),
                      InfoRow(
                        icon: Icons.account_circle_outlined,
                        label: 'Full Name',
                        value: p.fullName,
                      ),
                      InfoRow(
                        icon: Icons.mail_outline,
                        label: 'Email',
                        value: p.email,
                      ),
                      InfoRow(
                        icon: Icons.phone_outlined,
                        label: 'Phone Number',
                        value: p.phone,
                      ),
                      InfoRow(
                        icon: Icons.school_outlined,
                        label: 'Faculty',
                        value: p.faculty,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
