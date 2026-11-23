import 'package:material_ui/material_ui.dart';

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
