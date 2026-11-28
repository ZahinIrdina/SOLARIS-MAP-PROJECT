import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../viewmodels/hall_movement_viewmodel.dart';
import '../services/firestore_service.dart';
import '../models/washroom_break.dart';
import '../utils/format.dart'; // Assuming you have formatDate/formatTime here

class HallMovementView extends StatelessWidget {
  const HallMovementView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HallMovementViewModel>();
    const maroon = Color(0xFF990000);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: maroon,
        foregroundColor: Colors.white,
        title: const Text('Hall Movement Logs'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (vm.selectedYear != null) {
              vm.goBack(); // Go back one level
            } else {
              Navigator.pop(context); // Exit screen
            }
          },
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildCurrentScreen(context, vm),
      ),
    );
  }

  Widget _buildCurrentScreen(BuildContext context, HallMovementViewModel vm) {
    if (vm.selectedCourse != null) {
      return _CourseLogsScreen(courseCode: vm.selectedCourse!, courseName: _getCourseName(vm));
    } else if (vm.selectedYear != null) {
      return _CourseSelectionScreen(vm: vm);
    } else {
      return _YearSelectionScreen(vm: vm);
    }
  }

  String _getCourseName(HallMovementViewModel vm) {
    final courses = vm.coursesForSelectedYear;
    final course = courses.firstWhere((c) => c['code'] == vm.selectedCourse, orElse: () => {});
    return course['name'] ?? '';
  }
}

// ─────────────────────────────────────────────
// SCREEN 1: YEAR SELECTION
// ─────────────────────────────────────────────
class _YearSelectionScreen extends StatelessWidget {
  final HallMovementViewModel vm;
  const _YearSelectionScreen({required this.vm});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('2026/2027 - 1', style: TextStyle(fontSize: 18, color: Colors.black54)),
        const SizedBox(height: 20),
        ...vm.years.map((year) => Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: _buildMaroonButton(
            text: year,
            onTap: () => vm.selectYear(year),
          ),
        )),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// SCREEN 2: COURSE SELECTION
// ─────────────────────────────────────────────
class _CourseSelectionScreen extends StatelessWidget {
  final HallMovementViewModel vm;
  const _CourseSelectionScreen({required this.vm});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Courses', style: TextStyle(fontSize: 18, color: Colors.black54)),
        const SizedBox(height: 20),
        ...vm.coursesForSelectedYear.map((course) => Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: _buildMaroonButton(
            text: '${course['code']} - ${course['name']}',
            onTap: () => vm.selectCourse(course['code']!),
          ),
        )),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// SCREEN 3: COMPLETED LOGS
// ─────────────────────────────────────────────
class _CourseLogsScreen extends StatelessWidget {
  final String courseCode;
  final String courseName;
  const _CourseLogsScreen({required this.courseCode, required this.courseName});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<WashroomBreak>>(
      stream: FirestoreService.instance.getCompletedBreaksForCourse(courseCode),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No completed logs found for this course.'));
        }

        final logs = snapshot.data!;

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('Completed Log', style: TextStyle(fontSize: 18, color: Colors.black54)),
            const SizedBox(height: 15),
            ...logs.map((log) => _buildLogCard(log)),
          ],
        );
      },
    );
  }

  Widget _buildLogCard(WashroomBreak log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                log.studentName,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF990000)),
              ),
              if (log.inAt != null)
                Text(
                  '${formatTime(log.outAt)} - ${formatTime(log.inAt!)}',
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
            ],
          ),
          const SizedBox(height: 5),
          Text('${log.studentId} · ${log.examId}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 5),
          Text(formatDate(log.outAt), style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// HELPER WIDGET
// ─────────────────────────────────────────────
Widget _buildMaroonButton({required String text, required VoidCallback onTap}) {
  return ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF990000),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      alignment: Alignment.centerLeft,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const Icon(Icons.arrow_forward_ios, size: 16),
      ],
    ),
  );
}