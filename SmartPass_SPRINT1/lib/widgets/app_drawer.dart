import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../models/user_profile.dart';
import '../theme/app_theme.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'profile_avatar.dart';

class DrawerItem {
  const DrawerItem(this.icon, this.label, this.onTap);
  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

/// Side menu shared by BOTH student and invigilator dashboards, so the look
/// and the Logout button are the same for every user.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.profile, required this.items});

  final UserProfile profile;
  final List<DrawerItem> items;

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
          for (final item in items)
            _tile(item.icon, item.label, () => closeThen(item.onTap)),
          const Spacer(),
          const Divider(height: 1, color: AppColors.divider),
          _tile(
            Icons.logout,
            'Logout',
            () => closeThen(() => context.read<AuthViewModel>().logout()),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }

  Widget _tile(IconData icon, String label, VoidCallback onTap) => ListTile(
        leading: Icon(icon, color: AppColors.maroon),
        title: Text(label, style: AppFonts.serif(size: 15)),
        onTap: onTap,
      );
}
