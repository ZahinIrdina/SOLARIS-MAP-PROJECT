import 'package:material_ui/material_ui.dart';

import '../models/exam.dart';
import '../models/user_profile.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/info_row.dart';

class ExamSlipScreen extends StatelessWidget {
  const ExamSlipScreen({
    super.key,
    required this.profile,
    required this.exam,
    required this.loading,
  });

  final UserProfile profile;
  final Exam? exam;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final e = exam;
    if (e == null) {
      return Center(
        child: loading
            ? const CircularProgressIndicator(color: AppColors.maroon)
            : Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'No exam has been assigned to you yet.',
                  textAlign: TextAlign.center,
                  style: AppFonts.serif(size: 16, color: AppColors.labelGrey),
                ),
              ),
      );
    }

    final start = e.startsAt;
    final end = e.endsAt;
    final student = profile.isStudent;

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.maroon,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                e.courseCode,
                style: AppFonts.sans(
                  size: 16,
                  weight: FontWeight.w700,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                e.courseName,
                style: AppFonts.serif(
                  size: 22,
                  weight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              InfoRow(
                icon: Icons.account_circle_outlined,
                label: student ? 'Student' : 'Invigilator',
                value: profile.fullName,
              ),
              if (student && profile.idNumber.isNotEmpty)
                InfoRow(
                  icon: Icons.badge_outlined,
                  label: 'Matric Number',
                  value: profile.idNumber,
                ),
              if (start != null)
                InfoRow(
                  icon: Icons.event_outlined,
                  label: 'Date',
                  value: formatDate(start),
                ),
              if (start != null)
                InfoRow(
                  icon: Icons.schedule,
                  label: 'Time',
                  value: end == null
                      ? formatTime(start)
                      : '${formatTime(start)} – ${formatTime(end)}',
                ),
              InfoRow(
                icon: Icons.place_outlined,
                label: 'Venue',
                value: [
                  e.hall,
                  e.location,
                ].where((s) => s.isNotEmpty).join(', '),
              ),
              if (student && profile.seat.isNotEmpty)
                InfoRow(
                  icon: Icons.event_seat_outlined,
                  label: 'Seat',
                  value: profile.seat,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
