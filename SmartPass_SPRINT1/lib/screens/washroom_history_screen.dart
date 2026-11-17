import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../models/washroom_break.dart';
import '../services/firestore_service.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/app_header.dart';

/// Students see their own breaks; invigilators see every break in their exam.
class WashroomHistoryScreen extends StatefulWidget {
  const WashroomHistoryScreen({super.key, required this.profile});

  final UserProfile profile;

  @override
  State<WashroomHistoryScreen> createState() => _WashroomHistoryScreenState();
}

class _WashroomHistoryScreenState extends State<WashroomHistoryScreen> {
  late final Stream<List<WashroomBreak>> _stream = widget.profile.isStudent
      ? FirestoreService.instance.watchBreaksForStudent(widget.profile.uid)
      : FirestoreService.instance.watchBreaksForExam(widget.profile.examId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Washroom Break History', showBack: true),
      body: StreamBuilder<List<WashroomBreak>>(
        stream: _stream,
        builder: (context, snap) {
          if (snap.hasError) {
            return _Message('Could not load the break history.');
          }
          if (!snap.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.maroon),
            );
          }
          final breaks = snap.data!;
          if (breaks.isEmpty) {
            return _Message('No washroom breaks recorded.');
          }
          return ListView.separated(
            padding: const EdgeInsets.all(14),
            itemCount: breaks.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (_, i) => _BreakCard(
              item: breaks[i],
              showStudent: !widget.profile.isStudent,
            ),
          );
        },
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppFonts.serif(size: 16, color: AppColors.labelGrey),
          ),
        ),
      );
}

class _BreakCard extends StatelessWidget {
  const _BreakCard({required this.item, required this.showStudent});

  final WashroomBreak item;
  final bool showStudent;

  @override
  Widget build(BuildContext context) {
    final inAt = item.inAt;
    final duration = item.duration;
    final times = inAt == null
        ? 'Out ${formatTime(item.outAt)} · still out'
        : 'Out ${formatTime(item.outAt)} · In ${formatTime(inAt)}'
            '${duration == null ? '' : ' (${formatDuration(duration)})'}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.maroon,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          const Icon(Icons.history, size: 40, color: AppColors.onMaroonSoft),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showStudent && item.studentName.isNotEmpty)
                  Text(
                    item.studentName,
                    style: AppFonts.serif(
                      size: 16,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                Text(
                  formatDate(item.outAt),
                  style: AppFonts.serif(
                    size: showStudent ? 13 : 16,
                    weight: showStudent ? FontWeight.w400 : FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  times,
                  style: AppFonts.sans(
                    size: 14,
                    weight: FontWeight.w600,
                    color: Colors.white,
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
