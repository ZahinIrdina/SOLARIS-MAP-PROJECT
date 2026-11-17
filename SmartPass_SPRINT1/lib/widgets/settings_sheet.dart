import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../screens/edit_profile_screen.dart';
import '../theme/app_theme.dart';

/// Bottom sheet opened by the cog in the header.
Future<void> showSettingsSheet(BuildContext context, UserProfile profile) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: Colors.white,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit_outlined, color: AppColors.maroon),
            title: Text('Edit Profile', style: AppFonts.serif(size: 16)),
            onTap: () {
              Navigator.pop(sheetContext);
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => EditProfileScreen(profile: profile),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}
