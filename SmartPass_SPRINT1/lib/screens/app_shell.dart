import 'package:material_ui/material_ui.dart';
import '../models/exam.dart';
import '../models/user_profile.dart';
import '../services/firestore_service.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_header.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/settings_sheet.dart';
import 'exam_slip_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'washroom_history_screen.dart';

/// Header + three tabs (exam slip / home / profile) + bottom nav circles.
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.profile});

  final UserProfile profile;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const _slipTab = 0;
  static const _homeTab = 1;

  int _index = _homeTab;
  late Stream<Exam?> _examStream =
      FirestoreService.instance.watchExam(widget.profile.examId);

  @override
  void didUpdateWidget(covariant AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile.examId != widget.profile.examId) {
      _examStream = FirestoreService.instance.watchExam(widget.profile.examId);
    }
  }

  void _openWashroomHistory() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => WashroomHistoryScreen(profile: widget.profile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    final titles = <String?>['Examination Slip', null, profile.profileTitle];

    return StreamBuilder<Exam?>(
      stream: _examStream,
      builder: (context, snap) {
        final exam = snap.data;
        final loading = snap.connectionState == ConnectionState.waiting;

        return Scaffold(
          appBar: AppHeader(
            title: titles[_index],
            onSettings: () => showSettingsSheet(context, profile),
          ),
          drawer: AppDrawer(
            profile: profile,
            items: [
              DrawerItem(Icons.home_rounded, 'Home',
                  () => setState(() => _index = _homeTab)),
              DrawerItem(Icons.description_outlined, 'Examination Slip',
                  () => setState(() => _index = _slipTab)),
              DrawerItem(Icons.history, 'Washroom Break History',
                  _openWashroomHistory),
              DrawerItem(Icons.person_outline, 'Profile',
                  () => setState(() => _index = 2)),
            ],
          ),
          body: IndexedStack(
            index: _index,
            children: [
              ExamSlipScreen(profile: profile, exam: exam, loading: loading),
              HomeScreen(
                profile: profile,
                exam: exam,
                loading: loading,
                onOpenExamSlip: () => setState(() => _index = _slipTab),
                onOpenWashroomHistory: _openWashroomHistory,
              ),
              ProfileScreen(profile: profile),
            ],
          ),
          bottomNavigationBar: AppBottomNav(
            currentIndex: _index,
            onTap: (i) => setState(() => _index = i),
          ),
        );
      },
    );
  }
}
