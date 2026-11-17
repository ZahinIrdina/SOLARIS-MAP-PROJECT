import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../theme/app_theme.dart';
import 'profile_avatar.dart';

/// Side menu opened by the hamburger icon.
class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.profile,
    required this.onSelectTab,
    required this.onOpenWashroomHistory,
  });

  final UserProfile profile;
  final ValueChanged<int> onSelectTab;
  final VoidCallback onOpenWashroomHistory;

  @override
  Widget build(BuildContext context) {
    void closeThen(VoidCallback action) {
      Navigator.of(context).pop();
      action();
    }

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.maroon,
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).padding.top + 24,
              20,
              24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileAvatar(size: 72, photoUrl: profile.photoUrl),
                const SizedBox(height: 14),
                Text(
                  profile.fullName.isEmpty ? 'User' : profile.fullName,
                  style: AppFonts.serif(
                    size: 18,
                    weight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.email,
                  style: AppFonts.sans(size: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _item(Icons.home_rounded, 'Home', () => closeThen(() => onSelectTab(1))),
          _item(Icons.description_outlined, 'Examination Slip',
              () => closeThen(() => onSelectTab(0))),
          _item(Icons.history, 'Washroom Break History',
              () => closeThen(onOpenWashroomHistory)),
          _item(Icons.person_outline, 'Profile',
              () => closeThen(() => onSelectTab(2))),
          const Spacer(),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }

  Widget _item(IconData icon, String label, VoidCallback onTap) => ListTile(
        leading: Icon(icon, color: AppColors.maroon),
        title: Text(label, style: AppFonts.serif(size: 15)),
        onTap: onTap,
      );
}
