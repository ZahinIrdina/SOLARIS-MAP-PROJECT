import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';

/// Large rounded maroon card with a white outline icon and a two-line title.
class HomeTile extends StatelessWidget {
  const HomeTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconSize = 84,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(28);
    return Material(
      color: AppColors.maroon,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: SizedBox(
          height: 156,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              children: [
                SizedBox(
                  width: 92,
                  child: Icon(
                    icon,
                    size: iconSize,
                    color: AppColors.onMaroonSoft,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: AppFonts.serif(
                      size: 24,
                      weight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
