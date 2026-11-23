import 'package:material_ui/material_ui.dart';

import '../models/invigilator_model.dart';

class InvigilatorDashboardViewModel extends ChangeNotifier {
  InvigilatorRole _role;

  InvigilatorDashboardViewModel(this._role);

  InvigilatorRole get role => _role;
  bool get isHall => _role == InvigilatorRole.hallInvigilator;
  String get roleLabel => isHall ? 'Hall Invigilator' : 'Observer';

  void setHall(bool value) {
    _role = value ? InvigilatorRole.hallInvigilator : InvigilatorRole.observer;
    notifyListeners();
  }

  String get userName => 'User';
  String get examInfo =>
      "Today's exam is at DK8, N24,\nFaculty of Computing, UTM";

  int get quota => 2;

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
