// Nanti pecahkan ikut MVVM:
//   models/active_student.dart
//   viewmodels/invigilator_dashboard_viewmodel.dart
//   views/invigilator_dashboard_page.dart (+ ProfilePage, PlaceholderPage)

import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../viewmodels/auth_viewmodel.dart';

const kMaroon = Color(0xFF990000);
const kDarkGrey = Color(0xFF444444);
const kFemale = Color(0xFFFF8A8A);
const kMale = Color(0xFF4A7BFF);

// ───────────────────────── MODEL ─────────────────────────

enum InvigilatorRole { hallInvigilator, observer }

class ActiveStudent {
  final String name;
  final String matric;
  final String timer;
  final bool overTime;
  final bool isFemale;

  const ActiveStudent({
    required this.name,
    required this.matric,
    required this.timer,
    this.overTime = false,
    this.isFemale = false,
  });
}

class WaitingStudent {
  final String name;
  final String matric;
  final bool isFemale;

  const WaitingStudent({
    required this.name,
    required this.matric,
    this.isFemale = false,
  });
}

class DashboardAction {
  final String label;
  final IconData icon;
  final int badge;

  const DashboardAction(this.label, this.icon, {this.badge = 0});
}

// ───────────────────────── VIEWMODEL ─────────────────────────

class InvigilatorDashboardViewModel extends ChangeNotifier {
  InvigilatorRole _role;

  InvigilatorDashboardViewModel(this._role);

  InvigilatorRole get role => _role;
  bool get isHall => _role == InvigilatorRole.hallInvigilator;
  String get roleLabel => isHall ? 'Hall Invigilator' : 'Observer';

  // Switch ON = Hall Invigilator, OFF = Observer
  void setHall(bool value) {
    _role = value ? InvigilatorRole.hallInvigilator : InvigilatorRole.observer;
    notifyListeners();
  }

  String get userName => 'User';
  String get examInfo =>
      "Today's exam is at DK8, N24,\nFaculty of Computing, UTM";

  int get quota => 2;

  // Dikira terus dari senarai active supaya sentiasa konsisten
  int get femaleOut => activeStudents.where((s) => s.isFemale).length;
  int get maleOut => activeStudents.where((s) => !s.isFemale).length;
  bool get femaleFull => femaleOut >= quota;
  bool get maleFull => maleOut >= quota;

  int get totalFemaleBreaks => 3;
  int get totalMaleBreaks => 4;

  int get unreadChats => 1;

  final List<ActiveStudent> activeStudents = const [
    ActiveStudent(
      name: 'Nurul Binti Samad',
      matric: 'A270000',
      timer: '15:00',
      overTime: true,
      isFemale: true,
    ),
    ActiveStudent(
      name: 'Aina Binti Hassan',
      matric: 'A270002',
      timer: '7:30',
      isFemale: true,
    ),
    ActiveStudent(name: 'Ahmad Bin Ali', matric: 'A270001', timer: '3:00'),
  ];

  final List<WaitingStudent> waitingStudents = const [
    WaitingStudent(name: 'Siti Binti Ahmad', matric: 'A270003', isFemale: true),
    WaitingStudent(name: 'Farah Binti Omar', matric: 'A270004', isFemale: true),
  ];

  String get quotaNote {
    final parts = <String>[
      if (femaleFull) 'Female full',
      if (maleFull) 'Male full',
    ];
    return parts.join(' · ');
  }

  List<DashboardAction> get actions {
    final chat = DashboardAction(
      'In-App\nChat',
      Icons.chat_bubble,
      badge: unreadChats,
    );
    const detail = DashboardAction('Examination\nDetail', Icons.fact_check);

    if (!isHall) return [chat, detail];

    return [
      const DashboardAction('QR Scan', Icons.qr_code_scanner),
      const DashboardAction('Manual\nCheck-In', Icons.edit_note),
      chat,
      detail,
    ];
  }
}

// ───────────────────────── VIEW ─────────────────────────

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMaroon,
        foregroundColor: Colors.white,
        title: Text(title),
      ),
      body: Center(
        child: Text(
          '$title\n(coming soon)',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: Colors.black54),
        ),
      ),
    );
  }
}

void _open(BuildContext context, String title) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (_) => PlaceholderPage(title: title)));
}

void _openProfile(BuildContext context, String roleLabel) {
  Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (_) => ProfilePage(roleLabel: roleLabel)));
}

class ProfilePage extends StatelessWidget {
  final String roleLabel;
  const ProfilePage({super.key, required this.roleLabel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMaroon,
        foregroundColor: Colors.white,
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: kMaroon,
              child: Icon(Icons.person, color: Colors.white, size: 56),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'User',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Center(child: Text(roleLabel)),
          const SizedBox(height: 24),
          const ListTile(
            leading: Icon(Icons.badge_outlined),
            title: Text('Staff ID'),
            subtitle: Text('S000000'),
          ),
          const ListTile(
            leading: Icon(Icons.email_outlined),
            title: Text('Email'),
            subtitle: Text('user@utm.my'),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: kMaroon),
            onPressed: () => _open(context, 'Edit Profile'),
            icon: const Icon(Icons.edit),
            label: const Text('Edit Profile'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => _open(context, 'Change Password'),
            icon: const Icon(Icons.lock_outline),
            label: const Text('Change Password'),
          ),
        ],
      ),
    );
  }
}

class InvigilatorDashboardView extends StatefulWidget {
  final InvigilatorRole initialRole;

  const InvigilatorDashboardView({
    super.key,
    this.initialRole = InvigilatorRole.hallInvigilator,
  });

  @override
  State<InvigilatorDashboardView> createState() =>
      _InvigilatorDashboardPageState();
}

class _InvigilatorDashboardPageState extends State<InvigilatorDashboardView> {
  late final InvigilatorDashboardViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = InvigilatorDashboardViewModel(widget.initialRole);
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: kMaroon,
            foregroundColor: Colors.white,
            actions: [
              // Switch role: ON = Hall Invigilator, OFF = Observer
              Text(vm.roleLabel, style: const TextStyle(fontSize: 12)),
              Switch(
                value: vm.isHall,
                onChanged: vm.setHall,
                thumbColor: const WidgetStatePropertyAll(Colors.white),
                trackColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? Colors.black38
                      : Colors.white24,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => _open(context, 'Settings'),
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(color: kMaroon),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'SmartPass',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    _openProfile(context, vm.roleLabel);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    _open(context, 'Settings');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    Navigator.pop(context);
                    // Call your AuthViewModel to logout
                    // Make sure to import provider and your viewmodel at the top
                    context.read<AuthViewModel>().logout();
                  },
                ),
              ],
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(14),
            children: [
              _GreetingCard(
                vm: vm,
                onTap: () => _openProfile(context, vm.roleLabel),
              ),
              const SizedBox(height: 12),
              if (vm.isHall) ...[
                _StatsRow(vm: vm, onTap: (title) => _open(context, title)),
                const SizedBox(height: 12),
              ],
              _ActiveStudentsCard(
                students: vm.activeStudents,
                onTap: (s) => _open(context, s.name),
              ),
              const SizedBox(height: 12),
              _WaitingCard(vm: vm, onTap: (s) => _open(context, s.name)),
              const SizedBox(height: 12),
              _ActionGrid(
                actions: vm.actions,
                onTap: (a) => _open(context, a.label.replaceAll('\n', ' ')),
              ),
            ],
          ),
          bottomNavigationBar: _BottomNav(
            onBook: () => _open(context, 'Exam Records'),
            onHome: () {}, // dah kat home
            onProfile: () => _openProfile(context, vm.roleLabel),
          ),
        );
      },
    );
  }
}

class _GreetingCard extends StatelessWidget {
  final InvigilatorDashboardViewModel vm;
  final VoidCallback onTap;
  const _GreetingCard({required this.vm, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kMaroon,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: kMaroon, size: 34),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good Morning, ${vm.userName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vm.examInfo,
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final InvigilatorDashboardViewModel vm;
  final void Function(String title) onTap;
  const _StatsRow({required this.vm, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _DarkCard(
              title: 'Active Out',
              onTap: () => onTap('Active Out'),
              child: Column(
                children: [
                  _QuotaBar(
                    label: 'Female',
                    out: vm.femaleOut,
                    quota: vm.quota,
                    color: kFemale,
                  ),
                  const SizedBox(height: 8),
                  _QuotaBar(
                    label: 'Male',
                    out: vm.maleOut,
                    quota: vm.quota,
                    color: kMale,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _DarkCard(
              title: 'Total Breaks',
              onTap: () => onTap('Total Breaks'),
              child: Row(
                children: [
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: CustomPaint(
                      painter: _DonutPainter(
                        male: vm.totalMaleBreaks,
                        female: vm.totalFemaleBreaks,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _Legend(color: kMale, text: 'Male'),
                        SizedBox(height: 4),
                        _Legend(color: kFemale, text: 'Female'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DarkCard extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onTap;
  const _DarkCard({
    required this.title,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kDarkGrey,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _QuotaBar extends StatelessWidget {
  final String label;
  final int out;
  final int quota;
  final Color color;
  const _QuotaBar({
    required this.label,
    required this.out,
    required this.quota,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: out / quota,
              minHeight: 12,
              color: color,
              backgroundColor: Colors.white24,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$out/$quota',
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 10)),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String text;
  const _Legend({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 10)),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  final int male;
  final int female;
  _DonutPainter({required this.male, required this.female});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.24;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final total = male + female;

    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = Colors.white24;

    if (total == 0) {
      canvas.drawArc(rect, 0, 2 * pi, false, base);
      return;
    }

    final maleSweep = 2 * pi * male / total;
    final femaleSweep = 2 * pi * female / total;

    canvas.drawArc(rect, -pi / 2, maleSweep, false, base..color = kMale);
    canvas.drawArc(
      rect,
      -pi / 2 + maleSweep,
      femaleSweep,
      false,
      base..color = kFemale,
    );
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) =>
      old.male != male || old.female != female;
}

class _ActiveStudentsCard extends StatelessWidget {
  final List<ActiveStudent> students;
  final void Function(ActiveStudent) onTap;
  const _ActiveStudentsCard({required this.students, required this.onTap});

  Widget _section(String title, List<ActiveStudent> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 6, 4, 4),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (list.isEmpty)
          const Padding(
            padding: EdgeInsets.fromLTRB(4, 0, 4, 6),
            child: Text(
              'No one out',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          )
        else
          ...list.map(
            (s) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: _StudentTile(student: s, onTap: () => onTap(s)),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final female = students.where((s) => s.isFemale).toList();
    final male = students.where((s) => !s.isFemale).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kDarkGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _section('Female', female),
          const SizedBox(height: 6),
          _section('Male', male),
        ],
      ),
    );
  }
}

class _StudentTile extends StatelessWidget {
  final ActiveStudent student;
  final VoidCallback onTap;
  const _StudentTile({required this.student, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFEDEDED),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.account_circle_outlined, size: 34),
                  if (student.overTime)
                    Positioned(
                      left: -2,
                      top: -2,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: kMaroon,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  Text(student.matric, style: const TextStyle(fontSize: 11)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: kMaroon,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.white, size: 22),
                  const SizedBox(width: 6),
                  Text(
                    student.timer,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
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

class _WaitingCard extends StatelessWidget {
  final InvigilatorDashboardViewModel vm;
  final void Function(WaitingStudent) onTap;
  const _WaitingCard({required this.vm, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final list = vm.waitingStudents;
    var femaleCount = 0;
    var maleCount = 0;

    final rows = list.map((s) {
      final position = s.isFemale ? ++femaleCount : ++maleCount;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: _WaitingTile(
          student: s,
          position: position,
          onTap: () => onTap(s),
        ),
      );
    }).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kMaroon, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
            child: Row(
              children: [
                Text(
                  'Waiting (${list.length})',
                  style: const TextStyle(
                    color: kMaroon,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (vm.quotaNote.isNotEmpty)
                  Text(
                    vm.quotaNote,
                    style: const TextStyle(
                      color: kMaroon,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
          if (list.isEmpty)
            const Padding(
              padding: EdgeInsets.fromLTRB(4, 0, 4, 6),
              child: Text(
                'No one waiting',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
            )
          else
            ...rows,
        ],
      ),
    );
  }
}

class _WaitingTile extends StatelessWidget {
  final WaitingStudent student;
  final int position;
  final VoidCallback onTap;
  const _WaitingTile({
    required this.student,
    required this.position,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final gender = student.isFemale ? 'Female' : 'Male';
    return Material(
      color: const Color(0xFFEDEDED),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: student.isFemale ? kFemale : kMale,
                child: Text(
                  '$position',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      '${student.matric} · $gender queue',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.hourglass_empty, color: kMaroon),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionGrid extends StatelessWidget {
  final List<DashboardAction> actions;
  final void Function(DashboardAction) onTap;
  const _ActionGrid({required this.actions, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.15,
      children: actions
          .map((a) => _ActionTile(action: a, onTap: () => onTap(a)))
          .toList(),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final DashboardAction action;
  final VoidCallback onTap;
  const _ActionTile({required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: Material(
            color: kMaroon,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: onTap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(action.icon, color: Colors.white, size: 56),
                  const SizedBox(height: 6),
                  Text(
                    action.label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (action.badge > 0)
          Positioned(
            right: -4,
            top: -6,
            child: CircleAvatar(
              radius: 12,
              backgroundColor: kDarkGrey,
              child: Text(
                '${action.badge}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }
}

class _BottomNav extends StatelessWidget {
  final VoidCallback onBook;
  final VoidCallback onHome;
  final VoidCallback onProfile;
  const _BottomNav({
    required this.onBook,
    required this.onHome,
    required this.onProfile,
  });

  Widget _item(IconData icon, VoidCallback onTap, {bool selected = false}) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: kMaroon,
        child: Icon(icon, color: selected ? Colors.white : Colors.white70),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _item(Icons.menu_book, onBook),
            _item(Icons.home, onHome, selected: true),
            _item(Icons.person, onProfile),
          ],
        ),
      ),
    );
  }
}
