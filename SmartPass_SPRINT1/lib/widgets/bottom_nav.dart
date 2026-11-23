import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';

/// Three maroon circles (exam slip / home / profile) under a thin divider.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 44),
              child: Divider(height: 1, thickness: 1, color: AppColors.divider),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _NavCircle(
                    icon: Icons.book_outlined,
                    label: 'Examination slip',
                    onTap: () => onTap(0),
                  ),
                  _NavCircle(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    onTap: () => onTap(1),
                  ),
                  _NavCircle(
                    icon: Icons.person,
                    label: 'Profile',
                    onTap: () => onTap(2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavCircle extends StatelessWidget {
  const _NavCircle({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Material(
        color: AppColors.maroon,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 56,
            height: 56,
            child: Icon(icon, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }
}
