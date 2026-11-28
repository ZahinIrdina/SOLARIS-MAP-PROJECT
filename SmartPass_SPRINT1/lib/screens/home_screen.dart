import 'package:material_ui/material_ui.dart';
import '../models/exam.dart';
import '../models/user_profile.dart';
import '../widgets/greeting_card.dart';
import '../widgets/home_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.profile,
    required this.exam,
    required this.loading,
    required this.onOpenExamSlip,
    required this.onOpenExamInfo,
    required this.onOpenWashroomHistory,
  });

  final UserProfile profile;
  final Exam? exam;
  final bool loading;
  final VoidCallback onOpenExamSlip;
  final VoidCallback onOpenExamInfo;
  final VoidCallback onOpenWashroomHistory;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
      children: [
        GreetingCard(profile: profile, exam: exam, loading: loading),
        const SizedBox(height: 24),
        HomeTile(
          icon: Icons.description_outlined,
          title: 'Examination\nSlip',
          onTap: onOpenExamSlip,
        ),
        const SizedBox(height: 10),
        HomeTile(
          icon: Icons.event_note_outlined,
          title: 'Examination\nInformation',
          onTap: onOpenExamInfo,
        ),
        const SizedBox(height: 10),
        HomeTile(
          icon: Icons.history,
          iconSize: 92,
          title: 'Washroom\nBreak History',
          onTap: onOpenWashroomHistory,
        ),
      ],
    );
  }
}
