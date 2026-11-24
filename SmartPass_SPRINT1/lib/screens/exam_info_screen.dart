import 'package:material_ui/material_ui.dart';

import '../models/exam.dart';
import '../models/user_profile.dart';
import '../services/firestore_service.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/app_header.dart';
import '../widgets/info_row.dart';

/// Upcoming exam overview: what, when, which hall, and how soon.
/// Reads `exams/{examId}` live. For now a student has one assigned exam;
/// when several exams are supported they can be listed here.
class ExamInfoScreen extends StatelessWidget {
  const ExamInfoScreen({super.key, required this.profile});

  final UserProfile profile;

  /// "Today", "In 3 days", "In progress" or "Completed".
  static String? statusFor(Exam e, DateTime now) {
    final start = e.startsAt;
    if (start == null) return null;
    final end = e.endsAt;
    if (end != null && now.isAfter(end)) return 'Completed';
    if (!now.isBefore(start)) return 'In progress';
    final days = DateTime(start.year, start.month, start.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    if (days <= 0) return 'Today';
    return days == 1 ? 'Tomorrow' : 'In $days days';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Examination Information', showBack: true),
      body: StreamBuilder<Exam?>(
        stream: FirestoreService.instance.watchExam(profile.examId),
        builder: (context, snap) {
          final e = snap.data;
          if (e == null) {
            final loading = snap.connectionState == ConnectionState.waiting;
            return Center(
              child: loading
                  ? const CircularProgressIndicator(color: AppColors.maroon)
                  : Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        'No upcoming exam yet.\n'
                        'Your exam details will appear here once they are assigned.',
                        textAlign: TextAlign.center,
                        style: AppFonts.serif(
                          size: 16,
                          color: AppColors.labelGrey,
                        ),
                      ),
                    ),
            );
          }

          final start = e.startsAt;
          final end = e.endsAt;
          final status = statusFor(e, DateTime.now());

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
                      'UPCOMING EXAM',
                      style: AppFonts.sans(
                        size: 13,
                        weight: FontWeight.w700,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      e.courseCode,
                      style: AppFonts.sans(
                        size: 16,
                        weight: FontWeight.w700,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      e.courseName,
                      style: AppFonts.serif(
                        size: 22,
                        weight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    if (status != null) ...[
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: AppFonts.sans(
                            size: 14,
                            weight: FontWeight.w700,
                            color: AppColors.maroon,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 26),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  children: [
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
                    if (e.hall.isNotEmpty)
                      InfoRow(
                        icon: Icons.meeting_room_outlined,
                        label: 'Exam Hall',
                        value: e.hall,
                      ),
                    if (e.location.isNotEmpty)
                      InfoRow(
                        icon: Icons.place_outlined,
                        label: 'Location',
                        value: e.location,
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
