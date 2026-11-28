import 'package:material_ui/material_ui.dart';

import '../models/exam.dart';
import '../models/user_profile.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'profile_avatar.dart';

/// Dark-grey card: avatar, "Good Morning, `name`" and today's exam venue.
class GreetingCard extends StatelessWidget {
  const GreetingCard({
    super.key,
    required this.profile,
    required this.exam,
    this.loading = false,
  });

  final UserProfile profile;
  final Exam? exam;
  final bool loading;

  String _subtitle() {
    final e = exam;
    if (e == null) return loading ? '' : 'No exam assigned yet.';

    final student = profile.isStudent;
    final lead = e.isToday
        ? (student ? "Today's exam is at" : 'Today you invigilate at')
        : (student ? 'Your next exam is at' : 'Your next session is at');

    final venue = [
      e.hall,
      if (student) profile.seat,
    ].where((s) => s.trim().isNotEmpty).join(', ');

    if (venue.isEmpty) return '$lead ${e.location}'.trim();
    if (e.location.isEmpty) return '$lead $venue';
    return '$lead $venue,\n${e.location}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          ProfileAvatar(size: 76, photoUrl: profile.photoUrl),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${greetingFor(DateTime.now())}, ${profile.firstName}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppFonts.serif(
                    size: 19,
                    weight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _subtitle(),
                  style: AppFonts.sans(
                    size: 12,
                    weight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
