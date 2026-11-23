import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';

/// Maroon outline icon + small grey label + larger maroon value
/// (the rows under the profile photo).
class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 36,
            child: Icon(icon, color: AppColors.maroon, size: 34),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppFonts.serif(size: 12.5, color: AppColors.labelGrey),
                ),
                const SizedBox(height: 3),
                Text(
                  value.isEmpty ? '—' : value,
                  style: AppFonts.serif(size: 17, color: AppColors.maroon),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
